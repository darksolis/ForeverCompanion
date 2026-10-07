local FC = _G.ForeverCompanion

local EQUIP_SLOTS = {
    INVTYPE_HEAD = { 1 },
    INVTYPE_NECK = { 2 },
    INVTYPE_SHOULDER = { 3 },
    INVTYPE_BODY = { 4 },
    INVTYPE_CHEST = { 5 },
    INVTYPE_ROBE = { 5 },
    INVTYPE_WAIST = { 6 },
    INVTYPE_LEGS = { 7 },
    INVTYPE_FEET = { 8 },
    INVTYPE_WRIST = { 9 },
    INVTYPE_HAND = { 10 },
    INVTYPE_FINGER = { 11, 12 },
    INVTYPE_TRINKET = { 13, 14 },
    INVTYPE_CLOAK = { 15 },
    INVTYPE_WEAPON = { 16, 17 },
    INVTYPE_2HWEAPON = { 16 },
    INVTYPE_WEAPONMAINHAND = { 16 },
    INVTYPE_WEAPONOFFHAND = { 17 },
    INVTYPE_HOLDABLE = { 17 },
    INVTYPE_SHIELD = { 17 },
    INVTYPE_RANGED = { 18 },
    INVTYPE_RANGEDRIGHT = { 18 },
    INVTYPE_THROWN = { 18 },
    INVTYPE_RELIC = { 18 },
}

local function safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e, f, g, h, i, j, k = pcall(fn, ...)
    if ok then return a, b, c, d, e, f, g, h, i, j, k end
    return nil
end

local function cleanName(name)
    if type(name) ~= "string" then return nil end
    return name:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local function lower(s)
    return type(s) == "string" and string.lower(s) or ""
end

local function currentClassAndSpec()
    local _, classToken, classID = safe(UnitClass, "player")
    local specID = nil
    if type(GetSpecialization) == "function" and type(GetSpecializationInfo) == "function" then
        local specIndex = safe(GetSpecialization)
        if specIndex then specID = safe(GetSpecializationInfo, specIndex) end
    end
    return classToken, classID, specID
end

local function itemLevel(itemInfo)
    if not itemInfo then return nil end
    if C_Item and type(C_Item.GetDetailedItemLevelInfo) == "function" then
        local level = safe(C_Item.GetDetailedItemLevelInfo, itemInfo)
        if type(level) == "number" then return level end
    end
    if type(GetDetailedItemLevelInfo) == "function" then
        local level = safe(GetDetailedItemLevelInfo, itemInfo)
        if type(level) == "number" then return level end
    end
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    if type(getInfo) == "function" then
        local _, _, _, level = safe(getInfo, itemInfo)
        if type(level) == "number" then return level end
    end
    return nil
end

local function getItemInfo(itemInfo)
    local fn = C_Item and C_Item.GetItemInfo or GetItemInfo
    if type(fn) ~= "function" then return nil end
    local name, link, quality, baseLevel, minLevel, itemType, itemSubType, stackCount, equipLoc, icon, sellPrice, classID, subclassID = safe(fn, itemInfo)
    if not name then return nil end
    return {
        name = cleanName(name) or tostring(name),
        link = link,
        quality = quality,
        baseLevel = baseLevel,
        minLevel = minLevel,
        itemType = itemType,
        itemSubType = itemSubType,
        stackCount = stackCount,
        equipLoc = equipLoc,
        icon = icon,
        sellPrice = sellPrice,
        classID = classID,
        subclassID = subclassID,
    }
end

local function bestEquippedLevel(equipLoc)
    local slots = EQUIP_SLOTS[equipLoc or ""]
    if not slots or type(GetInventoryItemLink) ~= "function" then return nil, nil end

    local weakestLevel = nil
    local weakestSlot = nil
    for _, slotID in ipairs(slots) do
        local link = safe(GetInventoryItemLink, "player", slotID)
        if link then
            local level = itemLevel(link)
            if level and (not weakestLevel or level < weakestLevel) then
                weakestLevel = level
                weakestSlot = slotID
            end
        else
            -- Empty compatible slot means any equippable item is potentially useful.
            return 0, slotID
        end
    end
    return weakestLevel, weakestSlot
