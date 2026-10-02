local FC = _G.ForeverCompanion
local eventFrame = CreateFrame("Frame")
FC.eventFrame = eventFrame

local registeredEvents = {
    "ADDON_LOADED",
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LOGOUT",
    "PLAYER_CAMPING",
    "PLAYER_XP_UPDATE",
    "PLAYER_LEVEL_UP",
    "PLAYER_DEAD",
    "PLAYER_ALIVE",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "ZONE_CHANGED_NEW_AREA",
    "QUEST_TURNED_IN",
    "QUEST_LOG_UPDATE",
    "BAG_UPDATE_DELAYED",
    "PLAYER_EQUIPMENT_CHANGED",
    "UPDATE_INVENTORY_DURABILITY",
    "PLAYER_MONEY",
    "PLAYER_STARTED_MOVING",
    "PLAYER_STOPPED_MOVING",
    "PLAYER_TARGET_CHANGED",
    "UNIT_AURA",
    "UNIT_PET",
    "UNIT_POWER_UPDATE",
    "UNIT_POWER_FREQUENT",
    "UNIT_HEALTH",
    "UNIT_HEALTH_FREQUENT",
    "PLAYER_CONTROL_LOST",
    "PLAYER_CONTROL_GAINED",
    "PLAYER_FLAGS_CHANGED",
    "PLAYER_UPDATE_RESTING",
    "PLAYER_GUILD_UPDATE",
    "GROUP_ROSTER_UPDATE",
    "PARTY_INVITE_REQUEST",
    "READY_CHECK",
    "READY_CHECK_CONFIRM",
    "BOSS_KILL",
    "ENCOUNTER_START",
    "ENCOUNTER_END",
    "UPDATE_INSTANCE_INFO",
    "EJ_LOOT_DATA_RECIEVED",
    "GET_ITEM_INFO_RECEIVED",
    "CHAT_MSG_LOOT",
    "COMBAT_TEXT_UPDATE",
    "PLAYER_PVP_KILLS_CHANGED",
    "UPDATE_BATTLEFIELD_STATUS",
    "BANKFRAME_OPENED",
    "BANKFRAME_CLOSED",
    "MAIL_SHOW",
    "MAIL_CLOSED",
    "MAIL_INBOX_UPDATE",
    "MERCHANT_SHOW",
    "MERCHANT_CLOSED",
    "AUCTION_HOUSE_SHOW",
    "AUCTION_HOUSE_CLOSED",
    "TRADE_SHOW",
    "BARBER_SHOP_OPEN",
    "UI_ERROR_MESSAGE",
    "DELETE_ITEM_CONFIRM",
    "CONFIRM_TALENT_WIPE",
    "PLAYER_TALENT_UPDATE",
    "CHAT_MSG_SKILL",
    "UNIT_SPELLCAST_SENT",
    "UNIT_SPELLCAST_FAILED",
    "UNIT_SPELLCAST_FAILED_QUIET",
    "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW",
    "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE",
    "SPELLS_CHANGED",
    "ACTIONBAR_UPDATE_USABLE",
    "ACTIONBAR_SLOT_CHANGED",
    "ACTIONBAR_PAGE_CHANGED",
    "UPDATE_SHAPESHIFT_FORM",
    "COMBAT_LOG_EVENT_UNFILTERED",
    "CINEMATIC_START",
    "CINEMATIC_STOP",
    "LOADING_SCREEN_ENABLED",
    "LOADING_SCREEN_DISABLED",
    "CVAR_UPDATE",
}

FC.state.eventSupport = FC.state.eventSupport or {}
for _, eventName in ipairs(registeredEvents) do
    local ok = pcall(eventFrame.RegisterEvent, eventFrame, eventName)
    FC.state.eventSupport[eventName] = ok and true or false
end

local lastXP = 0
local questTimerPending = false

local function after(seconds, callback)
    if C_Timer and type(C_Timer.After) == "function" then C_Timer.After(seconds, callback) else callback() end
end

local function startup()
    FC:InitDB()
    if not FC:ValidateModules() then return false end

    local ok = FC:Call("DetectCapabilities")
    if not ok then return false end
    FC:Call("InitializeContext")
    FC:Call("InitializeProcAlerts")
    FC:Call("RefreshIntegrations")
    FC:Call("InitializeGoldTracking")
    FC:Call("BeginSessionTracking")

    ok = FC:Call("CreateUI")
    if not ok then return false end

    -- Launcher and native registration are non-fatal and independent of the custom
    -- settings window. A settings-page failure must never remove the minimap button.
    local minimapOK = FC:Call("CreateMinimapButton")
    if not minimapOK then
        FC:Debug("Minimap launcher could not be created; /fc settings remains available.")
    end
    FC:Call("RegisterNativeSettings")

    -- The full control center is built lazily on first open. This avoids a UI
    -- compatibility problem aborting addon startup.
    if type(math.randomseed) == "function" and type(time) == "function" then math.randomseed(time()) end
    FC.state.ready = true
    FC:Debug("Loaded v" .. tostring(FC.version) .. ". /fc doctor runs a full health check.")
    return true
