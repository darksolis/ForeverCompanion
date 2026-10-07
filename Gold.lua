local FC = _G.ForeverCompanion

local function safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e, f, g, h, i, j, k, l = pcall(fn, ...)
    if ok then return a, b, c, d, e, f, g, h, i, j, k, l end
    return nil
end

local function now()
    return GetTime and GetTime() or 0
end

local function itemIDFromLink(link)
    return link and tonumber(tostring(link):match("item:(%d+)")) or nil
end

local function lootQuantity(message)
    if type(message) ~= "string" then return 1 end
    local qty = tonumber(message:match("[xX](%d+)%s*$"))
        or tonumber(message:match("[xX](%d+)%p?%s*$"))
    return math.max(1, qty or 1)
end

local function isLikelyPlayerLoot(message)
    if type(message) ~= "string" then return false end
    -- Forever is enUS for this build. Avoid counting party members' loot.
    if message:match("^You ") or message:find("You receive", 1, true) or message:find("You create", 1, true) then
        return true
    end
    return false
end

local function fmtCopper(copper)
    copper = math.max(0, math.floor(tonumber(copper) or 0))
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copperOnly = copper % 100
    if gold > 0 then
        return string.format("%dg %02ds %02dc", gold, silver, copperOnly)
    elseif silver > 0 then
        return string.format("%ds %02dc", silver, copperOnly)
    else
        return string.format("%dc", copperOnly)
    end
end

function FC:FormatMoneyCopper(copper)
    return fmtCopper(copper)
end

function FC:GetAuctionatorPrices(itemLink)
    local result = {
        source = "none",
        market = nil,
        minBuyout = nil,
        scanAgeDays = nil,
        exact = nil,
    }

    if not itemLink or not self.db or not self.db.goldFarming or self.db.goldFarming.useAuctionator == false then
        return result
    end

    local auctionator = _G.Auctionator
    local api = auctionator and auctionator.API and auctionator.API.v1
    if type(api) ~= "table" then return result end

    local callerID = "ForeverCompanion"

    local price = safe(api.GetAuctionPriceByItemLink, callerID, itemLink)
    price = self:ReadableNumber(price)
    if (not price or price <= 0) and type(api.GetAuctionPriceByItemID) == "function" then
        local itemID = itemIDFromLink(itemLink)
        if itemID then
            price = self:ReadableNumber(safe(api.GetAuctionPriceByItemID, callerID, itemID))
        end
    end
    if price and price > 0 then
        -- Auctionator's public API describes this as the last scanned auction price.
        -- Treat it as the scan-based AH value, not a guaranteed sale price.
        result.market = price
        result.minBuyout = price
        result.source = "Auctionator Scan"
    end

    if type(api.GetAuctionAgeByItemLink) == "function" then
        local age = safe(api.GetAuctionAgeByItemLink, callerID, itemLink)
        age = self:ReadableNumber(age)
        if age == nil and type(api.GetAuctionAgeByItemID) == "function" then
            local itemID = itemIDFromLink(itemLink)
            if itemID then age = self:ReadableNumber(safe(api.GetAuctionAgeByItemID, callerID, itemID)) end
        end
        if age ~= nil and age >= 0 then
            result.scanAgeDays = age
        end
    end

    if type(api.IsAuctionDataExactByItemLink) == "function" then
        local exact = safe(api.IsAuctionDataExactByItemLink, callerID, itemLink)
        if type(exact) == "boolean" then
            result.exact = exact
        end
    end

    return result
end

function FC:GetItemPriceSnapshot(itemLink)
    if not itemLink then return nil end

    local name, _, quality, _, _, _, _, _, _, _, vendor = safe(GetItemInfo, itemLink)
    vendor = self:ReadableNumber(vendor) or 0
    local itemID = itemIDFromLink(itemLink)
    local auction = self:GetAuctionatorPrices(itemLink)

    return {
        itemID = itemID,
        link = itemLink,
        name = name or itemLink,
        quality = self:ReadableNumber(quality),
        vendor = vendor,
        market = auction.market,
        minBuyout = auction.minBuyout,
        scanAgeDays = auction.scanAgeDays,
        exact = auction.exact,
        source = auction.source,
        at = time and time() or 0,
    }
end

function FC:InitializeGoldTracking()
    self.state.gold = self.state.gold or {}
    local gold = self.state.gold
    local money = type(GetMoney) == "function" and self:ReadableNumber(safe(GetMoney)) or nil
    gold.lastMoney = money

    self.db.sharedMemory = self.db.sharedMemory or {}
    self.db.sharedMemory.goldFarming = self.db.sharedMemory.goldFarming or {
        sessions = {},
        items = {},
        totalMarket = 0,
        totalVendor = 0,
        totalCash = 0,
    }
