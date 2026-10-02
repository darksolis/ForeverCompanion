local FC = _G.ForeverCompanion

function FC:AddXP(delta, source)
    if not delta or delta <= 0 then return end

    self.state.sessionXP = (self.state.sessionXP or 0) + delta
    self.state.zoneSession.xp = (self.state.zoneSession.xp or 0) + delta
    self.state.sessionZones = self.state.sessionZones or {}
    local zoneName = self.state.zone or "Unknown"
    local zone = self.state.sessionZones[zoneName] or { xp = 0, seconds = 0 }
    zone.xp = (zone.xp or 0) + delta
    self.state.sessionZones[zoneName] = zone

    table.insert(self.state.xpEvents, {
        t = GetTime(),
        xp = delta,
        source = source or "unknown",
    })

    while #self.state.xpEvents > 800 do
        table.remove(self.state.xpEvents, 1)
    end

    self:TouchAction()
end

function FC:RollingXP(seconds)
    local now = GetTime()
    local total = 0
    local oldest = nil

    for _, event in ipairs(self.state.xpEvents) do
        if now - event.t <= seconds then
            total = total + event.xp
            oldest = oldest and math.min(oldest, event.t) or event.t
        end
    end

    if not oldest then return 0, total end
    local span = math.max(1, math.min(seconds, now - oldest))
    return total / span * 3600, total
end

function FC:AvgCombatXP()
    local samples = self.state.combatSamples
    local count = #samples
    if count == 0 then return 0 end

    local total = 0
    local first = math.max(1, count - 29)
    for i = first, count do
        total = total + (samples[i].xp or 0)
    end
    return total / (count - first + 1)
end

function FC:Estimate()
    local remaining = self:XPRemaining()
    local rate = self:RollingXP(900)
    if rate <= 0 then rate = self:XPPerHour() end

    local seconds = rate > 0 and remaining / rate * 3600 or nil
    local averageCombatXP = self:AvgCombatXP()
    local fights = averageCombatXP > 0 and math.ceil(remaining / averageCombatXP) or nil
    return remaining, rate, seconds, fights
end

function FC:XPProgress()
    if not UnitXPMax or not UnitXP then return 0 end
    local maximum = self:ReadableNumber(UnitXPMax("player"))
    local current = self:ReadableNumber(UnitXP("player"))
    return self:SafeRatio(current, maximum) or 0
end

function FC:CurrentXPFactKey()
    local rawLevel = UnitLevel and UnitLevel("player") or nil
    local level = self:ReadableNumber(rawLevel) or 0
    return tostring(self.characterKey or self:GetCharacterKey()) .. ":" .. tostring(level)
end

function FC:MilestoneMatchesProgress(topic, progress)
    progress = tonumber(progress) or 0
    if topic == "xp25" then return progress >= 0.25 and progress < 0.50 end
    if topic == "xp50" then return progress >= 0.50 and progress < 0.75 end
    if topic == "xp75" then return progress >= 0.75 and progress < 0.90 end
    if topic == "xp90" then return progress >= 0.90 end
    return true
end

function FC:IsMilestoneStillAccurate(topic, expectedKey)
    if expectedKey ~= self:CurrentXPFactKey() then return false end
    return self:MilestoneMatchesProgress(topic, self:XPProgress())
end

function FC:CheckXPIntelligence()
    if not self.db.xp then return end

    local progress = self:XPProgress()
    local factKey = self:CurrentXPFactKey()

    -- New character or level: establish the baseline. Never "catch up" old milestones.
    if self.state.xpProgressKey ~= factKey then
        self.state.xpProgressKey = factKey
        self.state.lastXPProgress = progress
        return
    end

    local previous = self.state.lastXPProgress or progress
    self.state.lastXPProgress = progress

    -- Only announce the highest threshold crossed during this actual XP change.
    local crossedTopic = nil
    if previous < 0.90 and progress >= 0.90 then
        crossedTopic = "xp90"
    elseif previous < 0.75 and progress >= 0.75 then
        crossedTopic = "xp75"
    elseif previous < 0.50 and progress >= 0.50 then
        crossedTopic = "xp50"
    elseif previous < 0.25 and progress >= 0.25 then
        crossedTopic = "xp25"
    end

    if crossedTopic then
        local topic = crossedTopic
        local keyAtQueueTime = factKey
        self:QueueTopic(
            topic,
            { percent = math.floor(progress * 100) },
            72,
            300,
            false,
            function()
                return FC:IsMilestoneStillAccurate(topic, keyAtQueueTime)
            end
        )
    end

    local rate5 = self:RollingXP(300)
    local rate15 = self:RollingXP(900)
    if rate5 > 0 and rate15 > 0 then
        if rate5 > rate15 * 1.4 then
            self:QueueTopic("fastpace", { r5 = rate5, r15 = rate15 }, 20, 300)
        elseif rate5 < rate15 * 0.58 then
            self:QueueTopic("slowpace", { r5 = rate5, r15 = rate15 }, 12, 360)
        end
    end

    local _, _, _, fights = self:Estimate()
    if fights and fights <= 8 then
        local keyAtQueueTime = factKey
        self:QueueTopic(
            "nearlevel",
            { count = fights },
            22,
            180,
            false,
            function()
                if keyAtQueueTime ~= FC:CurrentXPFactKey() then return false end
                local _, _, _, liveFights = FC:Estimate()
                return liveFights and liveFights <= 8
            end
        )
    end
end
