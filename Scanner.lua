local FC = _G.ForeverCompanion

function FC:ScanEquipment()
    local out = { count = 0, items = {} }
    for slot = 1, 19 do
        local id = GetInventoryItemID and GetInventoryItemID("player", slot)
        if id then
            out.count = out.count + 1
            out.items[slot] = id
        end
    end
    return out
end

function FC:ScanProfessions()
    local out = {}
    if GetProfessions and GetProfessionInfo then
        for _, index in ipairs({ GetProfessions() }) do
            if index then
                local name, _, rank, maxRank = GetProfessionInfo(index)
                if name then
                    out[#out + 1] = { name = name, rank = rank, max = maxRank }
                end
            end
        end
    end
    return out
end

function FC:ScanReputation()
    return (C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetNumFactions())
        or (GetNumFactions and GetNumFactions())
        or 0
end

function FC:ScanCompletedQuestHistory()
    local result = { supported = false, enumerable = false, count = 0 }
    if not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then return result end

    result.supported = true
    if C_QuestLog.GetAllCompletedQuestIDs then
        local ids = self:Safe(C_QuestLog.GetAllCompletedQuestIDs)
        if type(ids) == "table" then
            result.enumerable = true
            for _, id in ipairs(ids) do
                self.db.memory.completedQuestIDs[id] = true
                result.count = result.count + 1
            end
        end
    end
    return result
end

function FC:RefreshLiveProfile()
    if not self.db or not self.db.memory then return nil end

    local profile = self.db.memory.profile or {}
    self.db.memory.profile = profile

    local className, classToken
    if UnitClass then className, classToken = UnitClass("player") end

    profile.name = UnitName and (self:ReadableString(UnitName("player")) or profile.name or "Hero") or profile.name or "Hero"
    local rawLevel = UnitLevel and UnitLevel("player") or nil
    profile.level = self:ReadableNumber(rawLevel) or profile.level or 0
    profile.race = UnitRace and select(1, UnitRace("player")) or profile.race
    profile.raceToken = UnitRace and select(2, UnitRace("player")) or profile.raceToken
    profile.class = className or classToken or profile.class or "Unknown"
    profile.classToken = classToken or profile.classToken
    if GetSpecialization and GetSpecializationInfo then
        local specIndex = self:Safe(GetSpecialization)
        if specIndex then
            local _, specName = self:Safe(GetSpecializationInfo, specIndex)
            profile.spec = specName or profile.spec
        end
    end
    profile.realm = GetRealmName and GetRealmName() or profile.realm or ""
    profile.zone = (GetRealZoneText and GetRealZoneText()) or profile.zone or ""
    profile.xp = UnitXP and (self:ReadableNumber(UnitXP("player")) or profile.xp or 0) or profile.xp or 0
    profile.xpMax = UnitXPMax and (self:ReadableNumber(UnitXPMax("player")) or profile.xpMax or 0) or profile.xpMax or 0
    profile.money = GetMoney and (self:ReadableNumber(GetMoney()) or profile.money or 0) or profile.money or 0
    profile.lastScan = time()

    if self.db.sharedMemory and self.characterKey then
        local info = self.db.sharedMemory.characters[self.characterKey] or {}
        info.name = profile.name
        info.realm = profile.realm
        info.class = profile.class
        info.classToken = profile.classToken
        info.level = profile.level
        info.lastSeen = time()
        self.db.sharedMemory.characters[self.characterKey] = info
    end

    return profile
end

function FC:RunCatchup(manual)
    if self.state.scanning then return end
    self.state.scanning = true

    self:DetectCapabilities()
    local profile = self:RefreshLiveProfile() or self.db.memory.profile
    profile.equipment = self:ScanEquipment()
    profile.reputations = self:ScanReputation()
    profile.professions = self:ScanProfessions()
    profile.achievementPoints = GetTotalAchievementPoints and GetTotalAchievementPoints() or nil

    local quests = self:ScanQuests(true)
    local history = self:ScanCompletedQuestHistory()
    profile.completedHistorySupported = history.supported
    profile.completedHistoryEnumerable = history.enumerable
    profile.completedHistoryKnown = history.count

    self.db.onboarded = true
    if self.character then self.character.onboarded = true end
    self.state.scanning = false

    if manual then
        self:QueueTopic("rescan", { quests = quests.active, complete = quests.complete }, 100, 0, true)
        return
    end

    local previous = self.state.characterSwitchFrom
    if previous and previous.name and previous.name ~= profile.name then
        self:QueueTopic(
            "charswitch",
            {
                name = profile.name,
                class = profile.class,
                previousName = previous.name,
                previousClass = previous.class or "your other character",
            },
            100,
            0,
            true
        )
        self.state.characterSwitchFrom = nil
    else
        if quests and quests.valid == false then
            self:QueueSay(
                string.format("Okay, %s. Level %d %s. I know who you are, but the client hasn't given me a reliable quest-log read yet, so I'm not going to invent a quest count.", tostring(profile.name or "hero"), tonumber(profile.level or 0), tostring(profile.class or "adventurer")),
                "think",
                100,
                0,
                "newplayer_quest_pending",
                true
            )
        else
            self:QueueTopic(
                "newplayer",
                {
                    name = profile.name,
                    level = profile.level,
                    quests = quests.active,
                    complete = quests.complete,
                    history = history.count,
                },
                100,
                0,
                true
            )
        end
    end
end

function FC:ShowProfile()
    local profile = self:RefreshLiveProfile() or {}
    local quests = self.ScanQuests and self:ScanQuests(true) or (self.state.questSnapshot or {})
    local knownCharacters = 0
    if self.db.sharedMemory and self.db.sharedMemory.characters then
        for _ in pairs(self.db.sharedMemory.characters) do knownCharacters = knownCharacters + 1 end
    end

    local info = self.characterKey and self.db.sharedMemory.characters[self.characterKey] or {}
    local dominantMode, dominantShare = nil, 0
    for mode, share in pairs(info.playstyle or {}) do
        if share > dominantShare then dominantMode, dominantShare = mode, share end
    end

    local classText = profile.class or ""
    if profile.spec and profile.spec ~= "" then classText = tostring(profile.spec) .. " " .. classText end
    local questText
    if quests.valid == false then
        questText = "quest log still syncing"
    elseif quests.partial then
        questText = string.format("at least %d active quests, %d ready (partial scan)", quests.active or 0, quests.complete or 0)
    else
        questText = string.format("%d active quests, %d ready", quests.active or 0, quests.complete or 0)
    end
    local message = string.format(
        "%s, level %d %s. %s. I remember %d character%s and we've had %d sessions on this one.",
        profile.name or "Hero", profile.level or 0, classText, questText,
        knownCharacters, knownCharacters == 1 and "" or "s", self.db.memory.sessions or 0
    )
    if dominantMode then
        message = message .. " Your last tracked playstyle leaned most toward " .. tostring(dominantMode) .. "."
    end
    self:Say(message, "point", 100, true, { topic = "profile_request", category = "memory", facts = self:CaptureFacts("profile request"), reason = "requested character profile" })
end
