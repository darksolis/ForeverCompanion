local FC = _G.ForeverCompanion

local function unitXP()
    if type(UnitXP) ~= "function" then return 0 end
    local ok, value = pcall(UnitXP, "player")
    if not ok then return 0 end
    return FC:ReadableNumber(value) or 0
end

local function healthFraction()
    local current = FC:SafeUnitNumber(UnitHealth, "player")
    local maximum = FC:SafeUnitNumber(UnitHealthMax, "player")
    return FC:SafeRatio(current, maximum)
end

function FC:CombatStart()
    self.state.inCombat = true
    self.state.combat = {
        start = GetTime(),
        xp = unitXP(),
        healthPct = healthFraction(),
    }
    if type(self.QueuePersonalityVoiceCategory) == "function" then
        self:QueuePersonalityVoiceCategory("combat_start", { chance = 0.34, priority = 18, cooldown = 75, maxAge = 5, speechCategory = "combat", anim = "think", topic = "combatstart" })
    end
    self:TouchAction()
end

function FC:CombatEnd()
    self.state.inCombat = false
    self.state.lastCombatEnd = GetTime()

    local combat = self.state.combat or {}
    local duration = math.max(0, GetTime() - (combat.start or GetTime()))
    local gained = FC:SafeSubtract(unitXP(), combat.xp or 0) or 0

    if gained > 0 then
        table.insert(self.state.combatSamples, {
            t = GetTime(),
            xp = gained,
            duration = duration,
        })
        while #self.state.combatSamples > 100 do table.remove(self.state.combatSamples, 1) end
        self.db.memory.lifetimeCombatXP = (self.db.memory.lifetimeCombatXP or 0) + gained
    end

    local hp = healthFraction()
    if hp ~= nil and hp < 0.10 then
        self:QueueTopic("lowhealth", { percent = math.floor(hp * 100) }, 35, 90)
    elseif gained > 0 then
        local chatty = tonumber(self.db.chatty) or 0.5
        local chance = 0.06 + chatty * 0.12
        local topic = "combatwin"
        local cooldown = 160

        if duration <= 7 then
            topic = "combatquick"
            chance = chance + 0.08
            cooldown = 120
        elseif duration >= 25 then
            topic = "combatlong"
            chance = chance + 0.10
            cooldown = 180
        end

        if math.random() < chance then
            self:QueueTopic(topic, { duration = duration, xp = gained }, 8, cooldown)
        end
    end

    if gained > 0 and duration >= 2 and type(self.QueuePersonalityVoiceCategory) == "function" then
        local chatty = tonumber(self.db.chatty) or 0.5
        self:QueuePersonalityVoiceCategory("combat_win", { chance = 0.08 + chatty * 0.08, priority = 9, cooldown = 105, maxAge = 8, speechCategory = "combat", anim = "playful", topic = "combatwin_voice" })
    end

    local details = type(self.GetDetailsSnapshot) == "function" and self:GetDetailsSnapshot() or nil
    self.state.lastCombatOutcome = {
        duration = duration,
        xp = gained,
        healthPct = hp,
        healthRestricted = hp == nil,
        target = self.state.lastEnemyName,
        details = details,
        at = GetTime(),
    }

    self:TouchAction()
end

function FC:ShowLastFight()
    local fight = self.state.lastCombatOutcome
    if not fight then
        self:Say("I don't have a completed fight snapshot yet.", "shrug", 100, true)
        return
    end

    local text = string.format(
        "Last fight: %s, %.1f seconds, %s XP",
        tostring(fight.target or "unknown target"),
        tonumber(fight.duration or 0),
        self:FormatNumber(fight.xp or 0)
    )

    if fight.healthPct ~= nil then
        text = text .. string.format(", ended at %d%% health.", math.floor(fight.healthPct * 100))
    else
        text = text .. ". Health was protected by the client during that fight."
    end

    if fight.details and fight.details.dps then
        text = text .. " Details reports roughly " .. self:FormatNumber(fight.details.dps) .. " DPS."
    end

    self:Say(text, "think", 100, true, {
        topic = "lastfight",
        category = "combat",
        facts = self:CaptureFacts("last fight request"),
        reason = "requested last combat snapshot",
    })
end

function FC:OnDeath()
    self.db.memory.lifetimeDeaths = (self.db.memory.lifetimeDeaths or 0) + 1
    local zone = self.db.memory.zones[self.state.zone or ""]
    if zone then zone.deaths = (zone.deaths or 0) + 1 end

    local recentEnemy = self.state.lastEnemyName
    local recentAt = self.state.lastEnemyAt or 0
    if recentEnemy and GetTime() - recentAt <= 30 then
        self.db.memory.deathsByMob = self.db.memory.deathsByMob or {}
        self.db.memory.deathsByMob[recentEnemy] = (self.db.memory.deathsByMob[recentEnemy] or 0) + 1
        local count = self.db.memory.deathsByMob[recentEnemy]
        if count >= 2 then
            self:QueueTopic("deathpattern", { name = recentEnemy, count = count }, 101, 0, true)
            return
        end
    end
    self:QueueTopic("death", { deaths = self.db.memory.lifetimeDeaths }, 100, 0)
end
