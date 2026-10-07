local FC = _G.ForeverCompanion

function FC:RememberLevel(level)
    if not self.db or not self.db.memory then return end

    local memory = self.db.memory
    memory.levels = memory.levels or {}
    memory.profile = memory.profile or {}

    memory.levels[tostring(level)] = {
        at = time(),
        played = GetTime() - self.startTime,
        zone = self.state.zone,
        xpRate = self:XPPerHour(),
    }

    memory.profile.level = level

    if self.db.sharedMemory and self.characterKey and self.db.sharedMemory.characters then
        local info = self.db.sharedMemory.characters[self.characterKey] or {}
        info.level = level
        info.lastSeen = time()
        self.db.sharedMemory.characters[self.characterKey] = info
    end

    if self.AddJournal then
        self:AddJournal(
            "level",
            "Reached level " .. tostring(level) .. " in " .. tostring(self.state.zone or "the world") .. "."
        )
    end
end

function FC:TouchZone()
    if not self.db or not self.db.memory then
        return "Unknown", nil
    end

    local zone = "Unknown"
    if type(GetRealZoneText) == "function" then
        zone = GetRealZoneText() or "Unknown"
    elseif type(GetZoneText) == "function" then
        zone = GetZoneText() or "Unknown"
    end

    if zone == "" then
        zone = "Unknown"
    end

    local now = GetTime()
    local oldZone = self.state.zone
    local memory = self.db.memory
    memory.zones = memory.zones or {}
    memory.profile = memory.profile or {}

    if oldZone and oldZone ~= zone then
        local session = self.state.zoneSession or {}
        if session.start then
            local record = memory.zones[oldZone] or {
                seconds = 0,
                xp = 0,
                visits = 0,
                deaths = 0,
            }

            record.seconds = (record.seconds or 0) + math.max(0, now - session.start)
            record.xp = (record.xp or 0) + (session.xp or 0)
            memory.zones[oldZone] = record
        end
    end

    if oldZone ~= zone then
        self.state.zone = zone
        self.state.zoneSession = {
            start = now,
            xp = 0,
            startXP = (type(UnitXP) == "function" and self:ReadableNumber(UnitXP("player"))) or 0,
        }

        local record = memory.zones[zone] or {
            seconds = 0,
            xp = 0,
            visits = 0,
            deaths = 0,
        }
        record.visits = (record.visits or 0) + 1
        memory.zones[zone] = record
        memory.profile.zone = zone
    end

    return zone, oldZone
end

function FC:ZoneHistoricalRate(zone)
    if not self.db or not self.db.memory or not self.db.memory.zones then
        return 0
    end

    local record = self.db.memory.zones[zone]
    if not record or (record.seconds or 0) < 300 then
        return 0
    end

    return ((record.xp or 0) / record.seconds) * 3600
end

function FC:RecordQuestTurnin(id, xp)
    if not self.db or not self.db.memory then return end

    local memory = self.db.memory
    memory.questTurnins = (memory.questTurnins or 0) + 1
    memory.completedQuestIDs = memory.completedQuestIDs or {}
    memory.questHistory = memory.questHistory or {}

    if id then
        memory.completedQuestIDs[id] = true
        memory.questHistory[id] = memory.questHistory[id] or {}
        memory.questHistory[id].completed = time()
    end

    if xp and xp > 0 then
        local key = id or 0
        memory.questHistory[key] = memory.questHistory[key] or {}
        memory.questHistory[key].xp = xp
    end

    if self.AddJournal then
        local suffix = ""
        if xp and xp > 0 then
            suffix = " for " .. self:FormatNumber(xp) .. " XP"
        end
        self:AddJournal("quest", "Turned in quest " .. tostring(id or "unknown") .. suffix .. ".")
    end
end

function FC:ProfileSummary()
    if not self.db or not self.db.memory then
        return {}
    end
    return self.db.memory.profile or {}
end