end

function FC:IsDungeonContext()
    local runtime = self.state and self.state.runtime or {}
    if runtime.groupInstanceActive and runtime.instanceType ~= "pvp" then
        return true, runtime.instanceType, runtime.groupInstanceName
    end

    if type(IsInInstance) == "function" then
        local inInstance, kind = safe(IsInInstance)
        if inInstance and (kind == "party" or kind == "raid") then
            local name = type(GetInstanceInfo) == "function" and select(1, safe(GetInstanceInfo)) or nil
            return true, kind, name
        end
    end
    return false, nil, nil
end

function FC:GetCurrentDungeonSnapshot()
    local inDungeon, kind = self:IsDungeonContext()
    if not inDungeon then return nil end

    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, lfgDungeonID
    if type(GetInstanceInfo) == "function" then
        name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, lfgDungeonID = safe(GetInstanceInfo)
    end

    local mapID = nil
    if C_Map and type(C_Map.GetBestMapForUnit) == "function" then
        mapID = safe(C_Map.GetBestMapForUnit, "player")
    end

    local snapshot = {
        name = name or self.state.runtime.groupInstanceName or "the instance",
        instanceType = instanceType or kind,
        difficultyID = difficultyID,
        difficultyName = difficultyName,
        maxPlayers = maxPlayers,
        instanceID = instanceID,
        groupSize = instanceGroupSize,
        lfgDungeonID = lfgDungeonID,
        uiMapID = mapID,
        at = GetTime(),
    }
    return snapshot
end

function FC:ResolveJournalInstance(snapshot)
    snapshot = snapshot or self:GetCurrentDungeonSnapshot()
    if not snapshot then return nil end

    if snapshot.uiMapID and type(EJ_GetInstanceForMap) == "function" then
        local journalID = safe(EJ_GetInstanceForMap, snapshot.uiMapID)
        if journalID then return journalID end
    end

    if type(EJ_GetInstanceByIndex) ~= "function" then return nil end
    local wantedName = lower(snapshot.name)
    local wantedInstanceID = tonumber(snapshot.instanceID)

    for _, isRaid in ipairs({ false, true }) do
        for index = 1, 250 do
            local journalID, name, _, _, _, _, _, _, _, _, mapID = safe(EJ_GetInstanceByIndex, index, isRaid)
            if not journalID then break end
            if (wantedInstanceID and tonumber(mapID) == wantedInstanceID) or (wantedName ~= "" and lower(name) == wantedName) then
                return journalID
            end
        end
    end
    return nil
end

function FC:GetDungeonBosses(journalID)
    local bosses = {}
    if not journalID or type(EJ_GetEncounterInfoByIndex) ~= "function" then return bosses end
    pcall(EJ_SelectInstance, journalID)
    for index = 1, 50 do
        local name, _, journalEncounterID, _, _, _, dungeonEncounterID = safe(EJ_GetEncounterInfoByIndex, index, journalID)
        if not name then break end
        bosses[#bosses + 1] = {
            name = cleanName(name) or tostring(name),
            journalEncounterID = journalEncounterID,
            dungeonEncounterID = dungeonEncounterID,
        }
    end
    return bosses
end

function FC:IsDungeonLootForCurrentBuild(item)
    if not item then return false, "missing" end
    local _, classID, specID = currentClassAndSpec()
    local itemInfo = item.link or item.itemID

    if C_Item and type(C_Item.DoesItemContainSpec) == "function" and classID then
        local ok, fits = pcall(C_Item.DoesItemContainSpec, itemInfo, classID, specID)
        if ok and fits ~= nil then
            return fits and true or false, fits and "spec" or "filtered"
        end
    end

    if type(IsEquippableItem) == "function" then
        local equippable = safe(IsEquippableItem, itemInfo)
        if equippable ~= nil then return equippable and true or false, equippable and "equippable" or "not-equippable" end
    end

    local info = getItemInfo(itemInfo)
    if info and info.equipLoc and info.equipLoc ~= "" then return true, "equipment" end
    return false, "unknown"
