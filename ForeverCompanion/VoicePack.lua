local FC = _G.ForeverCompanion

local BASE = "Interface\\AddOns\\ForeverCompanion\\Media\\Voice\\Vexa\\"

local CUES = {
    interrupt        = { files = { "interrupt.ogg", "Interrupt.ogg" }, cooldown = 1.5 },
    low_health       = { files = { "low_health.ogg", "low health.ogg" }, cooldown = 22 },
    close_call       = { files = { "close_call.ogg", "low_health.ogg", "low health.ogg" }, cooldown = 28 },
    sarcastic_death  = { files = { "sarcastic_death.ogg", "sarcastic death.ogg", "death.ogg" }, cooldown = 8 },
    back_alive       = { files = { "back_alive.ogg" }, cooldown = 20 },
    level_up         = { files = { "level_up.ogg" }, cooldown = 8 },
    almost_level     = { files = { "almost_level.ogg" }, cooldown = 90 },
    combat_win       = { files = { "combat_win.ogg" }, cooldown = 30 },
    hard_fight       = { files = { "hard_fight.ogg" }, cooldown = 45 },
    boss_pull        = { files = { "boss_pull.ogg" }, cooldown = 20 },
    boss_kill        = { files = { "boss_kill.ogg" }, cooldown = 12 },
    dungeon_entry    = { files = { "dungeon_entry.ogg" }, cooldown = 60 },
    dungeon_wipe     = { files = { "dungeon_wipe.ogg" }, cooldown = 30 },
    dungeon_complete = { files = { "dungeon_complete.ogg" }, cooldown = 60 },
    rare_loot        = { files = { "rare_loot.ogg" }, cooldown = 18 },
    epic_loot        = { files = { "epic_loot.ogg" }, cooldown = 12 },
    upgrade          = { files = { "upgrade.ogg" }, cooldown = 20 },
    quest_complete   = { files = { "quest_complete.ogg" }, cooldown = 40 },
    bags_full        = { files = { "bags_full.ogg" }, cooldown = 90 },
    repair_gear      = { files = { "repair_gear.ogg" }, cooldown = 120 },
    gear_broken      = { files = { "gear_broken.ogg" }, cooldown = 60 },
    ready_check      = { files = { "ready_check.ogg" }, cooldown = 30 },
    welcome_back     = { files = { "welcome_back.ogg" }, cooldown = 90 },
    pvp_kill         = { files = { "pvp_kill.ogg" }, cooldown = 20 },
    victory          = { files = { "victory.ogg" }, cooldown = 45 },
    defeat           = { files = { "defeat.ogg" }, cooldown = 45 },
    elite_target     = { files = { "elite_target.ogg" }, cooldown = 35 },
    dangerous_target = { files = { "dangerous_target.ogg" }, cooldown = 35 },
    low_mana         = { files = { "low_mana.ogg" }, cooldown = 40 },
    rage_full        = { files = { "rage_full.ogg" }, cooldown = 45 },
    energy_full      = { files = { "energy_full.ogg" }, cooldown = 45 },
    flight_start     = { files = { "flight_start.ogg" }, cooldown = 90 },
    flight_land      = { files = { "flight_land.ogg" }, cooldown = 90 },
    mounted          = { files = { "mounted.ogg" }, cooldown = 120 },
    swimming         = { files = { "swimming.ogg" }, cooldown = 120 },
    farm_start       = { files = { "farm_start.ogg" }, cooldown = 60 },
    farm_stop        = { files = { "farm_stop.ogg" }, cooldown = 60 },
    rare_found       = { files = { "rare_found.ogg" }, cooldown = 45 },
    quest_stalled    = { files = { "quest_stalled.ogg" }, cooldown = 120 },
    afk              = { files = { "afk.ogg" }, cooldown = 180 },
    hearth           = { files = { "hearth.ogg" }, cooldown = 120 },
}