end

function FC:IsGoldFarmActive()
    return self.state.gold and self.state.gold.active == true
end

function FC:StartGoldFarm(label, silent)
    self:InitializeGoldTracking()
    if self.RefreshGoldIntegration then self:RefreshGoldIntegration() end
    local gold = self.state.gold
    local money = type(GetMoney) == "function" and self:ReadableNumber(safe(GetMoney)) or 0
    gold.active = true
    gold.startedAt = now()
    gold.startedUnix = time and time() or 0
    gold.label = label and label ~= "" and label or (self.state.zone or "Farm")
    gold.startMoney = money or 0
    gold.lastMoney = money or 0
    gold.cashEarned = 0
    gold.fieldCashEarned = 0
    gold.cashSpent = 0
    gold.vendorValue = 0
    gold.marketValue = 0
    gold.minBuyoutValue = 0
    gold.lootEvents = 0
    gold.itemQuantity = 0
    gold.items = {}
    gold.lastPaceComment = now()
    gold.lastPaceLootEvents = 0
    gold.lastValuableTalk = 0
    gold.paceHistory = {}

    if not silent then
        local auc = self.state.integrations and self.state.integrations.Auctionator
        local source = auc and "Auctionator scan data is connected." or "Auctionator is not connected yet, so I'll use vendor value until it is."
        self:Say("Gold farm tracking started. " .. source, "think", 100, true, {
            topic = "goldstart", category = "gold", facts = self:CaptureFacts("gold farm start"), reason = "manual gold farm start",
        })
    end

    if self.RefreshGoldPage then self:RefreshGoldPage() end
    return gold
end

function FC:StopGoldFarm(silent)
    local gold = self.state.gold
    if not gold or not gold.active then return nil end
    gold.active = false
    gold.endedAt = now()
    gold.endedUnix = time and time() or 0

    local summary = self:GetGoldFarmSummary(gold)
    self.db.sharedMemory.goldFarming = self.db.sharedMemory.goldFarming or { sessions = {}, items = {} }
    local history = self.db.sharedMemory.goldFarming.sessions or {}
    self.db.sharedMemory.goldFarming.sessions = history
    history[#history + 1] = {
        characterKey = self.characterKey,
        character = self.character and self.character.memory and self.character.memory.profile and self.character.memory.profile.name or nil,
        label = gold.label,
        started = gold.startedUnix,
        ended = gold.endedUnix,
        seconds = summary.seconds,
        cashEarned = gold.cashEarned or 0,
        fieldCashEarned = gold.fieldCashEarned or 0,
        cashSpent = gold.cashSpent or 0,
        vendorValue = gold.vendorValue or 0,
        marketValue = gold.marketValue or 0,
        minBuyoutValue = gold.minBuyoutValue or 0,
        lootEvents = gold.lootEvents or 0,
        itemQuantity = gold.itemQuantity or 0,
        marketPerHour = summary.marketPerHour,
        vendorPerHour = summary.vendorPerHour,
    }
    while #history > 50 do table.remove(history, 1) end
    local aggregate = self.db.sharedMemory.goldFarming
    aggregate.totalMarket = (aggregate.totalMarket or 0) + (gold.marketValue or 0)
    aggregate.totalVendor = (aggregate.totalVendor or 0) + (gold.vendorValue or 0)
    aggregate.totalCash = (aggregate.totalCash or 0) + math.max(0, (gold.cashEarned or 0) - (gold.cashSpent or 0))
    aggregate.bestMarketPerHour = math.max(aggregate.bestMarketPerHour or 0, summary.marketPerHour or 0)
    aggregate.bestVendorPerHour = math.max(aggregate.bestVendorPerHour or 0, summary.vendorPerHour or 0)

    if not silent then
        self:Say(self:GoldFarmSummaryText(gold), "talk", 100, true, {
            topic = "goldstop", category = "gold", facts = self:CaptureFacts("gold farm stop"), reason = "manual gold farm stop",
        })
    end

    if self.RefreshGoldPage then self:RefreshGoldPage() end
    return summary
end

function FC:ResetGoldFarm()
    local active = self:IsGoldFarmActive()
    self:StartGoldFarm(self.state.gold and self.state.gold.label or nil, true)
    if not active then self.state.gold.active = false end
    if self.RefreshGoldPage then self:RefreshGoldPage() end
end