end

function FC:AssessDungeonLootItem(item)
    if not item then return nil end
    local itemInfo = item.link or item.itemID
    local info = getItemInfo(itemInfo)
    if not info and not item.name then return nil end

    item.name = item.name or (info and info.name)
    item.link = item.link or (info and info.link)
    item.equipLoc = (info and info.equipLoc) or item.equipLoc
    item.itemLevel = itemLevel(itemInfo)
    item.minLevel = info and info.minLevel or nil
    item.itemType = info and info.itemType or nil
    item.itemSubType = info and info.itemSubType or nil

    local fits, fitReason = self:IsDungeonLootForCurrentBuild(item)
    if not fits then return nil end
    item.fitReason = fitReason

    local playerLevel = self:SafeUnitNumber(UnitLevel, "player") or 0
    if type(item.minLevel) == "number" and item.minLevel > playerLevel + 5 then
        item.future = true
    end

    local equippedLevel, equippedSlot = bestEquippedLevel(item.equipLoc)
    item.equippedLevel = equippedLevel
    item.equippedSlot = equippedSlot

    if item.itemLevel and equippedLevel ~= nil then
        item.delta = item.itemLevel - equippedLevel
    end

    local score = 0
    if item.delta and item.delta > 0 then score = score + 1000 + item.delta * 20 end
    if item.delta == nil then score = score + 250 end
    if item.itemLevel then score = score + item.itemLevel end
    if item.equipLoc == "INVTYPE_TRINKET" then score = score + 40 end
    if item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_WEAPONMAINHAND" then score = score + 60 end
    if item.future then score = score - 300 end
    item.score = score
    return item
end

local function modernLootInfo(index)
    if C_EncounterJournal and type(C_EncounterJournal.GetLootInfoByIndex) == "function" then
        local info = safe(C_EncounterJournal.GetLootInfoByIndex, index)
        if type(info) == "table" and info.itemID then
            return {
                itemID = info.itemID,
                encounterID = info.encounterID,
                name = cleanName(info.name),
                icon = info.icon,
                slot = info.slot,
                armorType = info.armorType,
                link = info.link,
            }
        end
    end
    if type(EJ_GetLootInfoByIndex) == "function" then
        local itemID, encounterID, name, icon, slot, armorType, link = safe(EJ_GetLootInfoByIndex, index)
        if itemID then
            return {
                itemID = itemID,
                encounterID = encounterID,
                name = cleanName(name),
                icon = icon,
                slot = slot,
                armorType = armorType,
                link = link,
            }
        end
    end
    return nil
end

