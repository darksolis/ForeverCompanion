local FC = _G.ForeverCompanion

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e = pcall(fn, ...)
    if ok then return a, b, c, d, e end
    return nil
end

local function readableNumber(v)
    return FC:ReadableNumber(v)
end

local function readableString(v)
    return FC:ReadableString(v)
end

local function readableBoolean(v)
    return FC:ReadableBoolean(v)
end

local function safeBool(v)
    local b = readableBoolean(v)
    return b == true
end

function FC:CaptureFacts(reason)
    local facts = {
        reason = reason or "unknown",
        at = GetTime(),
        unix = type(time) == "function" and time() or 0,
        characterKey = self.characterKey or self:GetCharacterKey(),
        context = self.state.contextMode or "unknown",
        inCombat = self.state.inCombat and true or false,
        mood = self.state.mood and self.state.mood.name or "neutral",
        confidence = "high",
        restricted = {},
        sources = {
            xp = "UnitXP/UnitXPMax",
            level = "UnitLevel",
            zone = "GetRealZoneText/GetZoneText",
            health = "UnitHealth/UnitHealthMax",
            power = "UnitPower/UnitPowerMax",
            target = "Unit target APIs",
            bags = "container APIs",
            durability = "GetInventoryItemDurability",
            quests = "quest-log snapshot",
        },
    }

    facts.name = readableString(safeCall(UnitName, "player")) or "Unknown"
    facts.realm = readableString(safeCall(GetRealmName)) or "UnknownRealm"

    local className, classToken = safeCall(UnitClass, "player")
    className = readableString(className)
    classToken = readableString(classToken)
    facts.class = className or classToken or "Unknown"
    facts.classToken = classToken or facts.class

    facts.level = readableNumber(safeCall(UnitLevel, "player")) or 0
    facts.xp = readableNumber(safeCall(UnitXP, "player")) or 0
    facts.xpMax = readableNumber(safeCall(UnitXPMax, "player")) or 0
    facts.xpPct = self:SafeRatio(facts.xp, facts.xpMax) or 0

    facts.zone = readableString(safeCall(GetRealZoneText)) or readableString(safeCall(GetZoneText)) or "Unknown"
    facts.subZone = readableString(safeCall(GetSubZoneText)) or ""

    local hp = readableNumber(safeCall(UnitHealth, "player"))
    local hpMax = readableNumber(safeCall(UnitHealthMax, "player"))
    local hpRatio = self:SafeRatio(hp, hpMax)
    if hpRatio ~= nil then
        facts.healthPct = hpRatio
    else
        facts.healthPct = nil
        facts.restricted.health = true
        facts.confidence = "partial"
        facts.sources.health = "restricted by client"
    end

    local powerTypeID, powerToken = safeCall(UnitPowerType, "player")
    powerTypeID = readableNumber(powerTypeID)
    powerToken = readableString(powerToken)
    facts.powerType = powerToken or tostring(powerTypeID or "")
    if powerTypeID ~= nil then
        local p = readableNumber(safeCall(UnitPower, "player", powerTypeID))
        local pMax = readableNumber(safeCall(UnitPowerMax, "player", powerTypeID))
        local powerRatio = self:SafeRatio(p, pMax)
        if powerRatio ~= nil then
            facts.powerPct = powerRatio
        else
            facts.powerPct = nil
            facts.restricted.power = true
            facts.confidence = "partial"
            facts.sources.power = "restricted by client"
        end
    end

    facts.mounted = safeBool(safeCall(IsMounted))
    facts.resting = safeBool(safeCall(IsResting))
    facts.taxi = safeBool(safeCall(UnitOnTaxi, "player"))
    facts.stealthed = safeBool(safeCall(IsStealthed))

    local inInstance, instanceType = safeCall(IsInInstance)
    local readableInstance = readableBoolean(inInstance)
    facts.inInstance = readableInstance == true
    facts.instanceType = readableString(instanceType)
    facts.instanceName = facts.inInstance and readableString(safeCall(GetInstanceInfo)) or nil
    facts.groupMembers = readableNumber(safeCall(GetNumGroupMembers)) or 0

    local q = self.state.questSnapshot or {}
    facts.questsActive = tonumber(q.active) or 0
    facts.questsComplete = tonumber(q.complete) or 0
    facts.knownQuestXP = tonumber(q.knownRewardXP) or 0

    local free, total = 0, 0
    if type(self.BagSpace) == "function" then free, total = self:BagSpace() end
    facts.bagFree = tonumber(free) or 0
    facts.bagTotal = tonumber(total) or 0
    facts.lowestDurability = type(self.LowestDurability) == "function" and (tonumber(self:LowestDurability()) or 1) or 1
    facts.money = readableNumber(safeCall(GetMoney)) or 0
    facts.restedXP = readableNumber(safeCall(GetXPExhaustion)) or 0

    local exists = readableBoolean(safeCall(UnitExists, "target"))
    if exists == true then
        local targetName = readableString(safeCall(UnitName, "target"))
        local targetLevel = readableNumber(safeCall(UnitLevel, "target"))
        local classification = readableString(safeCall(UnitClassification, "target"))
        local targetDead = readableBoolean(safeCall(UnitIsDeadOrGhost, "target"))
        local targetEnemy = readableBoolean(safeCall(UnitCanAttack, "player", "target"))
        local targetFriend = readableBoolean(safeCall(UnitIsFriend, "player", "target"))

        if targetName or targetLevel or classification or targetEnemy ~= nil or targetFriend ~= nil then
            facts.target = {
                name = targetName,
                level = targetLevel,
                classification = classification,
                dead = targetDead == true,
                enemy = targetEnemy == true,
                friend = targetFriend == true,
            }
        else
            facts.restricted.target = true
            facts.confidence = "partial"
        end
    end

    self.state.lastFactSnapshot = facts
    return facts
