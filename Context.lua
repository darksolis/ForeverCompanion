local FC = _G.ForeverCompanion

local lower = string.lower
local FOOD_PATTERNS = { "food", "well fed", "sated", "meal" }
local DRINK_PATTERNS = { "drink", "refreshment", "water" }
local FIRE_PATTERNS = { "campfire", "warmth", "by the fire" }
local STEALTH_PATTERNS = { "stealth", "prowl", "vanish" }
local GATHER_PATTERNS = { "mining", "herb gathering", "skinning", "fishing", "prospecting", "milling", "disenchant" }
local GROUND_DAMAGE_PATTERNS = { "fire", "flame", "lava", "burn", "blaze", "scorch", "searing ground", "void zone" }
local INTERRUPT_NAMES = { "pummel", "kick", "counterspell", "wind shear", "earth shock", "rebuke", "mind freeze", "skull bash", "solar beam", "spear hand strike", "disrupt", "quell", "counter shot", "silence", "spell lock" }
local CAPITALS = {
    ["Stormwind City"] = true, ["Ironforge"] = true, ["Darnassus"] = true, ["The Exodar"] = true,
    ["Orgrimmar"] = true, ["Thunder Bluff"] = true, ["Undercity"] = true, ["Silvermoon City"] = true,
    ["Shattrath City"] = true, ["Dalaran"] = true,
}


local function readableNumber(v) return FC:ReadableNumber(v) end
local function readableString(v) return FC:ReadableString(v) end
local function readableBoolean(v) return FC:ReadableBoolean(v) end

local function safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
    return nil
end

local function containsPattern(text, patterns)
    if not text then return false end
    local s = lower(tostring(text))
    for _, pattern in ipairs(patterns) do
        if string.find(s, pattern, 1, true) then return true end
    end
    return false
end

local function helpfulAuraName(unit, index)
    local ok, name = pcall(function()
        if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
            local aura = C_UnitAuras.GetBuffDataByIndex(unit, index)
            return aura and aura.name or nil
        end
        if UnitAura then return UnitAura(unit, index, "HELPFUL") end
        if UnitBuff then return UnitBuff(unit, index) end
        return nil
    end)
    return ok and name or nil
end

local function hasAuraPattern(unit, patterns)
    for i = 1, 40 do
        local name = helpfulAuraName(unit, i)
        if not name then break end
        if containsPattern(name, patterns) then return true, name end
    end
    return false, nil
end

local function playerFlagState()
    local ok, state = pcall(function()
        if UnitIsDND and UnitIsDND("player") then return "DND" end
        if UnitIsAFK and UnitIsAFK("player") then return "AFK" end
        return "NONE"
    end)
    return ok and state or nil
end

local function groupInstanceState()
    local ok, grouped, instanceType, instanceName = pcall(function()
        local inInstance, kind = IsInInstance and IsInInstance() or false, nil
        if IsInInstance then inInstance, kind = IsInInstance() end
        local groupedNow = inInstance and (kind == "party" or kind == "raid")
        local name = groupedNow and GetInstanceInfo and select(1, GetInstanceInfo()) or nil
        return groupedNow, kind, name
    end)
    if ok then return grouped, instanceType, instanceName end
    return false, nil, nil
end

local function countMailboxLootables()
    if type(GetInboxNumItems) ~= "function" or type(GetInboxHeaderInfo) ~= "function" then return 0 end
    local total = 0
    local count = safe(GetInboxNumItems) or 0
    for i = 1, count do
        local _, _, _, _, money, cod, _, hasItem = safe(GetInboxHeaderInfo, i)
        if hasItem then total = total + 1 end
        if money and money > 0 and (not cod or cod == 0) then total = total + 1 end
    end
    return total
end

local function durabilityTotals()
    local current, maximum, broken = 0, 0, false
    if type(GetInventoryItemDurability) ~= "function" then return current, maximum, broken end
    for slot = 1, 19 do
        local c, m = safe(GetInventoryItemDurability, slot)
        c, m = readableNumber(c), readableNumber(m)
        if c ~= nil and m ~= nil then
            current = current + c
            maximum = maximum + m
            if c <= 0 then broken = true end
        end
    end
    return current, maximum, broken
end

local function playerHasUsableInterrupt()
    if type(GetActionInfo) ~= "function" then return false end
    for slot = 1, 180 do
        local ok, actionType, id = pcall(GetActionInfo, slot)
        if ok and actionType == "spell" and id then
            local spellName = nil
            if C_Spell and C_Spell.GetSpellName then
                local sok, value = pcall(C_Spell.GetSpellName, id)
                if sok then spellName = value end
            end
            if not spellName and type(GetSpellInfo) == "function" then
                local sok, value = pcall(GetSpellInfo, id)
                if sok then spellName = value end
            end
            if spellName then
                local n = lower(tostring(spellName))
                for _, expected in ipairs(INTERRUPT_NAMES) do
                    if n == expected then
                        local usable = nil
                        if type(IsUsableAction) == "function" then
                            local uok, u, noMana = pcall(IsUsableAction, slot)
                            if uok then usable = (u == true or u == 1) and not noMana end
                        end
                        if usable == true then return true end
                    end
                end
            end
        end
    end
    return false