end

local function coreEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Forever can report UnitName as unavailable during ADDON_LOADED. Resolve the
        -- real character before any character-specific memory or session logic runs.
        FC:Call("ActivateCharacterMemory")
        FC:Call("BeginSessionTracking")
        FC:Call("RebuildProcActionMap")
        local rawXP = type(UnitXP) == "function" and UnitXP("player") or nil
        lastXP = FC:ReadableNumber(rawXP) or 0
        FC:Call("TouchZone")
        FC:Call("HandleContextEvent", event, ...)
        if FC:IsDungeonContext() and not FC.state.dungeon then
            local snap = FC:GetCurrentDungeonSnapshot()
            FC:OnDungeonEnter(snap and snap.name or nil)
        end

        after(2, function()
            if not FC.state.ready then return end
            if not FC.db.onboarded then
                FC:Call("RunCatchup", false)
            else
                FC:Call("ScanQuests", true)
                local previous = FC.state.characterSwitchFrom
                if previous and previous.name then
                    local profile = FC:RefreshLiveProfile() or {}
                    FC:QueueTopic("charswitch", {
                        name = profile.name or "hero",
                        class = profile.class or "adventurer",
                        previousName = previous.name,
                        previousClass = previous.class or "adventurer",
                    }, 100, 0, true)
                    FC:MaybeQueueCrossCharacterMemory(previous)
                    FC.state.characterSwitchFrom = nil
                else
                    if FC.QueueLoginArrival then
                        FC:QueueLoginArrival()
                    else
                        FC:QueueTopic("login", {}, 70, 0, true)
                    end
                end
            end
            FC:MaybeQueuePreviousSessionSummary()
            FC:CheckRestedXP()
        end)

        -- Quest data can arrive a few seconds after PLAYER_ENTERING_WORLD on modern/Forever clients.
        -- Re-sample quietly so an early empty cache cannot become a permanent false zero.
        after(5, function()
            if FC.state.ready then FC:Call("ScanQuests", true) end
        end)
        after(10, function()
            if FC.state.ready then FC:Call("ScanQuests", true) end
        end)

    elseif event == "PLAYER_XP_UPDATE" then
        local rawXP = type(UnitXP) == "function" and UnitXP("player") or nil
        local currentXP = FC:ReadableNumber(rawXP)
        if currentXP ~= nil then
            local delta = FC:SafeSubtract(currentXP, lastXP or 0)
            if delta and delta > 0 then FC:AddXP(delta, FC.state.inCombat and "combat" or "other") end
            lastXP = currentXP
        end
        FC:UpdateMiniStats()
        FC:CheckXPIntelligence()

    elseif event == "PLAYER_LEVEL_UP" then
        local level = ...
        FC:RememberLevel(level)
        FC:SetMood("impressed", 6, 180)
        FC:QueueTopic("level", { level = level }, 100, 0, true)
        lastXP = 0

    elseif event == "PLAYER_DEAD" then
        FC.state.wasDead = true
        FC:OnDeath()
        FC:SetMood("concerned", -5, 180)
        if FC.AddJournal then FC:AddJournal("death", "Died in " .. tostring(FC.state.zone or "an unknown place") .. ".") end

    elseif event == "PLAYER_ALIVE" then
        if FC.state.wasDead then
            FC.state.wasDead = false
            FC:QueueTopic("revive", {}, 35, 60)
        end

    elseif event == "PLAYER_REGEN_DISABLED" then
        FC:CombatStart()
        FC:UpdateContextMode()

    elseif event == "PLAYER_REGEN_ENABLED" then
        FC:CombatEnd()
        FC:UpdateContextMode()

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        FC:OnZoneChanged()
        FC:TouchAction()
        FC:HandleContextEvent(event, ...)
        if FC.AddJournal then FC:AddJournal("travel", "Entered " .. tostring(FC.state.zone or "a new zone") .. ".") end

    elseif event == "QUEST_TURNED_IN" then
        local questID, xp = ...
        FC:RecordQuestTurnin(questID, xp)
        FC:SetMood("impressed", 1, 90)
        FC:TouchAction()
        after(0.4, function() if FC.state.ready then FC:ScanQuests(false) end end)

    elseif event == "QUEST_LOG_UPDATE" then
        if not questTimerPending then
            questTimerPending = true
            after(0.6, function()
                questTimerPending = false
                if FC.state.ready then FC:ScanQuests(false) end
            end)
        end

    elseif event == "PLAYER_STARTED_MOVING" or event == "PLAYER_STOPPED_MOVING" then
        FC:TouchAction()
        FC:HandleContextEvent(event, ...)

    elseif event == "UNIT_AURA" then
        local unit = ...
        if unit == "player" then FC:CheckFallbackProcs() end
        FC:HandleContextEvent(event, ...)

    elseif event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" then
        local unit = ...
        if FC.CheckVexaHealthVoice then FC:CheckVexaHealthVoice(unit) end
        FC:HandleContextEvent(event, ...)

    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local spellID = ...
        FC:HandleProcOverlay(true, spellID)

    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local spellID = ...
        FC:HandleProcOverlay(false, spellID)

    elseif event == "SPELLS_CHANGED" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" then
        if FC.state.procAlerts then
            FC.state.procAlerts.usable = {}
            FC.state.procAlerts.auras = {}
        end
        FC:RebuildProcActionMap()

    elseif event == "ACTIONBAR_UPDATE_USABLE" then
        FC:CheckActionBarProcs()
        FC:CheckFallbackProcs()

    elseif event == "CVAR_UPDATE" then
        local cvarName = tostring((...) or "")
        if cvarName == "Sound_EnableAllSound" or cvarName == "Sound_EnableSFX" or cvarName == "Sound_EnableDialog" then
            FC:HandleProcSoundSettingsChanged()
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        FC:HandleProcCombatLog(...)

    elseif event == "EJ_LOOT_DATA_RECIEVED" or event == "GET_ITEM_INFO_RECEIVED" then
        if FC:IsDungeonContext() then
            after(0.2, function() if FC.state.ready and FC:IsDungeonContext() then FC:ScanDungeonLoot(true) end end)
        end

    elseif event == "UPDATE_INSTANCE_INFO" then
        FC:HandleContextEvent(event, ...)
        if FC:IsDungeonContext() then FC:ScanDungeonLoot(true) end

    elseif event == "BAG_UPDATE_DELAYED" then
        FC:CheckWorldState()

    elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_MONEY" then
        FC:TouchAction()
        if event == "PLAYER_MONEY" and FC.HandleGoldMoneyUpdate then FC:HandleGoldMoneyUpdate() end
        FC:HandleContextEvent(event, ...)

    elseif event == "UPDATE_INVENTORY_DURABILITY" then
        FC:CheckWorldState()
        FC:HandleContextEvent(event, ...)

    elseif event == "PLAYER_LOGOUT" then
        if FC:IsGoldFarmActive() then FC:StopGoldFarm(true) end
        FC:FinalizeSession("logout")

    elseif event == "PLAYER_CAMPING" then
        if FC:IsGoldFarmActive() then FC:StopGoldFarm(true) end
        FC:FinalizeSession("camping")
        FC:HandleContextEvent(event, ...)

    else
        FC:HandleContextEvent(event, ...)
    end