end

function FC:ValidateStatement(topic, data, queuedFacts)
    data = data or {}
    local live = self:CaptureFacts("validate:" .. tostring(topic))

    if queuedFacts and queuedFacts.characterKey and live.characterKey ~= queuedFacts.characterKey then
        return false
    end

    if topic == "xp25" then return live.xpPct >= 0.25 and live.xpPct < 0.50 end
    if topic == "xp50" then return live.xpPct >= 0.50 and live.xpPct < 0.75 end
    if topic == "xp75" then return live.xpPct >= 0.75 and live.xpPct < 0.90 end
    if topic == "xp90" then return live.xpPct >= 0.90 end
    if topic == "zone" and data.zone then return live.zone == data.zone end
    if topic == "bags" and data.free then return live.bagFree <= data.free and live.bagTotal > 0 end
    if topic == "repair" and data.percent then return math.floor((live.lowestDurability or 1) * 100) <= data.percent + 2 end
    if topic == "lowhealth" and data.percent then
        if live.healthPct == nil then return false end
        return math.floor(live.healthPct * 100) <= math.max(15, data.percent + 5)
    end
    if topic == "fastpace" and self.RollingXP then
        local r5, r15 = self:RollingXP(300), self:RollingXP(900)
        return r5 > 0 and r15 > 0 and r5 > r15 * 1.25
    end
    if topic == "slowpace" and self.RollingXP then
        local r5, r15 = self:RollingXP(300), self:RollingXP(900)
        return r5 > 0 and r15 > 0 and r5 < r15 * 0.70
    end
    if topic == "questpile" and data.count then return live.questsComplete >= data.count end
    if topic == "questlevel" then return (live.knownQuestXP or 0) >= self:XPRemaining() end
    if topic == "targetdanger" and data.name then
        return live.target and live.target.name ~= nil and live.target.name == data.name and live.target.enemy == true
    end
    if topic == "targetelite" and data.name then
        return live.target and live.target.name ~= nil and live.target.name == data.name
    end
    if topic == "restenter" then return live.resting end
    if topic == "mount" then return live.mounted end
    if topic == "dismount" then return not live.mounted end
    if topic == "capital" and data.zone then return live.zone == data.zone end
    if topic == "instanceenter" and data.name then return live.inInstance and (not live.instanceName or live.instanceName == data.name) end
    if topic == "rolechange" and data.role and UnitGroupRolesAssigned then
        local role = readableString(safeCall(UnitGroupRolesAssigned, "player")) or "NONE"
        return role == data.role
    end
    if topic == "restedxp" and GetXPExhaustion then
        local rested = readableNumber(safeCall(GetXPExhaustion))
        return rested ~= nil and rested > 0
    end
    if topic == "traveltime" and self.GetTravelShare then return self:GetTravelShare() >= 0.45 end
    if topic == "queststalled" and data.title and self.FindStalledQuest then
        local title = self:FindStalledQuest(480)
        return title == data.title
    end
    if topic == "ragecap" or topic == "energycap" or topic == "manalow" then
        local powerID = readableNumber((safeCall(UnitPowerType, "player")))
        if powerID == nil then return false end
        local current = readableNumber(safeCall(UnitPower, "player", powerID))
        local maximum = readableNumber(safeCall(UnitPowerMax, "player", powerID))
        if current == nil or maximum == nil or maximum <= 0 then return false end
        local pct = current / maximum
        if topic == "ragecap" then return pct >= 0.85 end
        if topic == "energycap" then return pct >= 0.90 end
        if topic == "manalow" then return pct <= 0.18 end
    end
    return true
end

