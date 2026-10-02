local FC = _G.ForeverCompanion

local function norm(value)
    value = tostring(value or ""):lower()
    value = value:gsub("[%p%s]+", "")
    return value
end

local PROC_CATALOG = {
    WARRIOR = {
        { names = { "Overpower", "Taste for Blood" }, shout = { "OVERPOWER!", "OVERPOWER — NOW!", "OVERPOWER! TAKE IT!" }, triggers = { usable = true, overlay = true } },
        { names = { "Revenge" }, shout = { "REVENGE!", "REVENGE IS UP!" }, triggers = { usable = true, overlay = true } },
        { names = { "Sudden Death", "Execute" }, shout = { "EXECUTE!", "SUDDEN DEATH — EXECUTE!" }, triggers = { overlay = true } },
        { names = { "Bloodsurge", "Slam" }, shout = { "SLAM!", "BLOODSURGE — SLAM!" }, triggers = { overlay = true } },
        { names = { "Sword and Board", "Shield Slam" }, shout = { "SHIELD SLAM!", "SWORD AND BOARD!" }, triggers = { overlay = true } },
    },
    ROGUE = {
        { names = { "Riposte" }, shout = { "RIPOSTE!", "RIPOSTE — TAKE IT!", "RIPOSTE! NOW!" }, triggers = { usable = true, overlay = true } },
        { names = { "Blindside", "Ambush" }, shout = { "AMBUSH!", "BLINDSIDE!" }, triggers = { overlay = true } },
        { names = { "Audacity", "Dispatch" }, shout = { "DISPATCH!", "AUDACITY — DISPATCH!" }, triggers = { overlay = true } },
        { names = { "Opportunity" }, shout = { "OPPORTUNITY!", "OPENING — GO!" }, triggers = { overlay = true } },
    },
    SHAMAN = {
        { names = { "Maelstrom Weapon", "Maelstrom" }, shout = { "MAELSTROM!", "MAELSTROM READY!", "FIVE STACKS — GO!" }, triggers = { aura = true, overlay = true }, stacks = 5 },
        { names = { "Lava Surge" }, shout = { "LAVA SURGE!", "LAVA BURST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Stormbringer" }, shout = { "STORMBRINGER!", "STORMSTRIKE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Hot Hand" }, shout = { "HOT HAND!", "LAVA LASH!" }, triggers = { aura = true, overlay = true } },
        { names = { "Power of the Maelstrom" }, shout = { "LIGHTNING BOLT!", "MAELSTROM POWER!" }, triggers = { aura = true, overlay = true } },
    },
    PALADIN = {
        { names = { "The Art of War", "Art of War" }, shout = { "ART OF WAR!", "FREE CAST — GO!" }, triggers = { aura = true, overlay = true } },
        { names = { "Divine Purpose" }, shout = { "DIVINE PURPOSE!", "FREE FINISHER!" }, triggers = { aura = true, overlay = true } },
        { names = { "Infusion of Light" }, shout = { "INFUSION OF LIGHT!", "FREE HEAL!" }, triggers = { aura = true, overlay = true } },
        { names = { "Grand Crusader" }, shout = { "GRAND CRUSADER!", "AVENGER'S SHIELD!" }, triggers = { aura = true, overlay = true } },
        { names = { "Shining Light" }, shout = { "SHINING LIGHT!", "FREE WORD!" }, triggers = { aura = true, overlay = true } },
    },
    HUNTER = {
        { names = { "Lock and Load" }, shout = { "LOCK AND LOAD!", "EXPLOSIVE SHOT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Kill Shot", "Deathblow" }, shout = { "KILL SHOT!", "DEATHBLOW — KILL SHOT!" }, triggers = { usable = true, overlay = true } },
        { names = { "Precise Shots" }, shout = { "PRECISE SHOTS!", "ARCANE SHOT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Tip of the Spear" }, shout = { "TIP OF THE SPEAR!" }, triggers = { aura = true, overlay = true } },
    },
    MAGE = {
        { names = { "Hot Streak" }, shout = { "HOT STREAK!", "PYROBLAST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Heating Up" }, shout = { "HEATING UP!" }, triggers = { aura = true, overlay = true } },
        { names = { "Fingers of Frost" }, shout = { "FINGERS OF FROST!", "ICE LANCE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Brain Freeze" }, shout = { "BRAIN FREEZE!", "FLURRY!" }, triggers = { aura = true, overlay = true } },
        { names = { "Clearcasting", "Arcane Missiles!" }, shout = { "CLEARCASTING!", "ARCANE MISSILES!" }, triggers = { aura = true, overlay = true } },
    },
    WARLOCK = {
        { names = { "Nightfall", "Shadow Trance" }, shout = { "NIGHTFALL!", "SHADOW BOLT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Demonic Core" }, shout = { "DEMONIC CORE!", "DEMONBOLT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Molten Core" }, shout = { "MOLTEN CORE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Backdraft" }, shout = { "BACKDRAFT!", "CHAOS BOLT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Decimation" }, shout = { "DECIMATION!", "SOUL FIRE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Soulburn" }, shout = { "SOULBURN!" }, triggers = { aura = true, overlay = true } },
    },
    PRIEST = {
        { names = { "Surge of Light" }, shout = { "SURGE OF LIGHT!", "FREE FLASH HEAL!" }, triggers = { aura = true, overlay = true } },
        { names = { "Shadowy Insight" }, shout = { "SHADOWY INSIGHT!", "MIND BLAST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Divine Insight" }, shout = { "DIVINE INSIGHT!" }, triggers = { aura = true, overlay = true } },
        { names = { "Power of the Dark Side" }, shout = { "POWER OF THE DARK SIDE!", "PENANCE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Mind Melt" }, shout = { "MIND MELT!" }, triggers = { aura = true, overlay = true } },
    },
    DRUID = {
        { names = { "Clearcasting", "Omen of Clarity" }, shout = { "CLEARCASTING!", "FREE CAST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Predatory Swiftness" }, shout = { "PREDATORY SWIFTNESS!", "INSTANT CAST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Shooting Stars" }, shout = { "SHOOTING STARS!", "STARSURGE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Gore" }, shout = { "GORE!", "MANGLE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Tooth and Claw" }, shout = { "TOOTH AND CLAW!" }, triggers = { aura = true, overlay = true } },
        { names = { "Sudden Ambush" }, shout = { "SUDDEN AMBUSH!" }, triggers = { aura = true, overlay = true } },
        { names = { "Lunar Eclipse", "Solar Eclipse" }, shout = { "ECLIPSE!", "ECLIPSE — PUSH!" }, triggers = { aura = true, overlay = true } },
    },
    DEATHKNIGHT = {
        { names = { "Killing Machine" }, shout = { "KILLING MACHINE!", "OBLITERATE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Rime", "Freezing Fog" }, shout = { "RIME!", "HOWLING BLAST!" }, triggers = { aura = true, overlay = true } },
        { names = { "Sudden Doom" }, shout = { "SUDDEN DOOM!", "DEATH COIL!" }, triggers = { aura = true, overlay = true } },
        { names = { "Crimson Scourge" }, shout = { "CRIMSON SCOURGE!", "DEATH AND DECAY!" }, triggers = { aura = true, overlay = true } },
    },
    MONK = {
        { names = { "Dance of Chi-Ji" }, shout = { "DANCE OF CHI-JI!", "SPIN!" }, triggers = { aura = true, overlay = true } },
        { names = { "Blackout Kick!" }, shout = { "BLACKOUT KICK!" }, triggers = { aura = true, overlay = true } },
        { names = { "Teachings of the Monastery" }, shout = { "TEACHINGS READY!" }, triggers = { aura = true, overlay = true }, stacks = 3 },
    },
    DEMONHUNTER = {
        { names = { "Demonic" }, shout = { "DEMONIC!", "METAMORPHOSIS!" }, triggers = { aura = true, overlay = true } },
        { names = { "Inner Demon" }, shout = { "INNER DEMON!" }, triggers = { aura = true, overlay = true } },
        { names = { "Chaos Theory" }, shout = { "CHAOS THEORY!" }, triggers = { aura = true, overlay = true } },
    },
    EVOKER = {
        { names = { "Essence Burst" }, shout = { "ESSENCE BURST!", "FREE ESSENCE!" }, triggers = { aura = true, overlay = true } },
        { names = { "Burnout" }, shout = { "BURNOUT!", "LIVING FLAME!" }, triggers = { aura = true, overlay = true } },
        { names = { "Snapfire" }, shout = { "SNAPFIRE!", "FIRE BREATH!" }, triggers = { aura = true, overlay = true } },
        { names = { "Leaping Flames" }, shout = { "LEAPING FLAMES!" }, triggers = { aura = true, overlay = true } },
    },
}