end

local function onEvent(_, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == FC.addonName or addonName == "ForeverCompanion" then startup() end
        return
    end
    if not FC.state.ready or not FC.db then return end
    coreEvent(event, ...)
end

eventFrame:SetScript("OnEvent", onEvent)

eventFrame:SetScript("OnUpdate", function(_, elapsed)
    if not FC.state.ready then return end

    FC:ProcTick(elapsed)
    FC:ContextTick(elapsed)
    if FC.ConversationTick then FC:ConversationTick(elapsed) end

    FC.state.tick = (FC.state.tick or 0) + elapsed
    if FC.state.tick < 1 then return end
    FC.state.tick = 0

    FC:PumpQueue()

    if FC.bubble and FC.bubble:IsShown() and not FC.bubble.pinned and not FC.bubble.hovered and GetTime() > (FC.bubble.untilTime or 0) then
        local continued = FC.AdvanceBubblePage and FC:AdvanceBubblePage()
        if not continued then
            FC.bubble:Hide()
            FC:SetAnimation("idle")
        end
    end

    if GetTime() - (FC.state.lastThought or 0) > 60 then
        FC.state.lastThought = GetTime()
        FC:CheckWorldState()
        FC:Thought()
    end
end)

-- Forever/retail taint diagnostics. Capture only our own blocked actions.
local actionDiag = CreateFrame("Frame")
pcall(actionDiag.RegisterEvent, actionDiag, "ADDON_ACTION_BLOCKED")
pcall(actionDiag.RegisterEvent, actionDiag, "ADDON_ACTION_FORBIDDEN")
actionDiag:SetScript("OnEvent", function(_, eventName, addonName, functionName)
    if addonName == FC.addonName or addonName == "ForeverCompanion" then
        FC.state.lastTaint = tostring(eventName) .. " function=" .. tostring(functionName or "<unknown>")
        if FC.db and FC.db.debug then FC:Debug("Taint: " .. FC.state.lastTaint) end
    end
end)