local TOPIC_TO_CUE = {
    level = "level_up",
    nearlevel = "almost_level",
    death = "sarcastic_death",
    deathpattern = "sarcastic_death",
    revive = "back_alive",
    lowhealth = "low_health",
    combatwin = "combat_win",
    combatquick = "combat_win",
    combatlong = "hard_fight",
    bosskill = "boss_kill",
    dungeonbossstart = "boss_pull",
    dungeonboss = "boss_kill",
    dungeonwipe = "dungeon_wipe",
    dungeonenter = "dungeon_entry",
    instanceleavewin = "dungeon_complete",
    lootrare = "rare_loot",
    lootepic = "epic_loot",
    upgrade = "upgrade",
    questdone = "quest_complete",
    queststalled = "quest_stalled",
    bagfull = "bags_full",
    repair = "repair_gear",
    broken = "gear_broken",
    readycheck = "ready_check",
    afk = "afk",
    afkreturn = "welcome_back",
    pvpkill = "pvp_kill",
    bgwin = "victory",
    bgloss = "defeat",
    targetelite = "elite_target",
    targetdanger = "dangerous_target",
    manalow = "low_mana",
    ragecap = "rage_full",
    energycap = "energy_full",
    flightstart = "flight_start",
    flightland = "flight_land",
    mount = "mounted",
    swim = "swimming",
    goldstart = "farm_start",
    goldstop = "farm_stop",
    hearth = "hearth",
}

FC.voiceCueCatalog = CUES
FC.voiceTopicMap = TOPIC_TO_CUE

local function cfg(FC)
    return FC.db and FC.db.voicePack or {}
end

local function shuffledIndices(n)
    local result = {}
    for i = 1, n do result[i] = i end
    for i = n, 2, -1 do
        local j = math.random(1, i)
        result[i], result[j] = result[j], result[i]
    end
    return result
end

function FC:IsVexaVoiceAllowed()
    local c = cfg(self)
    if c.enabled == false then return false, "voice pack disabled" end
    if type(self.IsProcAudioAllowed) == "function" then
        local ok, reason = self:IsProcAudioAllowed("voice")
        if not ok then return false, reason end
    end
    return true, "enabled"
end

function FC:StopVexaEventVoice()
    local state = self.state and self.state.vexaVoice
    if state and state.handle and type(StopSound) == "function" then
        pcall(StopSound, state.handle)
        state.handle = nil
    end
end