end

local function hostileNameplateCount()
    if not C_NamePlate or type(C_NamePlate.GetNamePlates) ~= "function" then return nil end
    local ok, plates = pcall(C_NamePlate.GetNamePlates)
    if not ok or type(plates) ~= "table" then return nil end
    local count = 0
    for _, plate in ipairs(plates) do
        local unit = plate and plate.namePlateUnitToken
        if unit then
            local hostile = readableBoolean(safe(UnitCanAttack, "player", unit)) == true
            local combat = type(UnitAffectingCombat) ~= "function" or readableBoolean(safe(UnitAffectingCombat, unit)) == true
            if hostile and combat then count = count + 1 end
        end
    end
    return count
end

local function playerMapPoint()
    if not C_Map or type(C_Map.GetBestMapForUnit) ~= "function" or type(C_Map.GetPlayerMapPosition) ~= "function" then return nil end
    local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
    if not ok or not mapID then return nil end
    local pok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pok or not pos then return nil end
    local x, y = nil, nil
    if type(pos.GetXY) == "function" then
        local xyok, px, py = pcall(pos.GetXY, pos)
        if xyok then x, y = px, py end
    else
        x, y = pos.x, pos.y
    end
    x, y = tonumber(x), tonumber(y)
    if not x or not y then return nil end
    return mapID, x, y
end

function FC:SetMood(name, delta, duration)
    self.state.mood = self.state.mood or { name = "neutral", score = 0, untilTime = 0 }
    local mood = self.state.mood
    mood.score = math.max(-100, math.min(100, (mood.score or 0) + (delta or 0)))
    mood.name = name or mood.name or "neutral"
    mood.untilTime = GetTime() + (duration or 120)
end

function FC:UpdateMood()
    local mood = self.state.mood
    if not mood then return end
    if GetTime() > (mood.untilTime or 0) then
        if mood.score > 4 then mood.score = mood.score - 1 elseif mood.score < -4 then mood.score = mood.score + 1 end
        if math.abs(mood.score) <= 4 then mood.name = "neutral" end
        mood.untilTime = GetTime() + 30
    end
end

function FC:UpdateContextMode()
    local runtime = self.state.runtime or {}
    local mode = "exploring"
    if readableBoolean(safe(UnitIsDeadOrGhost, "player")) == true then mode = "dead"
    elseif self.state.inCombat then mode = "combat"
    elseif runtime.onTaxi then mode = "taxi"
    elseif runtime.merchantOpen or runtime.bankOpen or runtime.mailOpen or runtime.auctionOpen or runtime.tradeOpen or runtime.barberOpen then mode = "town_chores"
    elseif runtime.groupInstanceActive then mode = "instance"
    elseif runtime.resting then mode = "resting"
    elseif runtime.mounted then mode = "traveling"
    elseif (self.state.questSnapshot and (self.state.questSnapshot.active or 0) > 0) then mode = "questing" end
    self.state.contextMode = mode
    return mode
end

function FC:InitializeContext()
    local runtime = self.state.runtime or {}
    self.state.runtime = runtime
    runtime.mounted = safe(IsMounted) and true or false
    runtime.eating = hasAuraPattern("player", FOOD_PATTERNS)
    runtime.drinking = hasAuraPattern("player", DRINK_PATTERNS)
    runtime.campfire = hasAuraPattern("player", FIRE_PATTERNS)
    runtime.stealth = readableBoolean(safe(IsStealthed)) == true or hasAuraPattern("player", STEALTH_PATTERNS)
    runtime.petName = readableBoolean(safe(UnitExists, "pet")) == true and readableString(safe(UnitName, "pet")) or nil
    runtime.guildName = safe(GetGuildInfo, "player")
    runtime.onTaxi = readableBoolean(safe(UnitOnTaxi, "player")) == true
    runtime.playerFlagState = playerFlagState() or "NONE"
    runtime.resting = readableBoolean(safe(IsResting)) == true
    runtime.mailLootables = countMailboxLootables()
    runtime.durabilityCurrent, runtime.durabilityMax, runtime.broken = durabilityTotals()
    runtime.merchantOpen = false
    runtime.bankOpen = false
    runtime.mailOpen = false
    runtime.auctionOpen = false
    runtime.tradeOpen = false
    runtime.barberOpen = false
    runtime.hearthAttemptAt = 0
    runtime.groupInstanceActive, runtime.instanceType, runtime.groupInstanceName = groupInstanceState()
    runtime.groupInstanceHadBossKill = false
    runtime.groupRole = safe(UnitGroupRolesAssigned, "player") or "NONE"
    runtime.lastCapital = CAPITALS[(safe(GetRealZoneText) or "")] and (safe(GetRealZoneText) or "") or nil
    runtime.inBattleground = runtime.instanceType == "pvp"
    runtime.bgResultHandled = false
    runtime.fallActive = false
    runtime.fallStartedAt = 0
    runtime.fallPoll = 0
    runtime.jumpCount = 0
    runtime.jumpStreak = 0
    runtime.lastJumpAt = 0
    runtime.jumpMilestones = {}
    runtime.cinematic = false
    runtime.loading = false
    runtime.swimming = safe(IsSwimming) and true or false
    runtime.environmentPoll = 0
    runtime.moving = false
    runtime.timeCommented = false
    self:UpdateContextMode()
