local FC = _G.ForeverCompanion

function FC:BeginSessionTracking()
    if not self.db or not self.db.memory then return end
    self.state.sessionBaseline = {
        at = type(time) == "function" and time() or 0,
        level = type(UnitLevel) == "function" and (self:ReadableNumber(UnitLevel("player")) or 0) or 0,
        deaths = self.db.memory.lifetimeDeaths or 0,
        quests = self.db.memory.questTurnins or 0,
        xp = self.state.sessionXP or 0,
    }
    self.state.previousSessionSummary = self.db.memory.lastSession
end

function FC:FinalizeSession(reason)
    if not self.db or not self.db.memory then return end
    local baseline = self.state.sessionBaseline or {}
    local bestZone, bestZoneRate = nil, 0
    for zoneName, record in pairs(self.state.sessionZones or {}) do
        if (record.seconds or 0) >= 60 then
            local rate = ((record.xp or 0) / math.max(1, record.seconds or 0)) * 3600
            if rate > bestZoneRate then bestZone, bestZoneRate = zoneName, rate end
        end
    end

    local modeTotal = 0
    for _, seconds in pairs(self.state.modeSeconds or {}) do modeTotal = modeTotal + (seconds or 0) end
    local playstyle = {}
    if modeTotal > 0 then
        for mode, seconds in pairs(self.state.modeSeconds or {}) do playstyle[mode] = (seconds or 0) / modeTotal end
    end

    local summary = {
        ended = type(time) == "function" and time() or 0,
        reason = reason or "logout",
        duration = self:SessionSeconds(),
        xp = self.state.sessionXP or 0,
        startLevel = baseline.level or ((UnitLevel and self:ReadableNumber(UnitLevel("player"))) or 0),
        endLevel = (UnitLevel and self:ReadableNumber(UnitLevel("player"))) or baseline.level or 0,
        deaths = math.max(0, (self.db.memory.lifetimeDeaths or 0) - (baseline.deaths or 0)),
        quests = math.max(0, (self.db.memory.questTurnins or 0) - (baseline.quests or 0)),
        zone = self.state.zone,
        xpRate = self:XPPerHour(),
        bestZone = bestZone,
        bestZoneRate = bestZoneRate,
        playstyle = playstyle,
    }
    self.db.memory.lastSession = summary
    if self.characterKey and self.db.sharedMemory and self.db.sharedMemory.characters then
        local info = self.db.sharedMemory.characters[self.characterKey] or {}
        info.lastSession = summary
        info.playstyle = playstyle
        self.db.sharedMemory.characters[self.characterKey] = info
    end
end

function FC:ShowLastSession()
    local summary = self.db and self.db.memory and self.db.memory.lastSession
    if not summary then
        self:Say("I don't have a completed session summary for this character yet.", "shrug", 100, true)
        return
    end
    local text = string.format(
        "Last session: %s XP in %s, %d quest turn-ins, %d deaths, level %d to %d.",
        self:FormatNumber(summary.xp or 0), self:FormatDuration(summary.duration or 0), summary.quests or 0, summary.deaths or 0, summary.startLevel or 0, summary.endLevel or 0
    )
    if summary.bestZone then text = text .. " Best XP zone was " .. tostring(summary.bestZone) .. " at about " .. self:FormatNumber(summary.bestZoneRate or 0) .. " XP/hour." end
    self:Say(text, "talk", 100, true, { topic = "lastsession_request", category = "memory", facts = self:CaptureFacts("last session request"), reason = "requested saved session summary" })
end

function FC:MaybeQueuePreviousSessionSummary()
    local summary = self.state.previousSessionSummary
    if not summary or (summary.duration or 0) < 180 then return end
    self:QueueTopic(
        "lastsession",
        {
            xp = self:FormatNumber(summary.xp or 0),
            duration = self:FormatDuration(summary.duration or 0),
            quests = summary.quests or 0,
            deaths = summary.deaths or 0,
            startLevel = summary.startLevel or 0,
            endLevel = summary.endLevel or 0,
        },
        9,
        900
    )
end

function FC:MaybeQueueCrossCharacterMemory(previousInfo)
    if not previousInfo or not previousInfo.name then return end
    local last = previousInfo.lastSession
    if last and (last.duration or 0) >= 180 then
        self:QueueTopic("charcallback", {
            name = previousInfo.name,
            class = previousInfo.class or "adventurer",
            xp = self:FormatNumber(last.xp or 0),
            duration = self:FormatDuration(last.duration or 0),
            rate = self:FormatNumber(last.xpRate or 0),
        }, 7, 900)
    end
end