function FC:GetGoldFarmSummary(gold)
    gold = gold or self.state.gold or {}
    local stopAt = gold.active and now() or (gold.endedAt or now())
    local seconds = math.max(1, stopAt - (gold.startedAt or stopAt))
    local market = tonumber(gold.marketValue) or 0
    local vendor = tonumber(gold.vendorValue) or 0
    local minBuyout = tonumber(gold.minBuyoutValue) or 0
    local cashEarned = tonumber(gold.cashEarned) or 0
    local fieldCashEarned = tonumber(gold.fieldCashEarned) or 0
    local cashSpent = tonumber(gold.cashSpent) or 0
    local netCash = fieldCashEarned - cashSpent

    local function hourly(value)
        return value / seconds * 3600
    end

    local topItem, topValue = nil, 0
    for _, item in pairs(gold.items or {}) do
        local value = tonumber(item.marketValue) or tonumber(item.vendorValue) or 0
        if value > topValue then topItem, topValue = item, value end
    end

    return {
        seconds = seconds,
        market = market,
        vendor = vendor,
        minBuyout = minBuyout,
        cashEarned = cashEarned,
        fieldCashEarned = fieldCashEarned,
        cashSpent = cashSpent,
        netCash = netCash,
        marketPerHour = hourly(math.max(0, market + fieldCashEarned - cashSpent)),
        vendorPerHour = hourly(math.max(0, vendor + fieldCashEarned - cashSpent)),
        lootMarketPerHour = hourly(market),
        lootVendorPerHour = hourly(vendor),
        topItem = topItem,
        source = (self.state.integrations and self.state.integrations.Auctionator) and "Auctionator" or "Vendor only",
    }
end

function FC:GoldFarmSummaryText(gold)
    local s = self:GetGoldFarmSummary(gold)
    local activeText = gold and gold.active and "Current farm" or "Farm result"
    local text = string.format(
        "%s: %s elapsed. Auction value %s, vendor floor %s. Pace: %s/hour auction, %s/hour vendor.",
        activeText,
        self:FormatDuration(s.seconds),
        fmtCopper(s.market),
        fmtCopper(s.vendor),
        fmtCopper(s.marketPerHour),
        fmtCopper(s.vendorPerHour)
    )
    if s.topItem then
        text = text .. " Best item so far is " .. tostring(s.topItem.name or s.topItem.link or "an item") .. "."
    end
    return text
end

function FC:ShowGoldFarmStats()
    if not self.state.gold or not self.state.gold.startedAt then
        self:Say("I don't have an active gold-farm session yet. Right-click me and start one, or use /fc farm start.", "think", 100, true, {
            topic = "goldstats", category = "gold", facts = self:CaptureFacts("gold stats"), reason = "no active farm",
        })
        return
    end
    self:Say(self:GoldFarmSummaryText(self.state.gold), "think", 100, true, {
        topic = "goldstats", category = "gold", facts = self:CaptureFacts("gold stats"), reason = "requested gold farm stats",
    })
end

function FC:ToggleGoldFarm()
    if self:IsGoldFarmActive() then
        self:StopGoldFarm(false)
    else
        self:StartGoldFarm(nil, false)
    end
end

function FC:HandleGoldMoneyUpdate()
    self:InitializeGoldTracking()
    local current = type(GetMoney) == "function" and self:ReadableNumber(safe(GetMoney)) or nil
    if current == nil then return end

    local gold = self.state.gold
    local previous = self:ReadableNumber(gold.lastMoney)
    gold.lastMoney = current
    if previous == nil then return end

    local delta = current - previous
    if math.abs(delta) >= 50000 and type(self.QueuePersonalityVoiceCategory) == "function" then
        self:QueuePersonalityVoiceCategory("gold_change", { chance = 0.40, priority = 5, cooldown = 120, maxAge = 8, speechCategory = "gold", anim = delta > 0 and "playful" or "shrug", topic = "goldchange" })
    end
    if not gold.active then return end
    if delta > 0 then
        gold.cashEarned = (gold.cashEarned or 0) + delta
        local r = self.state.runtime or {}
        local inTownTransaction = r.merchantOpen or r.auctionOpen or r.mailOpen or r.bankOpen
        if not inTownTransaction then
            gold.fieldCashEarned = (gold.fieldCashEarned or 0) + delta
        end
    elseif delta < 0 then
        gold.cashSpent = (gold.cashSpent or 0) + math.abs(delta)
    end
end