end

function FC:ReactContext(topic, data, priority, cooldown, moodName, moodDelta)
    self:QueueTopic(topic, data or {}, priority or 12, cooldown or 60, false)
    if moodName then self:SetMood(moodName, moodDelta or 0, 120) end
end

function FC:CheckAuraTransitions()
    local r = self.state.runtime or {}
    local mounted = readableBoolean(safe(IsMounted)) == true
    if mounted ~= r.mounted then
        r.mounted = mounted
        self:ReactContext(mounted and "mount" or "dismount", {}, 9, 30, "amused", 1)
    end

    local eating = hasAuraPattern("player", FOOD_PATTERNS)
    if eating and not r.eating then self:ReactContext("eat", {}, 7, 90, "relaxed", 1) end
    r.eating = eating and true or false

    local drinking = hasAuraPattern("player", DRINK_PATTERNS)
    if drinking and not r.drinking then self:ReactContext("drink", {}, 7, 90, "relaxed", 1) end
    r.drinking = drinking and true or false

    local campfire = hasAuraPattern("player", FIRE_PATTERNS)
    if campfire and not r.campfire then self:ReactContext("campfire", {}, 6, 180, "relaxed", 2) end
    r.campfire = campfire and true or false

    local stealth = readableBoolean(safe(IsStealthed)) == true or hasAuraPattern("player", STEALTH_PATTERNS)
    if stealth and not r.stealth then self:ReactContext("stealth", {}, 8, 90, "curious", 1) end
    r.stealth = stealth and true or false
    self:UpdateContextMode()
end

function FC:CheckInstanceTransitions()
    local r = self.state.runtime or {}
    local grouped, instanceType, instanceName = groupInstanceState()
    local inBG = instanceType == "pvp"

    if grouped and not r.groupInstanceActive then
        r.groupInstanceActive = true
        r.groupInstanceHadBossKill = false
        r.groupInstanceName = instanceName
        if type(self.OnDungeonEnter) == "function" and self.db and self.db.dungeon and self.db.dungeon.enabled ~= false then
            self:OnDungeonEnter(instanceName)
            self:SetMood("focused", 2, 120)
        else
            self:ReactContext("instanceenter", { name = instanceName or "the instance" }, 24, 120, "focused", 2)
        end
    elseif not grouped and r.groupInstanceActive then
        local topic = r.groupInstanceHadBossKill and "instanceleavewin" or "instanceleavefail"
        self:ReactContext(topic, { name = r.groupInstanceName or "the instance" }, 20, 120, r.groupInstanceHadBossKill and "impressed" or "annoyed", r.groupInstanceHadBossKill and 4 or -2)
        if type(self.OnDungeonExit) == "function" then self:OnDungeonExit() end
        r.groupInstanceActive = false
        r.groupInstanceHadBossKill = false
        r.groupInstanceName = nil
    elseif grouped then
        r.groupInstanceName = instanceName
    end

    if inBG and not r.inBattleground then
        r.inBattleground = true
        r.bgResultHandled = false
        self:ReactContext("bgenter", {}, 20, 120, "focused", 2)
    elseif not inBG and r.inBattleground then
        r.inBattleground = false
        r.bgResultHandled = false
    end

    local zone = safe(GetRealZoneText) or ""
    if CAPITALS[zone] and r.lastCapital ~= zone then
        r.lastCapital = zone
        self:ReactContext("capital", { zone = zone }, 7, 240, "relaxed", 1)
    elseif not CAPITALS[zone] then
        r.lastCapital = nil
    end
    self:UpdateContextMode()
end

function FC:HandleTargetChanged()
    local exists = readableBoolean(safe(UnitExists, "target"))
    if exists ~= true then return end

    local name = readableString(safe(UnitName, "target"))
    if not name then
        -- Target identity can be secret in restricted combat/instance contexts.
        return
    end

    self.db.memory.npcEncounters = self.db.memory.npcEncounters or {}
    self.db.memory.npcEncounters[name] = (self.db.memory.npcEncounters[name] or 0) + 1

    local canAttack = readableBoolean(safe(UnitCanAttack, "player", "target"))
    if canAttack ~= true then return end

    local level = readableNumber(safe(UnitLevel, "target"))
    local playerLevel = readableNumber(safe(UnitLevel, "player"))
    local classification = readableString(safe(UnitClassification, "target")) or "normal"
    local delta = (level ~= nil and playerLevel ~= nil) and (level - playerLevel) or nil
    local data = { name = name, level = level or 0, classification = classification, delta = delta or 0 }
    self.state.lastEnemyName = name
    self.state.lastEnemyAt = GetTime()

    local function sameReadableTarget()
        local liveExists = readableBoolean(safe(UnitExists, "target"))
        if liveExists ~= true then return false end
        local liveName = readableString(safe(UnitName, "target"))
        return liveName ~= nil and liveName == name
    end

    if classification == "worldboss" or classification == "elite" or classification == "rareelite" or classification == "rare" then
        if (classification == "rareelite" or classification == "rare") and type(self.PlayVexaVoiceCue) == "function" then
            self:PlayVexaVoiceCue("rare_found", { cooldown = 45 })
        end
        self:QueueTopic("targetelite", data, 14, 75, false, sameReadableTarget)
    elseif delta ~= nil and level > 0 and playerLevel > 0 and delta >= 5 then
        self:QueueTopic("targetdanger", data, 20, 75, false, sameReadableTarget)
    end