FC.procCatalog = PROC_CATALOG

local PROC_MEDIA = {
    overpower = "Interface\\AddOns\\ForeverCompanion\\Media\\ProcArt\\Overpower.tga",
    riposte = "Interface\\AddOns\\ForeverCompanion\\Media\\ProcArt\\Riposte.tga",
    maelstromweapon = "Interface\\AddOns\\ForeverCompanion\\Media\\ProcArt\\Maelstrom.tga",
    maelstrom = "Interface\\AddOns\\ForeverCompanion\\Media\\ProcArt\\Maelstrom.tga",
}

local function voiceSlug(value)
    value = tostring(value or "proc"):lower()
    value = value:gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    return value ~= "" and value or "proc"
end

local function safeCVarBool(name, defaultValue)
    if type(GetCVarBool) == "function" then
        local ok, value = pcall(GetCVarBool, name)
        if ok and type(value) == "boolean" then return value end
    end
    if type(GetCVar) == "function" then
        local ok, value = pcall(GetCVar, name)
        if ok and value ~= nil then
            value = tostring(value)
            if value == "0" then return false end
            if value == "1" then return true end
        end
    end
    return defaultValue
end

function FC:IsProcAudioAllowed(kind)
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.respectGameSound == false then return true, "override" end
    if safeCVarBool("Sound_EnableAllSound", true) == false then return false, "WoW sound is disabled" end
    if kind == "sfx" and safeCVarBool("Sound_EnableSFX", true) == false then return false, "WoW sound effects are disabled" end
    if kind == "voice" and safeCVarBool("Sound_EnableSFX", true) == false then return false, "WoW game sounds are disabled" end
    if kind == "voice" and safeCVarBool("Sound_EnableDialog", true) == false then return false, "WoW dialog sound is disabled" end
    return true, "enabled"
end

function FC:StopProcVoice()
    local state = self.state and self.state.procAlerts
    if state and state.voiceHandle and type(StopSound) == "function" then
        pcall(StopSound, state.voiceHandle)
        state.voiceHandle = nil
    end
    if C_VoiceChat and type(C_VoiceChat.StopSpeakingText) == "function" then pcall(C_VoiceChat.StopSpeakingText) end
    if C_CombatAudioAlert and type(C_CombatAudioAlert.StopSpeakingText) == "function" then pcall(C_CombatAudioAlert.StopSpeakingText) end
end

function FC:HandleProcSoundSettingsChanged()
    local voiceAllowed = self:IsProcAudioAllowed("voice")
    if not voiceAllowed then self:StopProcVoice() end
end