function FC:FactsToText(facts)
    facts = facts or self.state.lastFactSnapshot or self:CaptureFacts("explain")
    local target = "none"
    if facts.target then
        target = string.format(
            "%s L%s %s",
            tostring(facts.target.name or "restricted"),
            tostring(facts.target.level or "?"),
            tostring(facts.target.classification or "normal")
        )
    elseif facts.restricted and facts.restricted.target then
        target = "restricted"
    end

    local healthText = facts.healthPct ~= nil and (tostring(math.floor(facts.healthPct * 100)) .. "%") or "restricted"

    return string.format(
        "character=%s | %s level %d | XP %.1f%% | zone=%s | health=%s | context=%s | quests=%d/%d ready | bags=%d/%d free | durability=%d%% | target=%s",
        tostring(facts.characterKey or "?"),
        tostring(facts.class or "?"),
        tonumber(facts.level or 0),
        (tonumber(facts.xpPct or 0) * 100),
        tostring(facts.zone or "?"),
        healthText,
        tostring(facts.context or "?"),
        tonumber(facts.questsActive or 0),
        tonumber(facts.questsComplete or 0),
        tonumber(facts.bagFree or 0),
        tonumber(facts.bagTotal or 0),
        math.floor((tonumber(facts.lowestDurability or 1)) * 100),
        target
    )
end