end

function FC:HandlePlayerFlagsChanged()
    local r = self.state.runtime or {}
    local newState = playerFlagState()
    if not newState or newState == r.playerFlagState then return end
    local old = r.playerFlagState or "NONE"
    r.playerFlagState = newState
    if newState == "AFK" then self:ReactContext("afk", {}, 7, 60, "bored", -1)
    elseif newState == "DND" then self:ReactContext("dnd", {}, 6, 60, "quiet", 0)
    elseif newState == "NONE" and old == "AFK" then self:ReactContext("afkreturn", {}, 10, 30, "amused", 1)
    elseif newState == "NONE" and old == "DND" then self:ReactContext("dndreturn", {}, 8, 30, "neutral", 0) end
end

function FC:HandleUIError(message)
    local r = self.state.runtime or {}
    pcall(function()
        if ERR_INV_FULL and message == ERR_INV_FULL then
            self:ReactContext("bagfull", {}, 30, 90, "annoyed", -1)
        elseif r.merchantOpen and ERR_NOT_ENOUGH_MONEY and message == ERR_NOT_ENOUGH_MONEY then
            self:ReactContext("nomoney", {}, 22, 60, "amused", -1)
        end
    end)
end

function FC:HandleHearthAttempt()
    local r = self.state.runtime or {}
    local now = GetTime()
    if now - (r.hearthAttemptAt or 0) < 1.25 then return end
    r.hearthAttemptAt = now
    self:ReactContext(self.state.inCombat and "hearthcombat" or "hearth", {}, 14, 90, self.state.inCombat and "annoyed" or "neutral", self.state.inCombat and -2 or 0)
end

function FC:HandleDurabilityChange()
    local r = self.state.runtime or {}
    local current, maximum, broken = durabilityTotals()
    if r.merchantOpen and current > (r.durabilityCurrent or 0) then
        self:ReactContext("repaired", {}, 12, 120, "relaxed", 1)
    end
    if broken and not r.broken then
        self:ReactContext("broken", {}, 45, 240, "concerned", -3)
    end
    r.durabilityCurrent, r.durabilityMax, r.broken = current, maximum, broken
end

function FC:HandleMailUpdate()
    local r = self.state.runtime or {}
    local count = countMailboxLootables()
    if count < (r.mailLootables or 0) then self:ReactContext("mail", {}, 6, 90, "curious", 1) end
    r.mailLootables = count
end

function FC:HandleGuildUpdate()
    local r = self.state.runtime or {}
    local guild = safe(GetGuildInfo, "player")
    if guild ~= r.guildName then
        if guild and not r.guildName then self:ReactContext("guildjoin", { name = guild }, 12, 180, "curious", 2)
        elseif r.guildName and not guild then self:ReactContext("guildleave", { name = r.guildName }, 10, 180, "curious", -1) end
        r.guildName = guild
    end
end

function FC:HandlePetChange()
    local r = self.state.runtime or {}
    local name = readableBoolean(safe(UnitExists, "pet")) == true and readableString(safe(UnitName, "pet")) or nil
    if name and name ~= r.petName then self:ReactContext("pet", { name = name }, 8, 90, "amused", 1) end
    r.petName = name
end

function FC:HandleRestingChanged()
    local r = self.state.runtime or {}
    local resting = readableBoolean(safe(IsResting)) == true
    if resting and not r.resting then self:ReactContext("restenter", {}, 5, 240, "relaxed", 1) end
    r.resting = resting
    self:UpdateContextMode()
end

function FC:HandlePowerUpdate(unit)
    if unit and unit ~= "player" then return end

    local className, classToken = safe(UnitClass, "player")
    className = readableString(className)
    classToken = readableString(classToken) or className or ""

    local powerID, powerToken = safe(UnitPowerType, "player")
    powerID = readableNumber(powerID)
    powerToken = readableString(powerToken)
    if powerID == nil then return end

    local current = readableNumber(safe(UnitPower, "player", powerID))
    local maximum = readableNumber(safe(UnitPowerMax, "player", powerID))

    -- Retail/Forever can make primary power values secret while addon restrictions
    -- are active. SafeRatio wraps the actual arithmetic in pcall as a second guard.
    local pct = self:SafeRatio(current, maximum)
    if pct == nil then return end

    if self.state.inCombat and classToken == "WARRIOR" and pct >= 0.92 then
        self:QueueTopic("ragecap", { percent = math.floor(pct * 100) }, 13, 120)
    elseif self.state.inCombat and (powerToken == "ENERGY" or classToken == "ROGUE") and pct >= 0.96 then
        self:QueueTopic("energycap", { percent = math.floor(pct * 100) }, 10, 120)
    elseif self.state.inCombat and powerToken == "MANA" and pct <= 0.10 then
        self:QueueTopic("manalow", { percent = math.floor(pct * 100) }, 20, 120)
    end