function FC:PlayVexaVoiceCue(cue, options)
    options = options or {}
    local c = cfg(self)
    if c.enabled == false or c.eventVoices == false then return false, "event voice disabled" end
    local allowed, reason = self:IsVexaVoiceAllowed()
    if not allowed then return false, reason end
    if type(PlaySoundFile) ~= "function" then return false, "PlaySoundFile unavailable" end

    cue = tostring(cue or ""):lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    local info = CUES[cue]
    if not info then return false, "unknown cue" end

    self.state.vexaVoice = self.state.vexaVoice or { lastByCue = {}, lastGlobal = 0 }
    local state = self.state.vexaVoice
    local now = GetTime()
    local globalCooldown = tonumber(c.globalCooldown) or 3.0
    local cueCooldown = tonumber(options.cooldown) or tonumber(info.cooldown) or 15

    if not options.force then
        if now - (state.lastGlobal or -999) < globalCooldown then return false, "global cooldown" end
        if now - (state.lastByCue[cue] or -999) < cueCooldown then return false, "cue cooldown" end
    end

    local indices = shuffledIndices(#info.files)
    for _, index in ipairs(indices) do
        local filename = info.files[index]
        local path = BASE .. filename
        local ok, played, handle = pcall(PlaySoundFile, path, "Dialog")
        if ok and played ~= false and played ~= nil then
            if options.interruptCurrent then self:StopVexaEventVoice() end
            state.handle = handle
            state.lastGlobal = now
            state.lastByCue[cue] = now
            state.lastCue = cue
            state.lastFile = filename
            return true, filename
        end
    end
    return false, "clip missing"
end

function FC:GetVexaVoiceCueForTopic(topic, meta)
    topic = tostring(topic or "")
    if topic == "lowhealth" then
        local percent = meta and meta.data and tonumber(meta.data.percent)
        if percent and percent <= 5 then return "close_call" end
    end
    return TOPIC_TO_CUE[topic]
end

function FC:MaybePlayVexaVoiceForTopic(topic, meta)
    local cue = self:GetVexaVoiceCueForTopic(topic, meta)
    if not cue then return false end
    local urgent = (cue == "low_health" or cue == "close_call" or cue == "boss_pull")
    return self:PlayVexaVoiceCue(cue, { force = urgent, interruptCurrent = urgent })
end


function FC:CheckVexaHealthVoice(unit)
    if unit ~= "player" then return end
    if not self.state or not self.state.ready then return end
    local current = type(self.SafeUnitNumber) == "function" and self:SafeUnitNumber(UnitHealth, "player") or nil
    local maximum = type(self.SafeUnitNumber) == "function" and self:SafeUnitNumber(UnitHealthMax, "player") or nil
    local ratio = type(self.SafeRatio) == "function" and self:SafeRatio(current, maximum) or nil
    if ratio == nil then return end

    local previous = self.state.vexaHealthBand or "safe"
    local band = ratio <= 0.05 and "critical" or (ratio <= 0.12 and "low" or (ratio >= 0.22 and "safe" or previous))
    self.state.vexaHealthBand = band
    if band == previous then return end

    if band == "critical" then
        self:PlayVexaVoiceCue("close_call", { force = true, interruptCurrent = true })
    elseif band == "low" and previous == "safe" then
        self:PlayVexaVoiceCue("low_health", { force = true, interruptCurrent = true })
    end
end

function FC:GetVexaProcVoiceCandidatePaths(spellName)
    local name = tostring(spellName or "proc")
    local slug = name:lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    local files = { slug .. ".ogg" }
    if slug == "maelstrom_weapon" then files[#files + 1] = "maelstrom.ogg" end
    if slug == "riposte" then files[#files + 1] = "Riposte.ogg" end
    if slug == "overpower" then files[#files + 1] = "Overpower.ogg" end
    local paths = {}
    for _, file in ipairs(files) do paths[#paths + 1] = BASE .. file end
    return paths
end

function FC:TestVexaVoiceCue(cue)
    cue = tostring(cue or "interrupt"):lower():gsub("[^%w]+", "_")
    local ok, detail = self:PlayVexaVoiceCue(cue, { force = true, interruptCurrent = true })
    if ok then self:Debug("Vexa voice cue played: " .. tostring(cue) .. " via " .. tostring(detail))
    else self:Debug("Vexa voice cue unavailable: " .. tostring(cue) .. " (" .. tostring(detail) .. ")") end
    return ok
end

function FC:GetVexaVoiceCueList()
    local keys = {}
    for key in pairs(CUES) do keys[#keys + 1] = key end
    table.sort(keys)
    return keys
end

function FC:VoicePackDoctor()
    local allowed, reason = self:IsVexaVoiceAllowed()
    local c = cfg(self)
    self:Debug("Vexa voice-pack doctor:")
    self:Debug("enabled=" .. tostring(c.enabled ~= false) .. " eventVoices=" .. tostring(c.eventVoices ~= false) .. " audioAllowed=" .. tostring(allowed) .. " (" .. tostring(reason) .. ")")
    self:Debug("globalCooldown=" .. tostring(c.globalCooldown or 3.0) .. " PlaySoundFile=" .. tostring(type(PlaySoundFile) == "function"))
    local state = self.state and self.state.vexaVoice or {}
    self:Debug("lastCue=" .. tostring(state.lastCue or "none") .. " lastFile=" .. tostring(state.lastFile or "none"))
end