local fallbackClassColors = {
    WARRIOR = { 0.78, 0.61, 0.43 }, PALADIN = { 0.96, 0.55, 0.73 }, HUNTER = { 0.67, 0.83, 0.45 },
    ROGUE = { 1.00, 0.96, 0.41 }, PRIEST = { 1.00, 1.00, 1.00 }, DEATHKNIGHT = { 0.77, 0.12, 0.23 },
    SHAMAN = { 0.00, 0.44, 0.87 }, MAGE = { 0.25, 0.78, 0.92 }, WARLOCK = { 0.53, 0.53, 0.93 },
    MONK = { 0.00, 1.00, 0.60 }, DRUID = { 1.00, 0.49, 0.04 }, DEMONHUNTER = { 0.64, 0.19, 0.79 },
    EVOKER = { 0.20, 0.58, 0.50 },
}

local function classToken()
    if type(UnitClass) ~= "function" then return "UNKNOWN" end
    local ok, _, token = pcall(UnitClass, "player")
    if ok and type(token) == "string" then return token end
    return "UNKNOWN"
end

function FC:GetProcMediaPath(spellName)
    local def = self:GetProcDefinition(spellName, classToken())
    local primary = def and def.names and def.names[1] or spellName
    return PROC_MEDIA[norm(primary)] or PROC_MEDIA[norm(spellName)]
end

function FC:GetProcVoiceMediaPath(spellName)
    local def = self:GetProcDefinition(spellName, classToken())
    local primary = def and def.names and def.names[1] or spellName
    return "Interface\\AddOns\\ForeverCompanion\\Media\\Voice\\Vexa\\" .. voiceSlug(primary) .. ".ogg"
end

local function classColor(token)
    if RAID_CLASS_COLORS and RAID_CLASS_COLORS[token] then
        local c = RAID_CLASS_COLORS[token]
        return c.r or 1, c.g or 0.4, c.b or 0.8
    end
    local c = fallbackClassColors[token] or { 0.78, 0.35, 0.95 }
    return c[1], c[2], c[3]
end

local function safeSpellName(spellID)
    if spellID == nil then return nil end
    if C_Spell and type(C_Spell.GetSpellName) == "function" then
        local ok, value = pcall(C_Spell.GetSpellName, spellID)
        if ok and type(value) == "string" and value ~= "" then return value end
    end
    if type(GetSpellInfo) == "function" then
        local ok, value = pcall(GetSpellInfo, spellID)
        if ok and type(value) == "string" and value ~= "" then return value end
    end
    return nil
end

local function safeSpellTexture(spellID, spellName)
    if spellID and C_Spell and type(C_Spell.GetSpellTexture) == "function" then
        local ok, texture = pcall(C_Spell.GetSpellTexture, spellID)
        if ok and texture then return texture end
    end
    if type(GetSpellTexture) == "function" then
        local ok, texture = pcall(GetSpellTexture, spellID or spellName)
        if ok and texture then return texture end
    end
    if type(GetSpellInfo) == "function" then
        local ok, _, _, texture = pcall(GetSpellInfo, spellID or spellName)
        if ok and texture then return texture end
    end
    return nil
end