end

function FC:HandleLootMessage(message)
    if type(message) ~= "string" then return end
    if type(self.TrackLootValue) == "function" then self:TrackLootValue(message) end
    local link = message:match("(|c%x+|Hitem:.-|h%[.-%]|h|r)") or message:match("(|Hitem:.-|h%[.-%]|h)")
    if not link then return end
    local name, _, quality = safe(GetItemInfo, link)
    if not quality and C_Item and C_Item.GetItemQualityByID then
        local itemID = tonumber(link:match("item:(%d+)"))
        if itemID then quality = safe(C_Item.GetItemQualityByID, itemID) end
    end
    if not quality then return end
    if quality >= 4 then
        self:ReactContext("lootepic", { item = name or link, quality = quality }, 70, 45, "impressed", 6)
    elseif quality >= 3 then
        self:ReactContext("lootrare", { item = name or link, quality = quality }, 32, 60, "impressed", 3)
    elseif quality <= 1 and type(self.QueuePersonalityVoiceCategory) == "function" then
        self:QueuePersonalityVoiceCategory("loot_bad", { chance = 0.045, priority = 4, cooldown = 210, maxAge = 8, speechCategory = "world", anim = "shrug", topic = "lootbad" })
    end
end

function FC:HandleReadyCheckConfirm(unitTarget, isReady)
    if isReady ~= false then return end
    local isPlayer = unitTarget == "player"
    if not isPlayer and UnitIsUnit then isPlayer = readableBoolean(safe(UnitIsUnit, unitTarget, "player")) == true end
    if isPlayer then self:ReactContext("notready", {}, 16, 90, "amused", -1) end
end

function FC:HandleDeleteItem(itemName, qualityID)
    if qualityID and qualityID >= 3 then
        self:ReactContext("destroyvaluable", { item = itemName or "that item" }, 30, 90, "shocked", -3)
    else
        self:ReactContext("destroy", { item = itemName or "that item" }, 8, 90, "neutral", 0)
    end
end

function FC:HandleEquipmentChanged(slot)
    self.state.equipmentLevels = self.state.equipmentLevels or {}
    if not slot then return end
    local link = safe(GetInventoryItemLink, "player", slot)
    local level = link and safe(GetDetailedItemLevelInfo, link) or nil
    local old = self.state.equipmentLevels[slot]
    if level then
        self.state.equipmentLevels[slot] = level
        if old and level > old + 2 then
            self:ReactContext("upgrade", { slot = slot, old = old, new = level }, 22, 90, "impressed", 2)
        end
    end
end


function FC:HandleSpellEvent(event, ...)
    local unit, castGUID, third, fourth = ...

    if unit == "target" or unit == "focus" then
        self.state.runtime = self.state.runtime or {}
        local r = self.state.runtime
        r.enemyCasts = r.enemyCasts or {}
        local key = tostring(unit)
        if event == "UNIT_SPELLCAST_START" then
            local notInterruptible = nil
            if type(UnitCastingInfo) == "function" then
                local values = { pcall(UnitCastingInfo, unit) }
                if values[1] then notInterruptible = values[9] end
            end
            if notInterruptible ~= true and playerHasUsableInterrupt() then
                r.enemyCasts[key] = { guid = castGUID, started = GetTime(), candidate = true }
            else
                r.enemyCasts[key] = nil
            end
        elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
            r.enemyCasts[key] = nil
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            local tracked = r.enemyCasts[key]
            if tracked and tracked.candidate and (not castGUID or not tracked.guid or castGUID == tracked.guid) then
                if type(self.QueuePersonalityVoiceCategory) == "function" then
                    self:QueuePersonalityVoiceCategory("missed_interrupt", { priority = 38, cooldown = 55, maxAge = 4, speechCategory = "combat", anim = "angry", topic = "missedinterrupt", preempt = false })
                end
            end
            r.enemyCasts[key] = nil
        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" then
            r.enemyCasts[key] = nil
        end
        return
    end

    if unit ~= "player" then return end
    local spellID = nil
    if event == "UNIT_SPELLCAST_SENT" then spellID = fourth else spellID = third end
    if tonumber(spellID) == 8690 then self:HandleHearthAttempt() end

    if event == "UNIT_SPELLCAST_SUCCEEDED" and type(self.QueuePersonalityVoiceCategory) == "function" then
        local spellName = nil
        if C_Spell and C_Spell.GetSpellName and spellID then
            local ok, value = pcall(C_Spell.GetSpellName, spellID)
            if ok then spellName = value end
        end
        if not spellName and type(GetSpellInfo) == "function" and spellID then
            local ok, value = pcall(GetSpellInfo, spellID)
            if ok then spellName = value end
        end
        if spellName and containsPattern(spellName, GATHER_PATTERNS) then
            self:QueuePersonalityVoiceCategory("gathering", { chance = 0.35, priority = 5, cooldown = 90, maxAge = 8, speechCategory = "world", anim = "playful", topic = "gathering" })
        end
    end