function FC:ScanDungeonLoot(force)
    local snapshot = self:GetCurrentDungeonSnapshot()
    if not snapshot then
        self.state.dungeon = nil
        return nil
    end

    self.state.dungeon = self.state.dungeon or {}
    local dungeon = self.state.dungeon
    local sameInstance = dungeon.instanceID == snapshot.instanceID and dungeon.name == snapshot.name
    if sameInstance and not force and dungeon.lastLootScan and GetTime() - dungeon.lastLootScan < 60 then
        return dungeon
    end

    dungeon.name = snapshot.name
    dungeon.instanceID = snapshot.instanceID
    dungeon.difficultyID = snapshot.difficultyID
    dungeon.difficultyName = snapshot.difficultyName
    dungeon.lfgDungeonID = snapshot.lfgDungeonID
    dungeon.instanceType = snapshot.instanceType
    dungeon.enteredAt = dungeon.enteredAt or GetTime()
    dungeon.killedBosses = dungeon.killedBosses or {}
    dungeon.wipes = dungeon.wipes or 0
    dungeon.bossKills = dungeon.bossKills or 0
    dungeon.lastLootScan = GetTime()
    dungeon.loot = {}
    dungeon.lootSource = "none"

    local journalID = self:ResolveJournalInstance(snapshot)
    dungeon.journalID = journalID
    if not journalID then return dungeon end

    if type(EJ_SelectInstance) == "function" then pcall(EJ_SelectInstance, journalID) end
    if snapshot.difficultyID and type(EJ_SetDifficulty) == "function" then pcall(EJ_SetDifficulty, snapshot.difficultyID) end

    dungeon.bosses = self:GetDungeonBosses(journalID)
    local bossNames = {}
    for _, boss in ipairs(dungeon.bosses or {}) do
        if boss.journalEncounterID then bossNames[boss.journalEncounterID] = boss.name end
    end

    local numLoot = type(EJ_GetNumLoot) == "function" and safe(EJ_GetNumLoot) or nil
    numLoot = tonumber(numLoot) or 0
    if numLoot <= 0 then return dungeon end

    dungeon.lootSource = "encounter-journal"
    for index = 1, math.min(numLoot, 500) do
        local item = modernLootInfo(index)
        if item then
            item.bossName = item.encounterID and bossNames[item.encounterID] or nil
            if not item.bossName and item.encounterID and type(EJ_GetEncounterInfo) == "function" then
                item.bossName = cleanName(safe(EJ_GetEncounterInfo, item.encounterID))
            end
            local assessed = self:AssessDungeonLootItem(item)
            if assessed then dungeon.loot[#dungeon.loot + 1] = assessed end
        end
    end

    table.sort(dungeon.loot, function(a, b)
        if (a.score or 0) ~= (b.score or 0) then return (a.score or 0) > (b.score or 0) end
        return (a.itemLevel or 0) > (b.itemLevel or 0)
    end)

    return dungeon
end

function FC:GetDungeonLootWatch(count, onlyUnkilled)
    local dungeon = self:ScanDungeonLoot(false)
    if not dungeon then return {} end
    count = math.max(1, math.min(8, tonumber(count) or 3))
    local result = {}
    for _, item in ipairs(dungeon.loot or {}) do
        local killed = item.bossName and dungeon.killedBosses and dungeon.killedBosses[item.bossName]
        if not onlyUnkilled or not killed then
            result[#result + 1] = item
            if #result >= count then break end
        end
    end
    return result
end

function FC:FormatDungeonLootItem(item)
    if not item then return nil end
    local name = item.link or item.name or "unknown item"
    local details = {}
    if item.itemLevel then details[#details + 1] = "ilvl " .. tostring(item.itemLevel) end
    if item.delta and item.delta > 0 then details[#details + 1] = "+" .. tostring(math.floor(item.delta + 0.5)) .. " vs your current slot" end
    if item.future then details[#details + 1] = "future upgrade" end
    if item.bossName then details[#details + 1] = "from " .. item.bossName end
    if #details > 0 then return name .. " (" .. table.concat(details, ", ") .. ")" end
    return name
end

function FC:ShowDungeonIntel()
    local dungeon = self:ScanDungeonLoot(true)
    if not dungeon then
        self:Say("We're not in a dungeon or raid right now.", "shrug", 100, true)
        return
    end

    local role = type(UnitGroupRolesAssigned) == "function" and safe(UnitGroupRolesAssigned, "player") or nil
    local parts = { dungeon.name or "This instance" }
    if dungeon.difficultyName and dungeon.difficultyName ~= "" then parts[#parts + 1] = dungeon.difficultyName end
    parts[#parts + 1] = tostring(dungeon.bossKills or 0) .. " boss kills"
    if dungeon.wipes and dungeon.wipes > 0 then parts[#parts + 1] = tostring(dungeon.wipes) .. " wipes" end
    if role and role ~= "NONE" then parts[#parts + 1] = string.lower(role) .. " role" end

    local watch = self:GetDungeonLootWatch(2, true)
    local message = table.concat(parts, " • ") .. "."
    if #watch > 0 then
        message = message .. " Loot watch: " .. self:FormatDungeonLootItem(watch[1])
        if watch[2] then message = message .. "; " .. self:FormatDungeonLootItem(watch[2]) end
        message = message .. "."
    elseif dungeon.journalID then
        message = message .. " I can read the encounter journal, but I don't see a clear class/spec gear target yet."
    else
        message = message .. " This client isn't exposing a matching encounter-journal loot table here, so I won't invent drops."
    end

    self:Say(message, "think", 100, true, { topic = "dungeonintel", category = "group", reason = "manual dungeon intelligence" })
end

function FC:ShowDungeonLootWatch()
    local dungeon = self:ScanDungeonLoot(true)
    if not dungeon then
        self:Say("Get me into a dungeon first and I'll build a loot watch list.", "shrug", 100, true)
        return
    end

    local watch = self:GetDungeonLootWatch((self.db.dungeon and self.db.dungeon.lootCount) or 3, true)
    if #watch == 0 then
        self:Say("I don't have a trustworthy class-compatible loot recommendation for this instance yet. I'll keep watching instead of guessing.", "think", 100, true)
        return
    end

    local lines = {}
    for _, item in ipairs(watch) do lines[#lines + 1] = self:FormatDungeonLootItem(item) end
    self:Say("Loot worth watching: " .. table.concat(lines, "; ") .. ".", "point", 100, true, { topic = "dungeonloot", category = "loot", reason = "dungeon loot watch" })
end

function FC:DungeonThought(force)
    if self.db and self.db.dungeon and self.db.dungeon.enabled == false then return false end
    if not self:IsDungeonContext() then return false end

    local dungeon = self:ScanDungeonLoot(false)
    if not dungeon then return false end

    self.state.dungeon = self.state.dungeon or {}
    local state = self.state.dungeon
    state.announcedLoot = state.announcedLoot or {}

    local now = GetTime()
    local ambientCooldown = force and 0 or 600
    if not force and now - (state.lastAmbientAt or 0) < ambientCooldown then
        return false
    end

    -- In a dungeon, ambient chatter should either add new information or be rare flavor.
    -- Never repeat the entry-mode explanation every minute.
    local watch = {}
    if not self.db.dungeon or self.db.dungeon.lootWatch ~= false then
        watch = self:GetDungeonLootWatch(5, true)
    end

    for _, item in ipairs(watch) do
        local key = tostring(item.itemID or item.link or item.name or '') .. ':' .. tostring(item.bossName or '')
        if key ~= ':' and not state.announcedLoot[key] then
            state.announcedLoot[key] = true
            state.lastAmbientAt = now
            self:QueueSay(
                "Loot watch: " .. self:FormatDungeonLootItem(item) .. ".",
                "point",
                force and 100 or 8,
                0,
                "dungeonloot-new:" .. key,
                force,
                function() return FC:IsDungeonContext() end,
                { topic = "dungeonloot", category = "loot", reason = "new dungeon loot target" }
            )
            return true
        end
    end

    local bossKills = state.bossKills or 0
    if bossKills > (state.lastProgressBossKills or -1) and bossKills > 0 then
        state.lastProgressBossKills = bossKills
        state.lastAmbientAt = now
        local total = #(dungeon.bosses or {})
        local remaining = math.max(0, total - bossKills)
        local text = tostring(bossKills) .. " boss" .. (bossKills == 1 and "" or "es") .. " down."
        if total > 0 then
            text = text .. " " .. tostring(remaining) .. " encounter" .. (remaining == 1 and "" or "s") .. " left on my list."
        end
        self:QueueSay(
            text,
            "think",
            force and 100 or 8,
            0,
            "dungeonprogress:" .. tostring(bossKills),
            force,
            function() return FC:IsDungeonContext() end,
            { topic = "dungeonprogress", category = "group", reason = "dungeon progress changed" }
        )
        return true
    end

    -- Flavor chatter is intentionally rare: at most once every ten minutes and
    -- never another explanation of what dungeon mode does.
    if force or math.random() <= 0.35 then
        local line = self:GetLine("dungeonambient", {})
        if line then
            state.lastAmbientAt = now
            self:QueueSay(
                line,
                "talk",
                force and 100 or 4,
                0,
                "dungeonambient:" .. tostring(math.floor(now / 600)),
                force,
                function() return FC:IsDungeonContext() end,
                { topic = "dungeonambient", category = "group", reason = "rare dungeon banter" }
            )
            return true
        end
    end

    return false
end

local function selectDungeonPersonalityVoice(self, topic, fallbackText, data)
    if type(self.GetPersonalityVoiceForTopic) ~= "function" then return fallbackText, nil end
    local ok, entry = pcall(self.GetPersonalityVoiceForTopic, self, topic, data or {}, false)
    if ok and entry and entry.text then return entry.text, entry end
    return fallbackText, nil
end

function FC:OnDungeonEnter(name)
    if self.db and self.db.dungeon and self.db.dungeon.enabled == false then return end
    self.state.dungeon = {
        name = name,
        enteredAt = GetTime(),
        killedBosses = {},
        bossKills = 0,
        wipes = 0,
        entryAnnounced = false,
        announcedLoot = {},
        lastAmbientAt = 0,
        lastProgressBossKills = 0,
    }

    -- Remove stale town/quest-reminder chatter that was queued before zoning in.
    -- Use the queue helper so a dropped line does not leave its long cooldown behind.
    if self.DropQueuedTopic then
        for _, topic in ipairs({ "questpile", "questlevel", "queststalled", "traveltime", "bags", "repair", "auction", "bank", "mail", "trade", "barber" }) do
            self:DropQueuedTopic(topic)
        end
    end

    local function refreshAndIntroduce()
        if not FC:IsDungeonContext() then return end
        local dungeon = FC:ScanDungeonLoot(true)
        if not dungeon then return end
        local watch = {}
        if not FC.db.dungeon or FC.db.dungeon.lootWatch ~= false then watch = FC:GetDungeonLootWatch(1, true) end
        local state = FC.state.dungeon or {}
        if state.entryAnnounced then return end
        state.entryAnnounced = true
        state.lastAmbientAt = GetTime()
        FC.state.dungeon = state

        local text = "We're in " .. tostring(dungeon.name or name or "the instance") .. ". I'll watch bosses and useful drops."
        if watch[1] then
            text = text .. " First item on my watch list: " .. FC:FormatDungeonLootItem(watch[1]) .. "."
            local key = tostring(watch[1].itemID or watch[1].link or watch[1].name or '') .. ':' .. tostring(watch[1].bossName or '')
            if key ~= ':' then state.announcedLoot[key] = true end
        end
        local fallbackText = text
        local personalityText, personalityVoice = selectDungeonPersonalityVoice(FC, "dungeonenter", fallbackText, { name = dungeon.name or name })
        FC:QueueSay(personalityText, "point", 45, 0, "dungeonenter-intel", true, function() return FC:IsDungeonContext() end, {
            topic = "dungeonenter", category = "group", reason = "entered dungeon",
            personalityVoice = personalityVoice, personalityFallbackText = fallbackText,
        })
    end

    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(1.5, refreshAndIntroduce)
        C_Timer.After(5.0, function() if FC:IsDungeonContext() then FC:ScanDungeonLoot(true) end end)
    else
        refreshAndIntroduce()
    end
end

function FC:OnDungeonExit()
    self.state.dungeon = nil
end

function FC:OnDungeonBossKill(encounterID, encounterName)
    if not self:IsDungeonContext() then return end
    if self.db and self.db.dungeon and self.db.dungeon.enabled == false then return end
    self.state.dungeon = self.state.dungeon or { killedBosses = {}, bossKills = 0, wipes = 0 }
    local dungeon = self.state.dungeon
    dungeon.killedBosses = dungeon.killedBosses or {}
    local bossKey = encounterName or tostring(encounterID)
    if dungeon.killedBosses[bossKey] then return end
    dungeon.killedBosses[bossKey] = true
    dungeon.bossKills = (dungeon.bossKills or 0) + 1

    if self.db.dungeon and self.db.dungeon.bossChatter == false then return end
    local watch = {}
    if not self.db.dungeon or self.db.dungeon.lootWatch ~= false then watch = self:GetDungeonLootWatch(1, true) end
    local text = tostring(encounterName or "Boss") .. " down. That's " .. tostring(dungeon.bossKills or 0) .. " boss" .. ((dungeon.bossKills or 0) == 1 and "" or "es") .. " cleared."
    if watch[1] then
        text = text .. " Next loot target I'd watch is " .. self:FormatDungeonLootItem(watch[1]) .. "."
    end
    local fallbackText = text
    local personalityText, personalityVoice = selectDungeonPersonalityVoice(self, "dungeonboss", fallbackText, { name = encounterName, bossKills = dungeon.bossKills })
    self:QueueSay(
        personalityText,
        "celebrate", 30, 20, "dungeonbossloot", false,
        function() return FC:IsDungeonContext() end,
        { topic = "dungeonboss", category = "group", reason = "boss defeated", maxAge = 14, minGap = 0.6, preempt = true,
          personalityVoice = personalityVoice, personalityFallbackText = fallbackText }
    )
end


function FC:OnDungeonEncounterStart(encounterID, encounterName)
    if not self:IsDungeonContext() then return end
    if self.db and self.db.dungeon and self.db.dungeon.enabled == false then return end
    self.state.dungeon = self.state.dungeon or { killedBosses = {}, bossKills = 0, wipes = 0 }
    self.state.dungeon.currentBoss = encounterName

    local best = nil
    if not self.db.dungeon or self.db.dungeon.lootWatch ~= false then
        local dungeon = self:ScanDungeonLoot(false)
        for _, item in ipairs(dungeon and dungeon.loot or {}) do
            if item.bossName and encounterName and lower(item.bossName) == lower(encounterName) then
                best = item
                break
            end
        end
    end

    local text = "Boss pull: " .. tostring(encounterName or "encounter") .. "."
    if best then text = text .. " Best class-compatible drop I'm watching here is " .. self:FormatDungeonLootItem(best) .. "." end
    local fallbackText = text
    local personalityText, personalityVoice = selectDungeonPersonalityVoice(self, "dungeonbossstart", fallbackText, { name = encounterName })
    self:QueueSay(personalityText, "think", 72, 120, "dungeonbossstart:" .. tostring(encounterName), false,
        function()
            return FC:IsDungeonContext() and FC.state.dungeon and FC.state.dungeon.currentBoss == encounterName
        end,
        { topic = "dungeonbossstart", category = "group", reason = "boss encounter started", maxAge = 8, minGap = 0.5, preempt = true,
          personalityVoice = personalityVoice, personalityFallbackText = fallbackText })
end

function FC:OnDungeonEncounterEnd(encounterID, encounterName, success)
    if not self:IsDungeonContext() then return end
    self.state.dungeon = self.state.dungeon or { killedBosses = {}, bossKills = 0, wipes = 0 }
    self.state.dungeon.currentBoss = nil
    if self.DropQueuedTopic then self:DropQueuedTopic("dungeonbossstart") end
    if tonumber(success) == 1 then
        self:OnDungeonBossKill(encounterID, encounterName)
    else
        self.state.dungeon.wipes = (self.state.dungeon.wipes or 0) + 1
        local fallbackText = "That was a wipe on " .. tostring(encounterName or "the encounter") .. ". Reset, tighten it up, and go again."
        local personalityText, personalityVoice = selectDungeonPersonalityVoice(self, "dungeonwipe", fallbackText, { name = encounterName, wipes = self.state.dungeon.wipes })
        self:QueueSay(
            personalityText,
            "worried", 35, 45, "dungeonwipe:" .. tostring(encounterName), false,
            function() return FC:IsDungeonContext() end,
            { topic = "dungeonwipe", category = "combat", reason = "encounter wipe", maxAge = 10, minGap = 0.6, preempt = true,
              personalityVoice = personalityVoice, personalityFallbackText = fallbackText }
        )
    end
end

function FC:DungeonDiagnostics()
    local snapshot = self:GetCurrentDungeonSnapshot()
    if not snapshot then
        self:Debug("Dungeon: not currently in a party/raid instance.")
        return
    end
    local dungeon = self:ScanDungeonLoot(true)
    self:Debug(string.format(
        "Dungeon: %s type=%s difficulty=%s instanceID=%s uiMapID=%s journalID=%s lootSource=%s candidates=%d bosses=%d",
        tostring(snapshot.name), tostring(snapshot.instanceType), tostring(snapshot.difficultyName or snapshot.difficultyID),
        tostring(snapshot.instanceID), tostring(snapshot.uiMapID), tostring(dungeon and dungeon.journalID),
        tostring(dungeon and dungeon.lootSource), dungeon and #(dungeon.loot or {}) or 0, dungeon and #(dungeon.bosses or {}) or 0
    ))
    for i, item in ipairs(self:GetDungeonLootWatch(5, false)) do
        self:Debug("  " .. tostring(i) .. ". " .. tostring(self:FormatDungeonLootItem(item)))
    end
end

-- Dungeon-specific ambient vocabulary. These lines are intentionally about the run,
-- not town chores or completed quest turn-ins.
FC.dialogue = FC.dialogue or {}
FC.dialogue.Vexa = FC.dialogue.Vexa or {}
FC.dialogue.Vexa.dungeonambient = {
    "Bosses are just loot boxes with mechanics and anger issues.",
    "The group looks much smarter when everyone interrupts something occasionally.",
    "I support efficient pulls. I do not support pulling the entire building for science.",
    "If the healer stops moving, that is usually not permission to sprint three rooms ahead.",
    "A clean run is just a collection of small decisions nobody had to apologize for.",
    "The nice thing about a boss room is that everyone suddenly remembers they have cooldowns.",
    "Nothing builds party friendship like surviving a pull that absolutely should not have worked.",
    "I am monitoring the ancient dungeon ritual known as 'someone accidentally pulled that.'",
    "A dungeon is a temporary alliance between strangers who all want different pants.",
    "The correct number of mobs in a pull is usually fewer than the tank is currently considering.",
    "Good dungeon pace is mostly clean pulls and very little standing around wondering who has the key.",
    "If this run gets weird, I am blaming the person who said 'big pull.'",
    "I respect a tank who knows the route. I respect a healer who survives the tank who thinks they know the route.",
    "A good interrupt is one of the cheapest ways to look extremely competent.",
    "Everyone loves a smooth run. Nobody remembers who prevented it from becoming a disaster.",
    "The fastest route through a dungeon is usually the one with the fewest corpse runs.",
    "If something shiny drops and it actually fits you, then I get excited.",
    "I am keeping score in the only categories that matter: bosses down, wipes avoided, useful loot found.",
    "Somewhere in this instance is an item someone has been farming for twenty runs. Try not to become that person.",
    "If the next pull looks suspiciously large, I would like it noted that I objected in advance.",
}

function FC:RefreshDungeonPage()
    if not self.dungeonStatusText then return end
    local dungeon = self:ScanDungeonLoot(false)
    if not dungeon then
        self.dungeonStatusText:SetText("Not currently in a party or raid instance.\n\nEnter a dungeon and Vexa will switch priorities automatically.")
        if self.dungeonLootText then self.dungeonLootText:SetText("No active dungeon loot watch.") end
        return
    end

    local bossTotal = #(dungeon.bosses or {})
    local killed = dungeon.bossKills or 0
    local status = string.format(
        "%s\nDifficulty: %s\nBoss progress: %d / %d\nWipes: %d\nLoot source: %s\nJournal instance: %s",
        tostring(dungeon.name or "Instance"),
        tostring(dungeon.difficultyName or dungeon.difficultyID or "unknown"),
        killed,
        bossTotal,
        dungeon.wipes or 0,
        tostring(dungeon.lootSource or "none"),
        tostring(dungeon.journalID or "unavailable")
    )
    self.dungeonStatusText:SetText(status)

    if self.dungeonLootText then
        local lines = {}
        for i, item in ipairs(self:GetDungeonLootWatch((self.db.dungeon and self.db.dungeon.lootCount) or 3, true)) do
            lines[#lines + 1] = tostring(i) .. ". " .. tostring(self:FormatDungeonLootItem(item))
        end
        if #lines == 0 then
            lines[1] = "No trustworthy class/spec loot target detected yet. Vexa will keep checking as encounter and item data becomes available."
        end
        self.dungeonLootText:SetText(table.concat(lines, "\n\n"))
    end
end