local function pickShout(def, spellName)
    if def and type(def.shout) == "table" and #def.shout > 0 then
        return def.shout[math.random(1, #def.shout)]
    end
    return tostring(spellName or "PROC"):upper() .. "!"
end

function FC:GetProcDefinition(spellName, token)
    token = token or classToken()
    local list = PROC_CATALOG[token] or {}
    local wanted = norm(spellName)
    for _, def in ipairs(list) do
        for _, alias in ipairs(def.names or {}) do
            local a = norm(alias)
            if wanted == a or (wanted ~= "" and a ~= "" and (wanted:find(a, 1, true) or a:find(wanted, 1, true))) then
                return def
            end
        end
    end
    return nil
end

function FC:GetProcCatalogText(token)
    token = token or classToken()
    local list = PROC_CATALOG[token] or {}
    if #list == 0 then
        return "No class-specific fallback list is needed here. Any client spell-activation overlay can still be announced automatically."
    end
    local lines = {}
    for _, def in ipairs(list) do
        lines[#lines + 1] = "• " .. tostring((def.names or {})[1] or "Proc")
    end
    return table.concat(lines, "\n")
end


local function ensureProcState(self)
    self.state = self.state or {}
    self.state.procAlerts = self.state.procAlerts or {}
    local p = self.state.procAlerts
    p.lastByKey = p.lastByKey or {}
    p.active = p.active or {}
    p.usable = p.usable or {}
    p.auras = p.auras or {}
    p.actions = p.actions or {}
    p.actionKeys = p.actionKeys or {}
    return p
end

function FC:ApplyProcAlertLayout()
    local frame = self.procAlertFrame
    if not frame or not self.db then return end
    local cfg = self.db.procAlerts or {}
    local x = tonumber(cfg.x) or 0
    local y = tonumber(cfg.y) or 140
    local iconSize = tonumber(cfg.iconSize) or 52
    local textSize = tonumber(cfg.textSize) or 28

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", x, y)
    local artSize = tonumber(cfg.artSize) or 300
    if frame.showingHDArt then
        frame:SetSize(artSize, math.max(100, artSize * 0.50))
        if frame.procArt then frame.procArt:SetSize(artSize, artSize * 0.50) end
    else
        frame:SetSize(430, math.max(78, iconSize + 24))
    end
    frame:SetScale(tonumber(cfg.scale) or 1.0)

    if frame.iconGlow then frame.iconGlow:SetSize(iconSize + 34, iconSize + 34) end
    if frame.icon then frame.icon:SetSize(iconSize, iconSize) end
    if frame.iconAnchor then frame.iconAnchor:SetSize(iconSize, iconSize) end
    if frame.text then
        pcall(frame.text.SetFont, frame.text, "Fonts\\MORPHEUS.TTF", textSize, "THICKOUTLINE")
    end
    if frame.sub then
        pcall(frame.sub.SetFont, frame.sub, "Fonts\\FRIZQT__.TTF", math.max(9, math.floor(textSize * 0.38)), "OUTLINE")
    end
end

function FC:SetProcAlertMoveMode(enabled)
    local frame = self:CreateProcAlertUI()
    if not frame then return end
    frame.moveMode = enabled and true or false
    frame:EnableMouse(frame.moveMode)
    if frame.moveMode then
        frame.startedAt = nil
        frame.showingHDArt = false
        if frame.procArt then frame.procArt:Hide() end
        if frame.iconAnchor then frame.iconAnchor:Show() end
        frame.text:Show()
        frame.sub:Show()
        self:ApplyProcAlertLayout()
        frame:SetAlpha(1)
        frame.text:SetText("MOVE COMBAT ALERT")
        frame.sub:SetText("Drag me, then click Lock alert")
        frame.icon:Hide()
        if frame.iconGlow then frame.iconGlow:Show() end
        if frame.moveHint then frame.moveHint:Show() end
        frame:Show()
        self:Debug("Combat alert unlocked. Drag it where you want, then use /fc proc lock or the Combat Calls settings button.")
    else
        if frame.moveHint then frame.moveHint:Hide() end
        frame:Hide()
        self:Debug("Combat alert position locked.")
    end
end

function FC:ResetProcAlertPosition()
    if not self.db then return end
    self.db.procAlerts = self.db.procAlerts or {}
    self.db.procAlerts.x = 0
    self.db.procAlerts.y = 140
    self.db.procAlerts.scale = 1.0
    self.db.procAlerts.iconSize = 52
    self.db.procAlerts.textSize = 28
    self:ApplyProcAlertLayout()
    self:Debug("Combat alert position and visual size reset.")
end

function FC:CreateProcAlertUI()
    if self.procAlertFrame then return self.procAlertFrame end

    local frame = CreateFrame("Frame", "ForeverCompanionProcAlert", UIParent)
    frame:SetSize(430, 90)
    frame:SetFrameStrata("HIGH")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(false)
    frame:RegisterForDrag("LeftButton")
    frame:Hide()

    frame:SetScript("OnDragStart", function(f)
        if f.moveMode then f:StartMoving() end
    end)
    frame:SetScript("OnDragStop", function(f)
        f:StopMovingOrSizing()
        if not FC.db then return end
        local cx, cy = f:GetCenter()
        local ux, uy = UIParent:GetCenter()
        if cx and cy and ux and uy then
            FC.db.procAlerts.x = math.floor((cx - ux) + 0.5)
            FC.db.procAlerts.y = math.floor((cy - uy) + 0.5)
        end
        FC:ApplyProcAlertLayout()
    end)

    -- Borderless by design: just a soft class-colored glow, spell icon and text.
    local iconAnchor = CreateFrame("Frame", nil, frame)
    frame.iconAnchor = iconAnchor
    iconAnchor:SetPoint("LEFT", frame, "LEFT", 18, 0)
    iconAnchor:SetSize(52, 52)

    local glow = iconAnchor:CreateTexture(nil, "BACKGROUND")
    frame.iconGlow = glow
    glow:SetPoint("CENTER", iconAnchor, "CENTER", 0, 0)
    glow:SetSize(86, 86)
    glow:SetTexture("Interface\\Cooldown\\star4")
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0.48)

    local icon = iconAnchor:CreateTexture(nil, "ARTWORK")
    frame.icon = icon
    icon:SetPoint("CENTER", iconAnchor, "CENTER", 0, 0)
    icon:SetSize(52, 52)
    if icon.SetTexCoord then icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end

    local procArt = frame:CreateTexture(nil, "ARTWORK")
    frame.procArt = procArt
    procArt:SetPoint("CENTER", frame, "CENTER", 0, 0)
    procArt:SetSize(300, 150)
    procArt:SetBlendMode("BLEND")
    procArt:Hide()

    local title = frame:CreateFontString(nil, "OVERLAY")
    frame.text = title
    title:SetPoint("LEFT", iconAnchor, "RIGHT", 16, 9)
    title:SetPoint("RIGHT", frame, "RIGHT", -14, 9)
    title:SetJustifyH("LEFT")
    title:SetJustifyV("MIDDLE")
    pcall(title.SetFont, title, "Fonts\\MORPHEUS.TTF", 28, "THICKOUTLINE")
    title:SetShadowOffset(2, -2)
    title:SetShadowColor(0, 0, 0, 1)

    local sub = frame:CreateFontString(nil, "OVERLAY")
    frame.sub = sub
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 1, -2)
    sub:SetPoint("RIGHT", frame, "RIGHT", -14, 0)
    sub:SetJustifyH("LEFT")
    pcall(sub.SetFont, sub, "Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    sub:SetTextColor(0.88, 0.88, 0.96)

    local moveHint = frame:CreateTexture(nil, "BACKGROUND")
    frame.moveHint = moveHint
    moveHint:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    moveHint:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    moveHint:SetTexture("Interface\\Buttons\\WHITE8X8")
    moveHint:SetVertexColor(0.35, 0.12, 0.48, 0.18)
    moveHint:Hide()

    frame:SetScript("OnUpdate", function(self, elapsed)
        if self.moveMode or not self.startedAt then return end
        local now = GetTime()
        local cfg = FC.db and FC.db.procAlerts or {}
        local duration = tonumber(cfg.duration) or 1.45
        local t = now - self.startedAt
        if t >= duration then
            self.startedAt = nil
            self:Hide()
            return
        end

        local alpha = 1
        if t < 0.08 then
            alpha = math.max(0.1, t / 0.08)
        elseif t > duration - 0.32 then
            alpha = math.max(0, (duration - t) / 0.32)
        end
        self:SetAlpha(alpha)

        local baseScale = tonumber(cfg.scale) or 1.0
        local pop = 1.0
        if t < 0.10 then
            pop = 0.90 + (t / 0.10) * 0.16
        elseif t < 0.20 then
            pop = 1.06 - ((t - 0.10) / 0.10) * 0.06
        end
        self:SetScale(baseScale * pop)
    end)

    self.procAlertFrame = frame
    self:ApplyProcAlertLayout()
    return frame
end

function FC:PlayProcSound()
    local allowed = self:IsProcAudioAllowed("sfx")
    if not allowed then return false end
    if type(PlaySound) == "function" then
        local ids = {}
        if SOUNDKIT then
            if SOUNDKIT.RAID_WARNING then ids[#ids + 1] = SOUNDKIT.RAID_WARNING end
            if SOUNDKIT.READY_CHECK then ids[#ids + 1] = SOUNDKIT.READY_CHECK end
            if SOUNDKIT.UI_RAID_BOSS_WHISPER_WARNING then ids[#ids + 1] = SOUNDKIT.UI_RAID_BOSS_WHISPER_WARNING end
        end
        ids[#ids + 1] = 8959
        ids[#ids + 1] = 8960
        for _, id in ipairs(ids) do
            local ok, played = pcall(PlaySound, id, "SFX")
            if ok and played ~= false then return true end
        end
    end

    if type(PlaySoundFile) == "function" then
        local files = {
            "Sound\\Interface\\RaidWarning.ogg",
            "Sound\\Interface\\ReadyCheck.ogg",
            "Sound\\Interface\\AlarmClockWarning3.ogg",
        }
        for _, path in ipairs(files) do
            local ok, played = pcall(PlaySoundFile, path, "SFX")
            if ok and played ~= false then return true end
        end
    end
    return false
end


local FEMALE_VOICE_HINTS = {
    "female", "zira", "hazel", "susan", "heera", "samantha", "victoria", "aria", "jenny", "eva", "karen", "moira", "tessa", "veena", "fiona"
}

function FC:GetProcTTSVoices()
    if not C_VoiceChat or type(C_VoiceChat.GetTtsVoices) ~= "function" then return {} end
    local ok, voices = pcall(C_VoiceChat.GetTtsVoices)
    if not ok or type(voices) ~= "table" then return {} end
    return voices
end

function FC:GetProcVoice()
    local voices = self:GetProcTTSVoices()
    if #voices == 0 then return nil, nil, voices end
    local cfg = self.db and self.db.procAlerts or {}
    local wanted = tonumber(cfg.voiceID)
    if wanted then
        for _, voice in ipairs(voices) do
            if tonumber(voice.voiceID) == wanted then return wanted, voice.name, voices end
        end
    end
    -- Prefer a likely feminine system voice for Vexa. If the OS does not expose
    -- gender in the voice name, use the player's configured TTS voice, then first available.
    for _, voice in ipairs(voices) do
        local n = tostring(voice.name or ""):lower()
        for _, hint in ipairs(FEMALE_VOICE_HINTS) do
            if n:find(hint, 1, true) then
                cfg.voiceID = tonumber(voice.voiceID)
                return cfg.voiceID, voice.name, voices
            end
        end
    end
    if C_TTSSettings and type(C_TTSSettings.GetVoiceOptionID) == "function" then
        local ok, current = pcall(C_TTSSettings.GetVoiceOptionID)
        if ok and current then
            for _, voice in ipairs(voices) do
                if tonumber(voice.voiceID) == tonumber(current) then
                    cfg.voiceID = tonumber(current)
                    return cfg.voiceID, voice.name, voices
                end
            end
        end
    end
    cfg.voiceID = tonumber(voices[1].voiceID)
    return cfg.voiceID, voices[1].name, voices
end

function FC:CycleProcVoice(direction)
    local id, _, voices = self:GetProcVoice()
    if #voices == 0 then
        self:Debug("No client text-to-speech voices are installed/exposed on this WoW client.")
        return false
    end
    local current = 1
    for i, voice in ipairs(voices) do if tonumber(voice.voiceID) == tonumber(id) then current = i break end end
    direction = tonumber(direction) or 1
    current = ((current - 1 + direction) % #voices) + 1
    local voice = voices[current]
    self.db.procAlerts.voiceID = tonumber(voice.voiceID)
    self:Debug("Combat voice: " .. tostring(voice.name or voice.voiceID))
    return true
end

function FC:PlayProcVoiceMedia(spellName)
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.customVoicePack ~= true then return false, "custom voice pack disabled" end
    local allowed, reason = self:IsProcAudioAllowed("voice")
    if not allowed then return false, reason end
    if type(PlaySoundFile) ~= "function" then return false, "PlaySoundFile unavailable" end

    local candidates
    if type(self.GetVexaProcVoiceCandidatePaths) == "function" then
        candidates = self:GetVexaProcVoiceCandidatePaths(spellName)
    else
        candidates = { self:GetProcVoiceMediaPath(spellName) }
    end

    for _, path in ipairs(candidates or {}) do
        local ok, played, handle = pcall(PlaySoundFile, path, "Dialog")
        if ok and played ~= false and played ~= nil then
            local pstate = ensureProcState(self)
            pstate.voiceHandle = handle
            return true, path
        end
    end
    return false, "custom clip missing"
end

function FC:SpeakProcCallout(text, spellName)
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.voiceEnabled == false then return false, "disabled" end
    local allowed, reason = self:IsProcAudioAllowed("voice")
    if not allowed then return false, reason end
    text = tostring(text or ""):gsub("—", " "):gsub("%s+", " ")
    if text == "" then return false, "empty" end

    local mediaOK, mediaName = self:PlayProcVoiceMedia(spellName or text:gsub("!", ""))
    if mediaOK then return true, mediaName end
    if cfg.customVoicePack == true and cfg.ttsFallback == false then
        return false, mediaName or "custom clip missing; TTS fallback disabled"
    end

    local voiceID, voiceName = self:GetProcVoice()
    if voiceID and C_VoiceChat and type(C_VoiceChat.SpeakText) == "function" then
        local rate = tonumber(cfg.voiceRate) or 0
        local volume = tonumber(cfg.voiceVolume) or 100
        local ok = pcall(C_VoiceChat.SpeakText, voiceID, text, rate, volume, false)
        if ok then return true, voiceName or tostring(voiceID) end
    end

    -- Newer clients expose a dedicated combat narrator. It is a useful fallback,
    -- but its voice is controlled by the client accessibility settings.
    if C_CombatAudioAlert and type(C_CombatAudioAlert.SpeakText) == "function" then
        local ok = pcall(C_CombatAudioAlert.SpeakText, text, 0, false)
        if ok then return true, "combat narrator" end
    end
    return false, "TTS API unavailable"
end

function FC:TestProcVoice()
    local ok, voice = self:SpeakProcCallout("Overpower!", "Overpower")
    if ok then self:Debug("Spoken combat callout test sent to " .. tostring(voice) .. ".")
    else self:Debug("Spoken combat callout unavailable: " .. tostring(voice) .. ".") end
    return ok
end

function FC:ShowProcAlert(spellName, shout, spellID, source)
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.enabled == false then return false end
    if cfg.onlyInCombat and not self.state.inCombat then return false end

    spellName = tostring(spellName or "Proc")
    shout = tostring(shout or spellName:upper() .. "!")
    local key = norm(spellName)
    local now = GetTime()
    local pstate = ensureProcState(self)
    local minCooldown = tonumber(cfg.cooldown) or 1.25
    if now - (pstate.lastByKey[key] or -999) < minCooldown then return false end
    if now - (pstate.lastGlobal or -999) < 0.18 then return false end
    pstate.lastByKey[key] = now
    pstate.lastGlobal = now

    if cfg.screenEffect ~= false then
        local ok, frame = pcall(self.CreateProcAlertUI, self)
        if ok and frame then
            local token = classToken()
            local r, g, b = classColor(token)
            local mediaPath = cfg.hdArt == true and self:GetProcMediaPath(spellName) or nil
            frame.showingHDArt = mediaPath and true or false
            if frame.showingHDArt then
                frame.procArt:SetTexture(mediaPath)
                frame.procArt:Show()
                frame.iconAnchor:Hide()
                frame.text:Hide()
                frame.sub:Hide()
            else
                frame.procArt:Hide()
                frame.iconAnchor:Show()
                frame.text:Show()
                frame.sub:Show()
            end
            self:ApplyProcAlertLayout()
            frame.text:SetText(shout)
            frame.text:SetTextColor(math.min(1, r + 0.18), math.min(1, g + 0.18), math.min(1, b + 0.18))
            local showSource = cfg.showSource == true
            if showSource then
                frame.sub:SetText(spellName .. (source and ("  •  " .. tostring(source)) or ""))
            elseif norm(shout) ~= norm(spellName) then
                frame.sub:SetText(spellName)
            else
                frame.sub:SetText("")
            end
            if frame.iconGlow and frame.iconGlow.SetVertexColor then frame.iconGlow:SetVertexColor(r, g, b, 0.90) end
            local texture = safeSpellTexture(spellID, spellName)
            if texture then
                frame.icon:SetTexture(texture)
                frame.icon:Show()
            else
                frame.icon:Hide()
            end
            frame.startedAt = now
            frame.moveMode = false
            frame:EnableMouse(false)
            if frame.moveHint then frame.moveHint:Hide() end
            frame:SetAlpha(1)
            frame:Show()
        else
            self.state.lastProcUIError = tostring(frame)
        end
    end

    if cfg.vexaShout ~= false and type(self.Say) == "function" then
        self:Say(shout, "angry", 100, true)
    end

    local soundPlayed = true
    if cfg.sound ~= false then soundPlayed = self:PlayProcSound() end

    local voicePlayed, voiceName = false, nil
    if cfg.voiceEnabled ~= false then voicePlayed, voiceName = self:SpeakProcCallout(spellName .. "!", spellName) end

    self.state.lastProcAlert = {
        spell = spellName,
        shout = shout,
        source = source,
        at = now,
        class = classToken(),
        soundPlayed = soundPlayed,
        voicePlayed = voicePlayed,
        voiceName = voiceName,
    }
    return true
end

function FC:TriggerProcBySpell(spellID, source)
    local spellName = safeSpellName(spellID)
    if not spellName then return false end
    local token = classToken()
    local def = self:GetProcDefinition(spellName, token)
    local cfg = self.db and self.db.procAlerts or {}
    if not def and cfg.anyOverlay == false then return false end
    return self:ShowProcAlert(spellName, pickShout(def, spellName), spellID, source or "proc")
end

function FC:HandleProcOverlay(showing, spellID)
    if showing then
        self:TriggerProcBySpell(spellID, "overlay")
    else
        local spellName = safeSpellName(spellID)
        if spellName and self.state.procAlerts then self.state.procAlerts.active[norm(spellName)] = nil end
    end
end

local function usableSpell(name)
    if type(IsUsableSpell) == "function" then
        local ok, usable, noMana = pcall(IsUsableSpell, name)
        if ok then
            if type(usable) == "boolean" then return usable and not noMana end
            if type(usable) == "number" then return usable == 1 and not noMana end
        end
    end
    if C_Spell and type(C_Spell.IsSpellUsable) == "function" then
        local ok, result = pcall(C_Spell.IsSpellUsable, name)
        if ok and type(result) == "table" then
            return result.isUsable and not result.insufficientPower
        elseif ok and type(result) == "boolean" then
            return result
        end
    end
    return nil
end

local function actionUsable(slot)
    if type(IsUsableAction) ~= "function" then return nil end
    local ok, usable, noMana = pcall(IsUsableAction, slot)
    if not ok then return nil end
    if type(usable) == "boolean" then return usable and not noMana end
    if type(usable) == "number" then return usable == 1 and not noMana end
    return nil
end

local function actionSpell(slot)
    if type(GetActionInfo) ~= "function" then return nil, nil end
    local ok, actionType, id = pcall(GetActionInfo, slot)
    if not ok or not actionType then return nil, nil end
    if actionType == "spell" then
        return safeSpellName(id), id
    elseif actionType == "macro" and type(GetMacroSpell) == "function" then
        local mok, a, b = pcall(GetMacroSpell, id)
        if mok then
            local spellID = type(a) == "number" and a or (type(b) == "number" and b or nil)
            local spellName = type(a) == "string" and a or (spellID and safeSpellName(spellID) or nil)
            return spellName, spellID
        end
    end
    return nil, nil
end

function FC:RebuildProcActionMap()
    local pstate = ensureProcState(self)
    pstate.actions = {}
    pstate.actionKeys = {}
    local token = classToken()
    local list = PROC_CATALOG[token] or {}
    if type(GetActionInfo) ~= "function" then return 0 end

    local maxSlots = 180
    for slot = 1, maxSlots do
        local spellName, spellID = actionSpell(slot)
        if spellName then
            local def = self:GetProcDefinition(spellName, token)
            if def and def.triggers and def.triggers.usable then
                local key = norm((def.names or {})[1] or spellName)
                pstate.actions[#pstate.actions + 1] = { slot = slot, name = spellName, spellID = spellID, def = def, key = key }
                pstate.actionKeys[key] = true
            end
        end
    end
    return #pstate.actions
end

function FC:CheckActionBarProcs()
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.enabled == false or cfg.fallbackDetection == false then return end
    local pstate = ensureProcState(self)
    if not pstate.actions or #pstate.actions == 0 then self:RebuildProcActionMap() end

    for _, action in ipairs(pstate.actions or {}) do
        local isUsable = actionUsable(action.slot)
        if isUsable ~= nil then
            local previous = pstate.usable[action.key]
            if previous == nil then
                pstate.usable[action.key] = isUsable and true or false
                if isUsable and self.state.inCombat then
                    self:ShowProcAlert(action.name, pickShout(action.def, action.name), action.spellID, "action bar")
                end
            else
                if isUsable and not previous then
                    self:ShowProcAlert(action.name, pickShout(action.def, action.name), action.spellID, "action bar")
                end
                pstate.usable[action.key] = isUsable and true or false
            end
        end
    end
end

local function auraStacks(name)
    if AuraUtil and type(AuraUtil.FindAuraByName) == "function" then
        local ok, a, b, c = pcall(AuraUtil.FindAuraByName, name, "player", "HELPFUL")
        if ok and a then
            if type(a) == "table" then
                local count = a.applications or a.charges or a.count or 1
                if FC.ReadableNumber then return FC:ReadableNumber(count) or 1 end
                return tonumber(count) or 1
            elseif type(a) == "string" then
                local count = c
                if FC.ReadableNumber then return FC:ReadableNumber(count) or 1 end
                return tonumber(count) or 1
            end
        end
    end

    if type(UnitBuff) == "function" then
        for i = 1, 80 do
            local ok, auraName, _, count = pcall(UnitBuff, "player", i)
            if not ok or not auraName then break end
            if norm(auraName) == norm(name) then
                if FC.ReadableNumber then return FC:ReadableNumber(count) or 1 end
                return tonumber(count) or 1
            end
        end
    end
    return nil
end

function FC:CheckFallbackProcs()
    local cfg = self.db and self.db.procAlerts or {}
    if cfg.enabled == false or cfg.fallbackDetection == false then return end

    local pstate = ensureProcState(self)
    local token = classToken()
    local list = PROC_CATALOG[token] or {}

    self:CheckActionBarProcs()

    for _, def in ipairs(list) do
        local primary = (def.names or {})[1]
        local key = norm(primary)

        -- Name-based usability remains a secondary fallback for abilities that are
        -- not currently on an action bar.
        if def.triggers and def.triggers.usable and not (pstate.actionKeys and pstate.actionKeys[key]) then
            local isUsable = usableSpell(primary)
            local previous = pstate.usable[key]
            if previous == nil then
                pstate.usable[key] = isUsable and true or false
                if isUsable and self.state.inCombat then self:ShowProcAlert(primary, pickShout(def, primary), nil, "usable") end
            else
                if isUsable and not previous then self:ShowProcAlert(primary, pickShout(def, primary), nil, "usable") end
                pstate.usable[key] = isUsable and true or false
            end
        end

        if def.triggers and def.triggers.aura then
            local foundStacks = nil
            for _, alias in ipairs(def.names or {}) do
                foundStacks = auraStacks(alias)
                if foundStacks then break end
            end
            local threshold = tonumber(def.stacks) or 1
            local active = foundStacks and foundStacks >= threshold
            local previous = pstate.auras[key]
            if previous == nil then
                pstate.auras[key] = active and true or false
                if active and self.state.inCombat then
                    self:ShowProcAlert(primary, pickShout(def, primary), nil, foundStacks and foundStacks > 1 and (tostring(foundStacks) .. " stacks") or "aura")
                end
            else
                if active and not previous then
                    self:ShowProcAlert(primary, pickShout(def, primary), nil, foundStacks and foundStacks > 1 and (tostring(foundStacks) .. " stacks") or "aura")
                end
                pstate.auras[key] = active and true or false
            end
        end
    end
end

local function missTypeFromCombatLog(subevent, ...)
    if subevent == "SWING_MISSED" then
        return select(1, ...)
    elseif subevent == "RANGE_MISSED" or subevent == "SPELL_MISSED" or subevent == "SPELL_PERIODIC_MISSED" then
        return select(4, ...)
    end
    return nil
end

function FC:HandleProcCombatLog(...)
    local values = { ... }
    if #values == 0 and type(CombatLogGetCurrentEventInfo) == "function" then
        local ok, a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t = pcall(CombatLogGetCurrentEventInfo)
        if ok then values = { a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t } end
    end
    if #values < 11 then return end

    local subevent = values[2]
    local sourceGUID = values[4]
    local destGUID = values[8]
    local playerGUID = type(UnitGUID) == "function" and UnitGUID("player") or nil
    if not playerGUID or not subevent then return end

    local extra = {}
    for i = 12, #values do extra[#extra + 1] = values[i] end

    -- Successful player interrupts are a high-value Vexa voice event even when they
    -- are not a class proc. Combat-log detection is reliable across client UI variants.
    if subevent == "SPELL_INTERRUPT" and sourceGUID == playerGUID then
        if type(self.PlayVexaVoiceCue) == "function" then
            self:PlayVexaVoiceCue("interrupt", { force = true, cooldown = 1.5, interruptCurrent = true })
        end
        return
    end

    local missType = missTypeFromCombatLog(subevent, unpack(extra))
    if not missType then return end
    missType = tostring(missType):upper()

    local token = classToken()
    if token == "WARRIOR" then
        if sourceGUID == playerGUID and missType == "DODGE" then
            local def = self:GetProcDefinition("Overpower", token)
            self:ShowProcAlert("Overpower", pickShout(def, "Overpower"), nil, "enemy dodged")
        elseif destGUID == playerGUID and (missType == "DODGE" or missType == "PARRY" or missType == "BLOCK") then
            local def = self:GetProcDefinition("Revenge", token)
            self:ShowProcAlert("Revenge", pickShout(def, "Revenge"), nil, "reactive")
        end
    elseif token == "ROGUE" then
        if destGUID == playerGUID and missType == "PARRY" then
            local def = self:GetProcDefinition("Riposte", token)
            self:ShowProcAlert("Riposte", pickShout(def, "Riposte"), nil, "parry")
        end
    end
end

function FC:ProcTick(elapsed)
    if not self.db or not self.db.procAlerts or self.db.procAlerts.enabled == false then return end
    self.state.procTick = (self.state.procTick or 0) + (elapsed or 0)
    local interval = tonumber(self.db.procAlerts.pollInterval) or 0.20
    if self.state.procTick < interval then return end
    self.state.procTick = 0
    self:CheckFallbackProcs()
end

function FC:InitializeProcAlerts()
    local pstate = ensureProcState(self)
    pstate.usable = {}
    pstate.auras = {}
    self:RebuildProcActionMap()
    local ok, result = pcall(self.CreateProcAlertUI, self)
    if not ok then
        self.state.lastProcUIError = tostring(result)
    elseif self.ApplyProcAlertLayout then
        self:ApplyProcAlertLayout()
    end
    return true
end

function FC:ProcDoctor()
    local pstate = self.state.procAlerts or {}
    local token = classToken()
    self:Debug("Combat Calls doctor:")
    self:Debug("enabled=" .. tostring(self.db and self.db.procAlerts and self.db.procAlerts.enabled ~= false) .. " class=" .. tostring(token))
    self:Debug("overlayEvent=" .. tostring(self.state.eventSupport and self.state.eventSupport.SPELL_ACTIVATION_OVERLAY_GLOW_SHOW))
    self:Debug("actionUsableAPI=" .. tostring(type(IsUsableAction) == "function") .. " actionInfoAPI=" .. tostring(type(GetActionInfo) == "function"))
    self:Debug("combatLogAPI=" .. tostring(type(CombatLogGetCurrentEventInfo) == "function" or (self.state.eventSupport and self.state.eventSupport.COMBAT_LOG_EVENT_UNFILTERED)))
    self:Debug("mappedReactiveActions=" .. tostring(#(pstate.actions or {})))
    for _, action in ipairs(pstate.actions or {}) do
        self:Debug("  slot " .. tostring(action.slot) .. ": " .. tostring(action.name) .. " usable=" .. tostring(actionUsable(action.slot)))
    end
    self:Debug("procUI=" .. tostring(self.procAlertFrame ~= nil) .. (self.state.lastProcUIError and (" error=" .. tostring(self.state.lastProcUIError)) or ""))
    local voiceID, voiceName, voices = self:GetProcVoice()
    local cfg = self.db and self.db.procAlerts or {}
    local voiceAllowed, voiceReason = self:IsProcAudioAllowed("voice")
    local sfxAllowed, sfxReason = self:IsProcAudioAllowed("sfx")
    self:Debug("ttsAPI=" .. tostring(C_VoiceChat and type(C_VoiceChat.SpeakText) == "function") .. " voices=" .. tostring(#(voices or {})) .. " selected=" .. tostring(voiceName or voiceID or "none"))
    self:Debug("audio: respectGame=" .. tostring(cfg.respectGameSound ~= false) .. " voiceAllowed=" .. tostring(voiceAllowed) .. " (" .. tostring(voiceReason) .. ") sfxAllowed=" .. tostring(sfxAllowed) .. " (" .. tostring(sfxReason) .. ")")
    self:Debug("customVoicePack=" .. tostring(cfg.customVoicePack == true) .. " hdArt=" .. tostring(cfg.hdArt == true) .. " artSize=" .. tostring(cfg.artSize or 300))
    self:Debug("alertPos=" .. tostring(cfg.x or 0) .. "," .. tostring(cfg.y or 140) .. " scale=" .. tostring(cfg.scale or 1))
    local last = self.state.lastProcAlert
    if last then self:Debug("last=" .. tostring(last.spell) .. " source=" .. tostring(last.source) .. " sound=" .. tostring(last.soundPlayed) .. " voice=" .. tostring(last.voicePlayed) .. " via=" .. tostring(last.voiceName)) end
end

function FC:TestProcAlert(spellName)
    local token = classToken()
    local def = spellName and self:GetProcDefinition(spellName, token) or nil
    if not def then
        def = (PROC_CATALOG[token] or {})[1]
        spellName = spellName or (def and def.names and def.names[1]) or "Proc Ready"
    end
    self:ShowProcAlert(spellName, pickShout(def, spellName), nil, "test")
end