end

function FC:HandleBattlegroundResult()
    local r = self.state.runtime or {}
    if not r.inBattleground or r.bgResultHandled or type(GetBattlefieldWinner) ~= "function" then return end
    local winner = safe(GetBattlefieldWinner)
    if winner == nil then return end
    local faction = safe(UnitFactionGroup, "player")
    local victory = false
    if type(winner) == "number" then
        victory = (winner == 0 and faction == "Horde") or (winner == 1 and faction == "Alliance")
    elseif type(winner) == "string" then
        victory = winner == faction
    end
    r.bgResultHandled = true
    self:ReactContext(victory and "bgwin" or "bgloss", {}, 35, 120, victory and "impressed" or "annoyed", victory and 4 or -3)
end

function FC:HandleCombatText(combatTextType)
    if combatTextType == "DAMAGE_CRIT" or combatTextType == "SPELL_DAMAGE_CRIT" then
        if math.random(1, 6) == 1 then self:ReactContext("crit", {}, 5, 60, "impressed", 1) end
    elseif combatTextType == "HEAL_CRIT" or combatTextType == "PERIODIC_HEAL_CRIT" then
        if math.random(1, 5) == 1 then self:ReactContext("healcrit", {}, 5, 75, "impressed", 1) end
    end
end


function FC:CheckRestedXP()
    if type(GetXPExhaustion) ~= "function" then return end
    local rested = safe(GetXPExhaustion) or 0
    if rested and rested > 0 then
        self:QueueTopic("restedxp", { xp = self:FormatNumber(rested) }, 6, 1800)
    end
end


function FC:CheckGroupRole()
    local r = self.state.runtime or {}
    local role = safe(UnitGroupRolesAssigned, "player") or "NONE"
    if role ~= "NONE" and role ~= r.groupRole then
        r.groupRole = role
        self:QueueTopic("rolechange", { role = role }, 8, 120)
    else
        r.groupRole = role
    end
end