function FC:LogSpeech(text, meta)
    if not text or not self.db then return end
    self.db.sharedMemory = self.db.sharedMemory or {}
    self.db.sharedMemory.dialogueHistory = self.db.sharedMemory.dialogueHistory or {}
    local history = self.db.sharedMemory.dialogueHistory
    local entry = {
        at = type(time) == "function" and time() or 0,
        text = tostring(text),
        topic = meta and meta.topic or "direct",
        category = meta and meta.category or "direct",
        reason = meta and meta.reason or nil,
        facts = meta and meta.facts or self:CaptureFacts("speech"),
        characterKey = self.characterKey,
    }
    history[#history + 1] = entry
    while #history > 120 do table.remove(history, 1) end
    self.state.lastSpeech = entry
end

function FC:WhyLastStatement()
    local last = self.state.lastSpeech
    if not last then
        local history = self.db and self.db.sharedMemory and self.db.sharedMemory.dialogueHistory
        last = history and history[#history] or nil
    end
    if not last then
        self:Say("I don't have a previous statement to explain yet.", "think", 100, true)
        return
    end
    self:Debug("Last line: " .. tostring(last.text))
    self:Debug("topic=" .. tostring(last.topic) .. " category=" .. tostring(last.category) .. " reason=" .. tostring(last.reason or last.topic))
    self:Debug("facts: " .. self:FactsToText(last.facts))
    if last.facts and last.facts.sources then
        self:Debug("sources: XP=" .. tostring(last.facts.sources.xp) .. " zone=" .. tostring(last.facts.sources.zone) .. " quests=" .. tostring(last.facts.sources.quests) .. " confidence=" .. tostring(last.facts.confidence or "unknown"))
    end
    local f = last.facts or {}
    local reason = tostring(last.reason or last.topic or "the game state I saw")
    local short = string.format("Because of %s. At that moment: level %s, %.0f%% XP, %s.", reason, tostring(f.level or "?"), (tonumber(f.xpPct or 0) * 100), tostring(f.zone or "unknown zone"))
    if self.ShowBubble then self:ShowBubble(short) end
end

function FC:RepeatLastStatement()
    local last = self.state.lastSpeech
    if not last then
        self:Say("I haven't said anything worth repeating yet.", "shrug", 100, true)
        return
    end
    if self.SetAnimation then self:SetAnimation("talk") end
    if self.ShowBubble then self:ShowBubble("I said: " .. tostring(last.text)) end
end

function FC:DialogueHistoryLines(limit)
    local history = self.db and self.db.sharedMemory and self.db.sharedMemory.dialogueHistory or {}
    local out = {}
    local first = math.max(1, #history - (limit or 50) + 1)
    for i = #history, first, -1 do
        local e = history[i]
        local stamp = type(date) == "function" and date("%b %d %H:%M", e.at or time()) or ""
        out[#out + 1] = stamp .. "  |cffbd7cff" .. tostring(e.topic or "speech") .. "|r\n" .. tostring(e.text or "")
    end
    if #out == 0 then out[1] = "No conversation history yet." end
    return out
end

function FC:RecommendNextAction()
    local facts = self:CaptureFacts("recommendation")
    if type(self.IsDungeonContext) == "function" and self:IsDungeonContext() then
        self:ShowDungeonIntel()
    elseif facts.healthPct ~= nil and facts.healthPct > 0 and facts.healthPct < 0.25 then
        self:Say("First priority: recover. Your health is too low for the next ambitious pull.", "worried", 100, true, { topic = "advice", category = "warning", facts = facts, reason = "health below 25%" })
    elseif facts.bagTotal > 0 and facts.bagFree / facts.bagTotal < 0.08 then
        self:Say("I'd clear bags next. You're almost out of space, and that turns good loot into annoyance.", "point", 100, true, { topic = "advice", category = "warning", facts = facts, reason = "bags nearly full" })
    elseif facts.lowestDurability < 0.18 then
        self:Say("Repair next. Your lowest durability is getting uncomfortable.", "point", 100, true, { topic = "advice", category = "warning", facts = facts, reason = "durability under 18%" })
    elseif facts.questsComplete >= 4 then
        self:Say("I'd turn quests in next. You have " .. tostring(facts.questsComplete) .. " finished and waiting.", "point", 100, true, { topic = "advice", category = "quests", facts = facts, reason = "multiple completed quests" })
    elseif facts.knownQuestXP > 0 and facts.knownQuestXP >= self:XPRemaining() then
        self:Say("Turn in your completed quests. The known reward XP may already be enough to level you.", "point", 100, true, { topic = "advice", category = "quests", facts = facts, reason = "known quest XP can cover remaining XP" })
    elseif facts.xpPct >= 0.90 then
        self:Say("You're in the final ten percent. I'd stay on this character and finish the level before doing chores.", "point", 100, true, { topic = "advice", category = "xp", facts = facts, reason = "XP above 90%" })
    else
        self:Say("Nothing urgent is flashing red. Keep questing, keep moving, and let me interrupt when the facts say something actually matters.", "talk", 100, true, { topic = "advice", category = "ambient", facts = facts, reason = "no urgent condition" })
    end
end

function FC:ShowBagStatus()
    local facts = self:CaptureFacts("bag status")
    self:Say(string.format("You have %d free bag slots out of %d.", facts.bagFree or 0, facts.bagTotal or 0), "point", 100, true, { topic = "bagstatus", category = "world", facts = facts, reason = "requested bag status" })
end

function FC:ShowQuestStatus()
    local snapshot = self.ScanQuests and self:ScanQuests(true) or (self.state.questSnapshot or {})
    local facts = self:CaptureFacts("quest status")
    facts.questsActive = tonumber(snapshot.active) or facts.questsActive or 0
    facts.questsComplete = tonumber(snapshot.complete) or facts.questsComplete or 0
    facts.questScanValid = snapshot.valid
    facts.questScanPartial = snapshot.partial
    facts.questScanSource = snapshot.source

    if snapshot.valid == false then
        self:Say("I can't confidently read your full quest log right now. I won't pretend that means zero quests. Use /fc questdebug and I'll show exactly what the client is exposing.", "think", 100, true, { topic = "queststatus", category = "quests", facts = facts, reason = "quest log scan unavailable" })
    elseif snapshot.partial then
        self:Say(string.format("I can confirm %d active quests right now, with %d ready to turn in, but the detailed quest scan is partial on this client.", facts.questsActive or 0, facts.questsComplete or 0), "think", 100, true, { topic = "queststatus", category = "quests", facts = facts, reason = "partial quest log scan" })
    else
        self:Say(string.format("You have %d active quests, with %d ready to turn in.", facts.questsActive or 0, facts.questsComplete or 0), "point", 100, true, { topic = "queststatus", category = "quests", facts = facts, reason = "requested quest status" })
    end
end

function FC:ShowRosterSummary()
    local chars = self.db and self.db.sharedMemory and self.db.sharedMemory.characters or {}
    local list = {}
    for _, info in pairs(chars) do
        if info and info.name then list[#list + 1] = tostring(info.name) .. " the " .. tostring(info.class or "adventurer") .. " (" .. tostring(info.level or "?") .. ")" end
    end
    table.sort(list)
    if #list == 0 then
        self:Say("I don't remember any other characters yet.", "shrug", 100, true)
    else
        self:Say("I remember: " .. table.concat(list, ", ") .. ".", "talk", 100, true)
    end
end

function FC:BlockLastStatement()
    local last = self.state.lastSpeech
    if not last or not last.text then self:Debug("No last line to block."); return end
    self.db.sharedMemory.blockedLines = self.db.sharedMemory.blockedLines or {}
    self.db.sharedMemory.blockedLines[last.text] = true
    self:Debug("Blocked that exact line from future random selection.")
end

function FC:FavoriteLastStatement()
    local last = self.state.lastSpeech
    if not last or not last.text then self:Debug("No last line to favorite."); return end
    self.db.sharedMemory.favoriteLines = self.db.sharedMemory.favoriteLines or {}
    self.db.sharedMemory.favoriteLines[last.text] = (self.db.sharedMemory.favoriteLines[last.text] or 0) + 1
    self:Debug("Favorited that line.")
end