function FC:TrackLootValue(message)
    if type(message) ~= "string" or not isLikelyPlayerLoot(message) then return end
    local link = message:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)") or message:match("(|Hitem:.-|h%[.-%]|h)")
    if not link then return end

    local qty = lootQuantity(message)
    local price = self:GetItemPriceSnapshot(link)
    if not price then return end

    -- We always learn values for future cross-character callbacks, even when a farm session is not active.
    self.db.sharedMemory.goldFarming = self.db.sharedMemory.goldFarming or { sessions = {}, items = {} }
    local persistentItems = self.db.sharedMemory.goldFarming.items or {}
    self.db.sharedMemory.goldFarming.items = persistentItems
    local key = price.itemID and tostring(price.itemID) or tostring(price.name)
    local known = persistentItems[key] or {}
    known.name = price.name
    known.link = price.link
    known.vendor = price.vendor
    known.market = price.market
    known.minBuyout = price.minBuyout
    known.scanAgeDays = price.scanAgeDays
    known.exact = price.exact
    known.source = price.source
    known.lastSeen = time and time() or 0
    known.timesLooted = (known.timesLooted or 0) + 1
    known.quantityLooted = (known.quantityLooted or 0) + qty
    persistentItems[key] = known

    local gold = self.state.gold
    if gold and gold.active then
        local row = gold.items[key] or { name = price.name, link = price.link, qty = 0, vendorValue = 0, marketValue = 0, minBuyoutValue = 0 }
        row.qty = (row.qty or 0) + qty
        row.vendorEach = price.vendor or 0
        row.marketEach = price.market
        row.minBuyoutEach = price.minBuyout
        row.vendorValue = (row.vendorValue or 0) + (price.vendor or 0) * qty
        row.marketValue = (row.marketValue or 0) + (price.market or 0) * qty
        row.minBuyoutValue = (row.minBuyoutValue or 0) + (price.minBuyout or 0) * qty
        gold.items[key] = row
        gold.vendorValue = (gold.vendorValue or 0) + (price.vendor or 0) * qty
        gold.marketValue = (gold.marketValue or 0) + (price.market or 0) * qty
        gold.minBuyoutValue = (gold.minBuyoutValue or 0) + (price.minBuyout or 0) * qty
        gold.lootEvents = (gold.lootEvents or 0) + 1
        gold.itemQuantity = (gold.itemQuantity or 0) + qty
    end

    local thresholdGold = tonumber(self.db.goldFarming and self.db.goldFarming.valuableGold) or 1
    local threshold = thresholdGold * 10000
    local eachMarket = tonumber(price.market) or 0
    local stackMarket = eachMarket * qty
    local vendorTotal = (tonumber(price.vendor) or 0) * qty
    local shouldTalk = self.db.goldFarming and self.db.goldFarming.commentary ~= false

    if shouldTalk and eachMarket > 0 and stackMarket >= threshold then
        local marketText = fmtCopper(eachMarket)
        local stackText = qty > 1 and ("; about " .. fmtCopper(stackMarket) .. " for this stack") or ""
        local ageText = ""
        if price.scanAgeDays ~= nil then
            if price.scanAgeDays == 0 then
                ageText = " from today's Auctionator scan"
            elseif price.scanAgeDays == 1 then
                ageText = " from Auctionator data about 1 day old"
            else
                ageText = " from Auctionator data about " .. tostring(math.floor(price.scanAgeDays)) .. " days old"
            end
        end
        self:QueueSay(
            tostring(price.name or link) .. " is about " .. marketText .. " each on Auctionator's last scan" .. stackText .. ageText .. ".",
            "playful",
            18,
            45,
            "goldvalue:" .. key,
            false,
            nil,
            { topic = "goldvalue", category = "gold", facts = self:CaptureFacts("gold item value"), reason = "valuable item looted" }
        )
    elseif shouldTalk and eachMarket == 0 and vendorTotal >= threshold then
        self:QueueSay(
            tostring(price.name or link) .. " is at least " .. fmtCopper(vendorTotal) .. " to a vendor for this loot.",
            "talk",
            10,
            90,
            "vendorvalue:" .. key,
            false,
            nil,
            { topic = "vendorvalue", category = "gold", facts = self:CaptureFacts("vendor item value"), reason = "high vendor value loot" }
        )
    end

    if gold and gold.active then self:MaybeCommentGoldPace() end
    if self.RefreshGoldPage then self:RefreshGoldPage() end
end