function FC:HandleContextEvent(event, ...)
    local r = self.state.runtime or {}

    if event == "PLAYER_STARTED_MOVING" then r.moving = true; self:UpdateContextMode()
    elseif event == "PLAYER_STOPPED_MOVING" then r.moving = false; self:UpdateContextMode()
    elseif event == "UNIT_AURA" then self:CheckAuraTransitions()
    elseif event == "UNIT_PET" then local unit = ...; if unit == "player" then self:HandlePetChange() end
    elseif event == "PLAYER_TARGET_CHANGED" then self:HandleTargetChanged()
    elseif event == "PLAYER_CONTROL_LOST" then
        if readableBoolean(safe(UnitOnTaxi, "player")) == true then r.onTaxi = true; self:ReactContext("flightstart", {}, 8, 90, "relaxed", 1) end
        self:UpdateContextMode()
    elseif event == "PLAYER_CONTROL_GAINED" then
        if r.onTaxi and readableBoolean(safe(UnitOnTaxi, "player")) == false then r.onTaxi = false; self:ReactContext("flightland", {}, 8, 90, "neutral", 0) end
        self:UpdateContextMode()
    elseif event == "PLAYER_FLAGS_CHANGED" then self:HandlePlayerFlagsChanged()
    elseif event == "PLAYER_UPDATE_RESTING" then self:HandleRestingChanged()
    elseif event == "PLAYER_GUILD_UPDATE" then self:HandleGuildUpdate()
    elseif event == "MAIL_SHOW" then r.mailOpen = true; r.mailLootables = countMailboxLootables(); self:UpdateContextMode()
    elseif event == "MAIL_CLOSED" then r.mailOpen = false; if self.DropQueuedTopic then self:DropQueuedTopic("mail") end; self:UpdateContextMode()
    elseif event == "MAIL_INBOX_UPDATE" then self:HandleMailUpdate()
    elseif event == "BANKFRAME_OPENED" then r.bankOpen = true; self:ReactContext("bank", {}, 6, 120); self:UpdateContextMode()
    elseif event == "BANKFRAME_CLOSED" then r.bankOpen = false; if self.DropQueuedTopic then self:DropQueuedTopic("bank") end; self:UpdateContextMode()
    elseif event == "AUCTION_HOUSE_SHOW" then r.auctionOpen = true; if self.RefreshGoldIntegration then self:RefreshGoldIntegration() end; self:ReactContext("auction", {}, 6, 180); self:UpdateContextMode()
    elseif event == "AUCTION_HOUSE_CLOSED" then r.auctionOpen = false; if self.DropQueuedTopic then self:DropQueuedTopic("auction") end; if self.RefreshGoldIntegration then self:RefreshGoldIntegration() end; if self.RevalueGoldSession then self:RevalueGoldSession() end; self:UpdateContextMode()
    elseif event == "MERCHANT_SHOW" then r.merchantOpen = true; r.durabilityCurrent, r.durabilityMax, r.broken = durabilityTotals(); self:UpdateContextMode()
    elseif event == "MERCHANT_CLOSED" then r.merchantOpen = false; self:UpdateContextMode()
    elseif event == "UPDATE_INVENTORY_DURABILITY" then self:HandleDurabilityChange()
    elseif event == "UI_ERROR_MESSAGE" then local _, message = ...; self:HandleUIError(message)
    elseif event == "READY_CHECK" then self:ReactContext("readycheck", {}, 9, 90)
    elseif event == "READY_CHECK_CONFIRM" then self:HandleReadyCheckConfirm(...)
    elseif event == "PARTY_INVITE_REQUEST" then self:ReactContext("invite", {}, 8, 90)
    elseif event == "ENCOUNTER_START" then
        local encounterID, encounterName = ...
        if type(self.OnDungeonEncounterStart) == "function" then self:OnDungeonEncounterStart(encounterID, encounterName) end
    elseif event == "BOSS_KILL" then
        local encounterID, encounterName = ...
        r.groupInstanceHadBossKill = true
        if type(self.OnDungeonBossKill) == "function" and self.db and self.db.dungeon and self.db.dungeon.enabled ~= false then
            self:OnDungeonBossKill(encounterID, encounterName)
            self:SetMood("impressed", 5, 120)
        else
            self:ReactContext("bosskill", { name = encounterName or "that boss" }, 50, 30, "impressed", 5)
        end
    elseif event == "ENCOUNTER_END" then
        local encounterID, encounterName, _, _, success = ...
        if type(self.OnDungeonEncounterEnd) == "function" then self:OnDungeonEncounterEnd(encounterID, encounterName, success) end
    elseif event == "TRADE_SHOW" then r.tradeOpen = true; self:ReactContext("trade", {}, 5, 120); self:UpdateContextMode()
    elseif event == "TRADE_CLOSED" then r.tradeOpen = false; if self.DropQueuedTopic then self:DropQueuedTopic("trade") end; self:UpdateContextMode()
    elseif event == "DELETE_ITEM_CONFIRM" then self:HandleDeleteItem(...)
    elseif event == "BARBER_SHOP_OPEN" then r.barberOpen = true; self:ReactContext("barber", {}, 5, 180, "amused", 1)
    elseif event == "BARBER_SHOP_CLOSE" then r.barberOpen = false; if self.DropQueuedTopic then self:DropQueuedTopic("barber") end
    elseif event == "PLAYER_PVP_KILLS_CHANGED" then self:ReactContext("pvpkill", {}, 15, 45, "impressed", 2)
    elseif event == "UPDATE_BATTLEFIELD_STATUS" then self:HandleBattlegroundResult()
    elseif event == "COMBAT_TEXT_UPDATE" then self:HandleCombatText(...)
    elseif event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" then self:HandleSpellEvent(event, ...)
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_HITS" then
        local message = ...
        if message and containsPattern(message, GROUND_DAMAGE_PATTERNS) and type(self.QueuePersonalityVoiceCategory) == "function" then
            self:QueuePersonalityVoiceCategory("standing_in_fire", { priority = 58, cooldown = 50, maxAge = 3, speechCategory = "warning", anim = "angry", topic = "standinginfire", preempt = true })
        end
    elseif event == "CHAT_MSG_LOOT" then self:HandleLootMessage(...)
    elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then self:HandlePowerUpdate(...)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then self:HandleEquipmentChanged(...)
    elseif event == "PLAYER_CAMPING" then self:ReactContext("logout", {}, 5, 240)
    elseif event == "CINEMATIC_START" then r.cinematic = true
    elseif event == "CINEMATIC_STOP" then r.cinematic = false
    elseif event == "LOADING_SCREEN_ENABLED" then r.loading = true
    elseif event == "LOADING_SCREEN_DISABLED" then r.loading = false
    elseif event == "GROUP_ROSTER_UPDATE" then self:CheckInstanceTransitions(); self:CheckGroupRole()
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then self:CheckInstanceTransitions()
    end
end


