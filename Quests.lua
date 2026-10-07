local FC = _G.ForeverCompanion

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e = pcall(fn, ...)
    if ok then return a, b, c, d, e end
    return nil
end

local function readableCount(value)
    if value == nil then return 0 end
    if type(canaccessvalue) == "function" then
        local ok, accessible = pcall(canaccessvalue, value)
        if ok and not accessible then return 0 end
    end
    if type(issecretvalue) == "function" then
        local ok, secret = pcall(issecretvalue, value)
        if ok and secret then return 0 end
    end
    local ok, number = pcall(tonumber, value)
    if ok and number then return math.max(0, number) end
    return 0
end

local function getQuestCount()
    local bestShown, bestQuests = 0, 0
    local sources = {}

    -- Forever can expose both the retail compatibility API and the legacy quest-log API.
    -- Query both; an existing modern function is not proof its data is the authoritative one.
    if C_QuestLog and type(C_QuestLog.GetNumQuestLogEntries) == "function" then
        local shown, quests = safeCall(C_QuestLog.GetNumQuestLogEntries)
        shown, quests = readableCount(shown), readableCount(quests)
        bestShown = math.max(bestShown, shown)
        bestQuests = math.max(bestQuests, quests)
        sources[#sources + 1] = string.format("modern:%d/%d", shown, quests)
    end

    if type(GetNumQuestLogEntries) == "function" then
        local shown, quests = safeCall(GetNumQuestLogEntries)
        shown, quests = readableCount(shown), readableCount(quests)
        bestShown = math.max(bestShown, shown)
        bestQuests = math.max(bestQuests, quests)
        sources[#sources + 1] = string.format("legacy:%d/%d", shown, quests)
    end

    return bestShown, bestQuests, (#sources > 0 and table.concat(sources, "+") or "none")
end

local function questTitleForID(id)
    if not id then return nil end
    if C_QuestLog and type(C_QuestLog.GetTitleForQuestID) == "function" then
        local title = safeCall(C_QuestLog.GetTitleForQuestID, id)
        if type(title) == "string" and title ~= "" then return title end
    end
    if C_QuestLog and type(C_QuestLog.GetQuestInfo) == "function" then
        local title = safeCall(C_QuestLog.GetQuestInfo, id)
        if type(title) == "string" and title ~= "" then return title end
    end
    return nil
end

local function questComplete(id, legacyComplete)
    if legacyComplete ~= nil then
        return legacyComplete == 1 or legacyComplete == true
    end
    if id and C_QuestLog and type(C_QuestLog.IsComplete) == "function" then
        local v = safeCall(C_QuestLog.IsComplete, id)
        return v == true
    end
    return false
end

local function questObjectives(self, id)
    local out = {}
    if not id or not C_QuestLog or type(C_QuestLog.GetQuestObjectives) ~= "function" then
        return out
    end

    local objectives = safeCall(C_QuestLog.GetQuestObjectives, id)
    if type(objectives) ~= "table" then return out end

    for _, objective in ipairs(objectives) do
        local current = tonumber(objective.numFulfilled) or 0
        local required = tonumber(objective.numRequired) or 0
        out[#out + 1] = {
            text = objective.text,
            cur = current,
            need = required,
            finished = objective.finished == true,
        }
    end
    return out
end

local function addQuest(self, snapshot, id, title, complete, xp, objectives)
    if not id and not title then return false end

    local key = id or ("title:" .. tostring(title))
    if snapshot.quests[key] then return false end

    local quest = {
        id = id,
        title = title or (id and questTitleForID(id)) or "Unknown quest",
        complete = complete == true,
        xp = tonumber(xp) or 0,
        objectives = objectives or {},
    }
    snapshot.quests[key] = quest
    snapshot.scanned = snapshot.scanned + 1

    if quest.complete then
        snapshot.complete = snapshot.complete + 1
        snapshot.knownRewardXP = snapshot.knownRewardXP + (quest.xp or 0)
    end

    for _, objective in ipairs(quest.objectives) do
        snapshot.objectivesTotal = snapshot.objectivesTotal + 1
        if objective.finished then snapshot.objectivesDone = snapshot.objectivesDone + 1 end
    end
    return true
end

function FC:GetQuestSnapshot()
    local out = {
        active = 0,
        complete = 0,
        quests = {},
        knownRewardXP = 0,
        objectivesDone = 0,
        objectivesTotal = 0,
        scanned = 0,
        shownEntries = 0,
        reportedQuests = 0,
        watchedQuests = 0,
        source = "none",
        detailSource = "none",
        valid = false,
        partial = false,
        scannedAt = GetTime(),
    }

    local shown, reported, source = getQuestCount()
    out.shownEntries = shown
    out.reportedQuests = reported
    out.source = source

    -- Primary path: enumerate quest-log rows.
    for index = 1, shown do
        local handled = false

        if C_QuestLog and type(C_QuestLog.GetInfo) == "function" then
            local info = safeCall(C_QuestLog.GetInfo, index)
            if type(info) == "table" then
                handled = true
                if not info.isHeader then
                    local id = tonumber(info.questID)
                    local title = info.title or questTitleForID(id) or ("Quest " .. tostring(id or index))
                    local xp = (id and type(GetQuestLogRewardXP) == "function" and safeCall(GetQuestLogRewardXP, id)) or 0
                    addQuest(self, out, id or index, title, questComplete(id), xp, questObjectives(self, id))
                    out.detailSource = "C_QuestLog.GetInfo"
                end
            end
        end

        -- Fallback for modern clients where GetInfo is temporarily unavailable: ask for quest ID at index.
        if not handled and C_QuestLog and type(C_QuestLog.GetQuestIDForLogIndex) == "function" then
            local id = tonumber(safeCall(C_QuestLog.GetQuestIDForLogIndex, index))
            if id and id > 0 then
                local title = questTitleForID(id) or ("Quest " .. tostring(id))
                local xp = (type(GetQuestLogRewardXP) == "function" and safeCall(GetQuestLogRewardXP, id)) or 0
                addQuest(self, out, id, title, questComplete(id), xp, questObjectives(self, id))
                out.detailSource = "C_QuestLog.GetQuestIDForLogIndex"
                handled = true
            end
        end

        -- Legacy/private-client fallback.
        if not handled and type(GetQuestLogTitle) == "function" then
            local title, _, _, isHeader, _, isComplete, _, id = safeCall(GetQuestLogTitle, index)
            if title and not isHeader then
                addQuest(self, out, tonumber(id) or index, title, questComplete(id, isComplete), 0, {})
                out.detailSource = "GetQuestLogTitle"
            end
        end
    end

    -- Secondary path: watched/tracked quests. This is not the whole log, but it prevents a false zero
    -- when the client exposes tracker data before the full log enumeration is ready.
    if C_QuestLog and type(C_QuestLog.GetNumQuestWatches) == "function" and type(C_QuestLog.GetQuestIDForQuestWatchIndex) == "function" then
        local watchCount = tonumber(safeCall(C_QuestLog.GetNumQuestWatches)) or 0
        for i = 1, watchCount do
            local id = tonumber(safeCall(C_QuestLog.GetQuestIDForQuestWatchIndex, i))
            if id and id > 0 then
                out.watchedQuests = out.watchedQuests + 1
                local title = questTitleForID(id) or ("Quest " .. tostring(id))
                local xp = (type(GetQuestLogRewardXP) == "function" and safeCall(GetQuestLogRewardXP, id)) or 0
                addQuest(self, out, id, title, questComplete(id), xp, questObjectives(self, id))
                if out.detailSource == "none" then out.detailSource = "quest watch" end
            end
        end
    end

    -- The second return from GetNumQuestLogEntries is the authoritative count of actual quests.
    -- Preserve it even if row-level APIs could not be fully read.
    out.active = math.max(out.scanned, out.reportedQuests, out.watchedQuests)

    if out.reportedQuests > 0 then
        out.valid = true
        out.partial = out.scanned < out.reportedQuests
    elseif out.scanned > 0 or out.watchedQuests > 0 then
        out.valid = true
        out.partial = false
    elseif out.shownEntries == 0 and out.reportedQuests == 0 then
        -- Zero can be legitimate. Treat it as confirmed only when a quest-log count API actually exists.
        out.valid = source ~= "none"
        out.partial = false
    else
        out.valid = false
        out.partial = true
    end

    return out
end

function FC:ScanQuests(silent)
    self.state.questProgressTimes = self.state.questProgressTimes or {}
    local old = self.state.questSnapshot or { quests = {}, complete = 0 }
    local current = self:GetQuestSnapshot()
    self.state.questSnapshot = current

    if self.db and self.db.memory then
        local profile = self.db.memory.profile or {}
        self.db.memory.profile = profile
        profile.activeQuests = current.active
        profile.completedInLog = current.complete
        profile.knownCompletedQuestXP = current.knownRewardXP
        profile.questScanValid = current.valid
        profile.questScanPartial = current.partial
        profile.questScanSource = current.source
    end

    if silent or not self.db.quests then return current end

    for id, newQuest in pairs(current.quests) do
        local oldQuest = old.quests and old.quests[id]
        local track = self.state.questProgressTimes[id] or { firstSeen = GetTime(), objectives = {} }
        self.state.questProgressTimes[id] = track

        for objectiveIndex, objective in ipairs(newQuest.objectives or {}) do
            local previous = oldQuest and oldQuest.objectives and oldQuest.objectives[objectiveIndex]
            if not track.objectives[objectiveIndex] then track.objectives[objectiveIndex] = GetTime() end
            if previous and ((objective.cur or 0) > (previous.cur or 0) or objective.finished ~= previous.finished) then
                track.objectives[objectiveIndex] = GetTime()
                track.lastProgress = GetTime()
            end
        end

        if oldQuest and not oldQuest.complete and newQuest.complete then
            self:QueueTopic("questdone", { title = newQuest.title }, 32, 15)
        elseif oldQuest and not newQuest.complete then
            local oldObjectives = oldQuest.objectives or {}
            local newObjectives = newQuest.objectives or {}
            for objectiveIndex, objective in ipairs(newObjectives) do
                local previous = oldObjectives[objectiveIndex]
                if previous
                    and (objective.cur or 0) > (previous.cur or 0)
                    and (objective.need or 0) > 1
                    and not objective.finished
                then
                    local expectedID = id
                    local expectedIndex = objectiveIndex
                    local expectedCurrent = objective.cur or 0
                    local expectedRequired = objective.need or 0
                    self:QueueTopic(
                        "objective",
                        { title = newQuest.title, current = expectedCurrent, required = expectedRequired },
                        12,
                        55,
                        false,
                        function()
                            local live = FC.state.questSnapshot and FC.state.questSnapshot.quests and FC.state.questSnapshot.quests[expectedID]
                            local liveObjective = live and live.objectives and live.objectives[expectedIndex]
                            return liveObjective
                                and not liveObjective.finished
                                and (liveObjective.cur or 0) == expectedCurrent
                                and (liveObjective.need or 0) == expectedRequired
                        end
                    )
                    break
                end
            end
        end
    end

    local suppressDungeonReminders = type(self.IsDungeonContext) == "function"
        and self:IsDungeonContext()
        and self.db.dungeon
        and self.db.dungeon.suppressQuestReminders ~= false

    if not suppressDungeonReminders and current.complete >= 4 and current.complete > (old.complete or 0) then
        local expectedCount = current.complete
        self:QueueTopic("questpile", { count = expectedCount }, 24, 180, false, function()
            return not FC:IsDungeonContext() and FC.state.questSnapshot and FC.state.questSnapshot.complete == expectedCount
        end)
    end

    if not suppressDungeonReminders and current.knownRewardXP > 0 and current.knownRewardXP >= self:XPRemaining() then
        self:QueueTopic("questlevel", { xp = current.knownRewardXP }, 45, 240, false, function()
            local live = FC.state.questSnapshot or {}
            return not FC:IsDungeonContext() and (live.knownRewardXP or 0) > 0 and (live.knownRewardXP or 0) >= FC:XPRemaining()
        end)
    end

    return current
end

function FC:QuestDiagnostics()
    local snap = self:GetQuestSnapshot()
    self.state.questSnapshot = snap
    self:Debug(string.format(
        "Quest scan: active=%d scanned=%d reported=%d watched=%d entries=%d valid=%s partial=%s source=%s detail=%s",
        snap.active or 0,
        snap.scanned or 0,
        snap.reportedQuests or 0,
        snap.watchedQuests or 0,
        snap.shownEntries or 0,
        tostring(snap.valid),
        tostring(snap.partial),
        tostring(snap.source),
        tostring(snap.detailSource)
    ))
    local shown = 0
    for _, quest in pairs(snap.quests or {}) do
        shown = shown + 1
        if shown <= 12 then
            self:Debug(string.format("  #%s %s%s", tostring(quest.id or "?"), tostring(quest.title or "Unknown"), quest.complete and " [READY]" or ""))
        end
    end
    return snap
end

function FC:FindStalledQuest(minSeconds)
    minSeconds = minSeconds or 600
    local now = GetTime()
    local snapshot = self.state.questSnapshot or {}
    local tracking = self.state.questProgressTimes or {}
    for id, quest in pairs(snapshot.quests or {}) do
        if not quest.complete and #(quest.objectives or {}) > 0 then
            local track = tracking[id]
            if track then
                local newest = track.lastProgress or track.firstSeen or now
                if now - newest >= minSeconds then
                    for _, objective in ipairs(quest.objectives or {}) do
                        if not objective.finished and (objective.need or 0) > 0 then
                            return quest.title, objective.text, now - newest
                        end
                    end
                end
            end
        end
    end
    return nil
end