function FC:MaybeCommentGoldPace()
    local gold = self.state.gold
    if not gold or not gold.active or not self.db.goldFarming or self.db.goldFarming.commentary == false then return end
    local interval = (tonumber(self.db.goldFarming.paceMinutes) or 5) * 60
    if now() - (gold.lastPaceComment or gold.startedAt or now()) < interval then return end
    if (gold.lootEvents or 0) <= (gold.lastPaceLootEvents or 0) then return end

    gold.lastPaceComment = now()
    gold.lastPaceLootEvents = gold.lootEvents or 0
    -- Pull fresh values from Auctionator's stored database before each pace checkpoint.
    -- This means a scan performed during the farm can update already-looted items.
    self:RevalueGoldSession()
    local s = self:GetGoldFarmSummary(gold)
    gold.paceHistory = gold.paceHistory or {}
    local previous = gold.paceHistory[#gold.paceHistory]
    local currentRate = s.market > 0 and s.marketPerHour or s.vendorPerHour
    local line
    if s.market > 0 then
        line = "Gold pace check: about " .. fmtCopper(s.marketPerHour) .. "/hour using Auctionator scanned AH value. Vendor floor is " .. fmtCopper(s.vendorPerHour) .. "/hour."
    else
        line = "Gold pace check: about " .. fmtCopper(s.vendorPerHour) .. "/hour at vendor value. I still don't have Auctionator scan data for these drops."
    end
    if previous and previous.rate and previous.rate > 0 then
        local change = (currentRate - previous.rate) / previous.rate
        if change >= 0.15 then
            line = line .. " That's up about " .. tostring(math.floor(change * 100)) .. "% from the last pace check."
        elseif change <= -0.15 then
            line = line .. " That's down about " .. tostring(math.floor(math.abs(change) * 100)) .. "% from the last pace check."
        end
    end
    gold.paceHistory[#gold.paceHistory + 1] = { at = now(), rate = currentRate }
    while #gold.paceHistory > 12 do table.remove(gold.paceHistory, 1) end
    self:QueueSay(line, "think", 12, interval, "goldpace", false, nil, {
        topic = "goldpace", category = "gold", facts = self:CaptureFacts("gold pace"), reason = "periodic farm pace check",
    })
end

function FC:GetKnownGoldItem(itemLink)
    local price = self:GetItemPriceSnapshot(itemLink)
    if not price then return nil end
    return price
end

function FC:ShowGoldValue(itemLink)
    if not itemLink or itemLink == "" then
        self:Say("Shift-click an item into /fc value and I'll compare Auctionator and vendor value.", "think", 100, true)
        return
    end
    local link = itemLink:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)") or itemLink:match("(|Hitem:.-|h%[.-%]|h)") or itemLink
    local p = self:GetItemPriceSnapshot(link)
    if not p then
        self:Say("I couldn't read that item yet.", "shrug", 100, true)
        return
    end
    local text = tostring(p.name or link) .. ": vendor " .. fmtCopper(p.vendor or 0)
    if p.market and p.market > 0 then text = text .. ", Auctionator last scanned AH price " .. fmtCopper(p.market) end
    if p.scanAgeDays ~= nil then text = text .. ", scan age " .. tostring(math.floor(p.scanAgeDays)) .. " day(s)" end
    text = text .. "."
    self:Say(text, "think", 100, true, { topic = "goldvalue", category = "gold", facts = self:CaptureFacts("manual item value"), reason = "requested item value" })
end

function FC:RevalueGoldSession()
    local gold = self.state.gold
    if not gold or not gold.items then return end
    local vendorTotal, marketTotal, minBuyoutTotal = 0, 0, 0
    for key, row in pairs(gold.items) do
        local link = row.link
        local qty = tonumber(row.qty) or 0
        if link and qty > 0 then
            local price = self:GetItemPriceSnapshot(link)
            if price then
                row.name = price.name or row.name
                row.vendorEach = price.vendor or 0
                row.marketEach = price.market
                row.minBuyoutEach = price.minBuyout
                row.vendorValue = (price.vendor or 0) * qty
                row.marketValue = (price.market or 0) * qty
                row.minBuyoutValue = (price.minBuyout or 0) * qty
            end
        end
        vendorTotal = vendorTotal + (tonumber(row.vendorValue) or 0)
        marketTotal = marketTotal + (tonumber(row.marketValue) or 0)
        minBuyoutTotal = minBuyoutTotal + (tonumber(row.minBuyoutValue) or 0)
    end
    gold.vendorValue = vendorTotal
    gold.marketValue = marketTotal
    gold.minBuyoutValue = minBuyoutTotal
    if self.RefreshGoldPage then self:RefreshGoldPage() end
end

function FC:RefreshGoldIntegration()
    if self.RefreshIntegrations then self:RefreshIntegrations() end
    return self.state.integrations and self.state.integrations.Auctionator
end