function FC:CheckEnvironmentTransitions()
    local r = self.state.runtime or {}
    local swimming = safe(IsSwimming) and true or false
    if swimming and not r.swimming then self:ReactContext("swim", {}, 6, 120, "amused", 0)
    elseif not swimming and r.swimming then self:ReactContext("shore", {}, 5, 120, "neutral", 0) end
    r.swimming = swimming

    if not r.timeCommented and type(GetGameTime) == "function" then
        local hour = select(1, safe(GetGameTime))
        if hour and (hour >= 21 or hour < 5) then
            r.timeCommented = true
            self:QueueTopic("night", {}, 4, 3600)
        end
    end

    if self.state.inCombat and type(self.QueuePersonalityVoiceCategory) == "function" then
        local enemies = hostileNameplateCount()
        if enemies and enemies >= 4 then
            self:QueuePersonalityVoiceCategory("overpull", { priority = 34, cooldown = 90, maxAge = 4, speechCategory = "combat", anim = "worried", topic = "overpull" })
        end
    end

    if r.moving and not self.state.inCombat and not r.onTaxi then
        local mapID, x, y = playerMapPoint()
        if mapID and x and y then
            local now = GetTime()
            local last = r.travelPoint
            if last and last.mapID == mapID then
                local dx, dy = x - last.x, y - last.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist >= 0.0035 then
                    if last.dx and last.dy then
                        local oldLen = math.sqrt(last.dx * last.dx + last.dy * last.dy)
                        if oldLen > 0 and dist > 0 then
                            local dot = (dx * last.dx + dy * last.dy) / (dist * oldLen)
                            if dot < -0.55 and now - (r.lastTravelReverse or 0) >= 5 then
                                r.lastTravelReverse = now
                                if now - (r.travelReverseWindow or 0) > 90 then
                                    r.travelReverseWindow = now
                                    r.travelReverseCount = 0
                                end
                                r.travelReverseCount = (r.travelReverseCount or 0) + 1
                                if r.travelReverseCount >= 2 and type(self.QueuePersonalityVoiceCategory) == "function" then
                                    self:QueuePersonalityVoiceCategory("lost_wrong_way", { priority = 6, cooldown = 300, maxAge = 10, speechCategory = "world", anim = "laugh", topic = "lostwrongway" })
                                    r.travelReverseCount = 0
                                    r.travelReverseWindow = now
                                end
                            end
                        end
                    end
                    r.travelPoint = { mapID = mapID, x = x, y = y, dx = dx, dy = dy, at = now }
                end
            else
                r.travelPoint = { mapID = mapID, x = x, y = y, at = now }
                r.travelReverseCount = 0
                r.travelReverseWindow = now
            end
        end
    else
        r.travelPoint = nil
        r.travelReverseCount = 0
    end
end


function FC:GetTravelShare()
    local modes = self.state.modeSeconds or {}
    local total = 0
    for _, seconds in pairs(modes) do total = total + (tonumber(seconds) or 0) end
    if total <= 0 then return 0 end
    local travel = (modes.traveling or 0) + (modes.taxi or 0)
    return travel / total
end

function FC:ContextTick(elapsed)
    self:UpdateMood()
    self.state.modeSeconds = self.state.modeSeconds or {}
    local mode = self.state.contextMode or "unknown"
    self.state.modeSeconds[mode] = (self.state.modeSeconds[mode] or 0) + (elapsed or 0)
    self.state.sessionZones = self.state.sessionZones or {}
    local zoneName = self.state.zone or "Unknown"
    local zoneRecord = self.state.sessionZones[zoneName] or { xp = 0, seconds = 0 }
    zoneRecord.seconds = (zoneRecord.seconds or 0) + (elapsed or 0)
    self.state.sessionZones[zoneName] = zoneRecord
    self.state.runtime = self.state.runtime or {}
    local r = self.state.runtime
    r.fallPoll = (r.fallPoll or 0) + (elapsed or 0)
    r.environmentPoll = (r.environmentPoll or 0) + (elapsed or 0)
    if r.environmentPoll >= 3 then
        r.environmentPoll = 0
        self:CheckEnvironmentTransitions()
    end
    if r.fallPoll < 0.20 then return end
    r.fallPoll = 0

    if type(IsFalling) == "function" then
        local falling = safe(IsFalling) and true or false
        local now = GetTime()
        if falling and not r.fallActive then
            r.fallActive = true
            r.fallStartedAt = now
        elseif not falling and r.fallActive then
            local duration = now - (r.fallStartedAt or now)
            r.fallActive = false
            r.fallStartedAt = 0

            -- Normal jumping and actual long falls are deliberately different behaviors.
            -- Forever/private clients can keep IsFalling true longer than retail on an ordinary hop,
            -- so only treat genuinely long airtime as a long-fall reaction.
            if duration >= 2.0 then
                self:ReactContext("longfall", { duration = duration }, 8, 120, "amused", -1)
                r.jumpStreak = 0
            elseif duration >= 0.12 then
                r.jumpCount = (r.jumpCount or 0) + 1
                if now - (r.lastJumpAt or 0) <= 4.0 then
                    r.jumpStreak = (r.jumpStreak or 0) + 1
                else
                    r.jumpStreak = 1
                end
                r.lastJumpAt = now

                -- Repeated hopping gets its own large dialogue pool. The topic cooldown keeps
                -- it chatty without generating a bubble on every single landing.
                if r.jumpStreak >= 3 then
                    self:ReactContext("jumpstreak", { count = r.jumpStreak, total = r.jumpCount }, 4, 18, "amused", 0)
                end

                -- A few playful session milestones so repeated jumping can develop callbacks.
                r.jumpMilestones = r.jumpMilestones or {}
                local milestones = { 10, 25, 50, 100, 250, 500, 1000 }
                for _, milestone in ipairs(milestones) do
                    if r.jumpCount >= milestone and not r.jumpMilestones[milestone] then
                        r.jumpMilestones[milestone] = true
                        self:QueueTopic("jumpmilestone", { count = milestone }, 5, 0, true)
                        break
                    end
                end
            end
        end
    end
end
