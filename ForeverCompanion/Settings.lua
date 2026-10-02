local FC = _G.ForeverCompanion

local tabs = {
    "Companion",
    "Personality",
    "Commentary",
    "Intelligence",
    "Characters",
    "Conversation",
    "Gold Farming",
    "Appearance",
    "Memory",
    "Test Lab",
    "Advanced",
}

local ART_FRAME = "Interface/AddOns/ForeverCompanion/Media/UI/SettingsFrame.tga"
local ART_CARD = "Interface/AddOns/ForeverCompanion/Media/UI/ContentCard.tga"
local ART_BANNER = "Interface/AddOns/ForeverCompanion/Media/UI/TitleBanner.tga"

local function applyBackdrop(frame, alpha)
    if not frame or not frame.SetBackdrop then return end
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 14,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0.012, 0.016, 0.03, alpha or 0.98)
    frame:SetBackdropBorderColor(0.38, 0.28, 0.68, 0.95)
end

local function makeLabel(parent, text, x, y, font)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    label:SetPoint("TOPLEFT", x, y)
    label:SetText(text or "")
    if font == "GameFontNormalHuge" then
        label:SetTextColor(1, 0.82, 0.18)
    elseif font == "GameFontNormalLarge" or font == "GameFontNormal" then
        label:SetTextColor(1, 0.82, 0.18)
    end
    return label
end

local function makeButton(parent, text, x, y, width, callback)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width or 120, 28)
    button:SetPoint("TOPLEFT", x, y)
    button:SetText(text or "")
    button:SetScript("OnClick", callback)
    return button
end

local function setCheckText(checkButton, text)
    local label = checkButton.Text or checkButton.text
    if not label or type(label.SetText) ~= "function" then
        label = checkButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", checkButton, "RIGHT", 2, 1)
        checkButton.FCLabel = label
    end
    label:SetText(text or "")
end

local function makeCheck(parent, text, x, y, key, subsection, onChanged)
    local checkButton = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    checkButton:SetPoint("TOPLEFT", x, y)
    setCheckText(checkButton, text)

    local function getTable()
        if subsection then
            FC.db[subsection] = FC.db[subsection] or {}
            return FC.db[subsection]
        end
        return FC.db
    end

    checkButton:SetChecked(getTable()[key] and true or false)
    checkButton:SetScript("OnClick", function(button)
        getTable()[key] = button:GetChecked() and true or false
        if onChanged then
            onChanged(button:GetChecked() and true or false)
        end
    end)

    return checkButton
end

local function makeSlider(parent, text, x, y, key, subsection, minimum, maximum, step)
    makeLabel(parent, text, x, y, "GameFontNormal")

    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", x, y - 25)
    slider:SetSize(240, 18)
    slider:SetMinMaxValues(minimum, maximum)
    slider:SetValueStep(step)
    if slider.SetObeyStepOnDrag then
        slider:SetObeyStepOnDrag(true)
    end

    local data = subsection and FC.db[subsection] or FC.db
    if subsection then
        FC.db[subsection] = FC.db[subsection] or {}
        data = FC.db[subsection]
    end

    local value = tonumber(data[key]) or minimum
    slider:SetValue(value)

    local low = makeLabel(parent, tostring(minimum), x, y - 46, "GameFontHighlightSmall")
    local high = makeLabel(parent, tostring(maximum), x + 210, y - 46, "GameFontHighlightSmall")
    high:SetJustifyH("RIGHT")

    local valueLabel = makeLabel(parent, string.format("%.2f", value), x + 90, y - 47, "GameFontHighlightSmall")
    valueLabel:SetWidth(60)
    valueLabel:SetJustifyH("CENTER")

    slider:SetScript("OnValueChanged", function(_, newValue)
        data[key] = newValue
        valueLabel:SetText(string.format("%.2f", newValue))
        if key == "scale" then
            FC:ApplyPosition()
        elseif key == "bubbleScale" and FC.ReanchorBubble then
            FC:ReanchorBubble()
        elseif key == "fontScale" and FC.bubble and FC.bubble:IsShown() and FC.bubbleText then
            local currentText = FC.bubbleText:GetText()
            if currentText and currentText ~= "" then FC:ShowBubble(currentText) end
        end
    end)

    slider.FCLow = low
    slider.FCHigh = high
    slider.FCValue = valueLabel
    return slider
end

function FC:RegisterNativeSettings()
    if self.nativeSettingsRegistered then return end

    local panel = CreateFrame("Frame", "ForeverCompanionNativeSettingsPanel")
    self.nativeSettingsPanel = panel
    panel.name = "Forever Companion"

    local title = makeLabel(panel, "Forever Companion", 20, -20, "GameFontNormalLarge")
    title:SetTextColor(1, 0.44, 0.68)
    makeLabel(
        panel,
        "Animated companion, leveling intelligence, memory, commentary, and model controls.",
        20,
        -52,
        "GameFontHighlight"
    )
    makeButton(panel, "Open Companion Control Center", 20, -92, 230, function()
        FC:OpenSettings("Companion")
    end)
    makeLabel(panel, "You can also use /fc settings or the minimap button.", 20, -132, "GameFontHighlightSmall")

    local registered = false

    if Settings and type(Settings.RegisterCanvasLayoutCategory) == "function" and type(Settings.RegisterAddOnCategory) == "function" then
        local ok, category = pcall(Settings.RegisterCanvasLayoutCategory, panel, "Forever Companion")
        if ok and category then
            pcall(Settings.RegisterAddOnCategory, category)
            self.nativeSettingsCategory = category
            registered = true
        end
    end

    if not registered and type(InterfaceOptions_AddCategory) == "function" then
        local ok = pcall(InterfaceOptions_AddCategory, panel)
        registered = ok and true or false
    end

    self.nativeSettingsRegistered = registered
end

function FC:CreateSettings()
    if self.settings then return self.settings end

    -- Build into a local, unnamed frame. We do not publish self.settings until
    -- construction succeeds, so a failed build cannot leave a permanent blank shell.
    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    -- Match the native 4:3 settings artwork and leave a generous inner safe area.
    frame:SetSize(1024, 768)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local art = frame:CreateTexture(nil, "BACKGROUND")
    art:SetAllPoints()
    art:SetTexture(ART_FRAME)
    frame.FCBackground = art

    local titlePlate = frame:CreateTexture(nil, "ARTWORK")
    titlePlate:SetPoint("TOP", frame, "TOP", 0, -14)
    titlePlate:SetSize(520, 173)
    titlePlate:SetTexture(ART_BANNER)

    local title = makeLabel(frame, "FOREVER COMPANION", 0, 0, "GameFontNormalHuge")
    title:ClearAllPoints()
    title:SetPoint("TOP", frame, "TOP", 0, -34)
    title:SetTextColor(1, 0.80, 1)

    local subtitle = makeLabel(frame, "Companion control center  •  v" .. self.version, 0, 0, "GameFontHighlightSmall")
    subtitle:ClearAllPoints()
    subtitle:SetPoint("TOP", frame, "TOP", 0, -62)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -12, -10)

    local nav = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    nav:SetPoint("TOPLEFT", 38, -108)
    nav:SetPoint("BOTTOMLEFT", 38, 38)
    nav:SetWidth(180)
    applyBackdrop(nav, 0.35)

    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", nav, "TOPRIGHT", 20, 0)
    content:SetPoint("BOTTOMRIGHT", -38, 38)

    local contentBG = content:CreateTexture(nil, "BACKGROUND")
    contentBG:SetAllPoints()
    contentBG:SetTexture(ART_CARD)
    contentBG:SetVertexColor(1, 1, 1, 0.92)

    local pages = {}
    local buttons = {}

    for index, name in ipairs(tabs) do
        local button = makeButton(nav, name, 14, -16 - (index - 1) * 45, 150, function()
            FC:ShowSettingsTab(name)
        end)
        button:SetHeight(34)
        buttons[name] = button

        local page = CreateFrame("Frame", nil, content)
        -- The artwork has a thick decorative crown and side filigree.  Build every
        -- page inside the same measured safe box so controls never sit on the art.
        page:SetPoint("TOPLEFT", 48, -72)
        page:SetPoint("BOTTOMRIGHT", -48, 30)
        page:Hide()
        pages[name] = page
    end

    -- Publish the page tables before builders run; each page is isolated behind pcall.
    self.settingsPages = pages
    self.tabButtons = buttons
    self.settingsBuildErrors = {}

    local builders = {
        Companion = "BuildCompanionPage",
        Personality = "BuildPersonalityPage",
        Commentary = "BuildCommentaryPage",
        Intelligence = "BuildIntelligencePage",
        Characters = "BuildCharactersPage",
        Conversation = "BuildConversationPage",
        ["Gold Farming"] = "BuildGoldPage",
        Appearance = "BuildAppearancePage",
        Memory = "BuildMemoryPage",
        ["Test Lab"] = "BuildTestLabPage",
        Advanced = "BuildAdvancedPage",
    }

    local successful = 0
    for _, pageName in ipairs(tabs) do
        local page = pages[pageName]
        local method = self[builders[pageName]]
        if page and type(method) == "function" then
            local ok, err = pcall(method, self, page)
            if ok then
                successful = successful + 1
            else
                self.settingsBuildErrors[pageName] = tostring(err)
                local errorTitle = makeLabel(page, pageName .. " page error", 18, -20, "GameFontNormalLarge")
                errorTitle:SetTextColor(1, 0.35, 0.45)
                local errorText = makeLabel(page, tostring(err), 18, -58, "GameFontHighlightSmall")
                errorText:SetWidth(590)
            end
        end
    end

    self.settings = frame
    self:ShowSettingsTab(self.db.ui.lastTab or "Companion")
    frame:Hide()
    return frame
end

function FC:ShowSettingsTab(name)
    if not self.settingsPages then return end
    if not self.settingsPages[name] then name = "Companion" end

    for pageName, page in pairs(self.settingsPages) do
        page:SetShown(pageName == name)
    end

    for pageName, button in pairs(self.tabButtons or {}) do
        if pageName == name then
            if button.LockHighlight then button:LockHighlight() end
            local fs = button.GetFontString and button:GetFontString() or nil
            if fs then fs:SetTextColor(1, 0.82, 0.20) end
        else
            if button.UnlockHighlight then button:UnlockHighlight() end
            local fs = button.GetFontString and button:GetFontString() or nil
            if fs then fs:SetTextColor(1, 0.82, 0.20) end
        end
    end

    self.db.ui.lastTab = name

    if name == "Intelligence" then
        self:RefreshIntelligence()
    elseif name == "Characters" then
        self:RefreshCharactersPage()
    elseif name == "Conversation" then
        self:RefreshConversationPage()
    elseif name == "Gold Farming" then
        self:RefreshGoldPage()
    elseif name == "Memory" then
        self:RefreshJournal()
    elseif name == "Appearance" then
        self:RefreshAppearanceStatus()
    elseif name == "Test Lab" and self.testLabOutput then
        self.testLabOutput:SetText("Use these simulations to verify reactions without reproducing them naturally in game.")
    end
end

function FC:OpenSettings(tab)
    if not self.settings then
        local ok = self:Call("CreateSettings")
        if not ok then return end
    end

    self.settings:Show()
    self:ShowSettingsTab(tab or self.db.ui.lastTab or "Companion")
end

function FC:ToggleSettings()
    if not self.settings then
        self:OpenSettings("Companion")
        return
    end

    if self.settings:IsShown() then
        self.settings:Hide()
    else
        self:OpenSettings()
    end
end

function FC:BuildCompanionPage(page)
    makeLabel(page, "Vexa", 8, -8, "GameFontNormalHuge")
    local intro = makeLabel(page, "Vexa is the active companion. Additional companions are hidden until their artwork, personality, and memory systems are fully built.", 10, -40, "GameFontHighlightSmall")
    intro:SetWidth(620)

    makeLabel(page, "Presentation", 10, -100, "GameFontNormalLarge")
    for index, mode in ipairs({ "full", "desktop", "portrait" }) do
        makeButton(
            page,
            mode:gsub("^%l", string.upper),
            10 + (index - 1) * 150,
            -135,
            135,
            function() self:SetMode(mode) end
        )
    end

    makeSlider(page, "Companion scale", 10, -205, "scale", nil, 0.65, 1.6, 0.05)
    makeSlider(page, "Subtle idle motion", 330, -205, "motion", "appearance", 0, 0.35, 0.01)

    makeCheck(page, "Lock companion position", 10, -285, "locked", "ui")
    makeCheck(page, "Speech bubbles", 330, -285, "bubble")

    makeSlider(page, "Speech bubble size", 10, -345, "bubbleScale", "appearance", 0.70, 1.30, 0.05)
    makeSlider(page, "Speech font size", 330, -345, "fontScale", "appearance", 0.80, 1.25, 0.05)

    local tip = makeLabel(
        page,
        "Left-click a bubble to dismiss it. Right-click it to pin or unpin it. Alt + mouse wheel over Vexa changes her size. Right-click Vexa for quick actions.",
        10,
        -445,
        "GameFontHighlightSmall"
    )
    tip:SetWidth(620)
end

function FC:BuildPersonalityPage(page)
    makeLabel(page, "Personality Mixer", 8, -8, "GameFontNormalHuge")
    local intro = makeLabel(page, "Tune the companion's voice without changing the underlying gameplay logic.", 10, -40, "GameFontHighlightSmall")
    intro:SetWidth(600)

    makeSlider(page, "Helpful", 10, -80, "helpful", "personality", 0, 1, 0.05)
    makeSlider(page, "Smartass", 330, -80, "smartass", "personality", 0, 1, 0.05)
    makeSlider(page, "Flirty", 10, -165, "flirty", "personality", 0, 1, 0.05)
    makeSlider(page, "Chaotic", 330, -165, "chaotic", "personality", 0, 1, 0.05)
    makeSlider(page, "Roast me", 10, -250, "roast", "personality", 0, 1, 0.05)
    makeSlider(page, "Overall talk frequency", 330, -250, "chatty", nil, 0.05, 1, 0.05)
end

function FC:BuildCommentaryPage(page)
    makeLabel(page, "Commentary Mixer", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Control which parts of your adventure deserve the most attention.", 10, -40, "GameFontHighlightSmall")

    local categories = {
        { "XP & leveling", "xp" },
        { "Quests", "quests" },
        { "Combat", "combat" },
        { "World & travel", "world" },
        { "Loot & gear", "loot" },
        { "Tips", "tips" },
        { "Jokes", "jokes" },
    }

    for index, info in ipairs(categories) do
        local column = (index - 1) % 2
        local row = math.floor((index - 1) / 2)
        makeSlider(page, info[1], 10 + column * 320, -80 - row * 90, info[2], "commentary", 0, 1, 0.05)
    end
    local note = makeLabel(page, "Fine control: /fc mute <category> and /fc unmute <category>. Categories include ambient, xp, quests, combat, world, loot, group, target, class, social, memory.", 10, -455, "GameFontHighlightSmall")
    note:SetWidth(620)
end

function FC:BuildIntelligencePage(page)
    makeLabel(page, "What Your Companion Knows", 8, -8, "GameFontNormalHuge")
    self.intelText = makeLabel(page, "", 10, -58, "GameFontHighlight")
    self.intelText:SetWidth(600)
    self.intelText:SetJustifyH("LEFT")
    self.intelText:SetJustifyV("TOP")

    makeButton(page, "Refresh Character Profile", 10, -430, 190, function()
        self:RunCatchup(true)
        self:RefreshIntelligence()
    end)
end

function FC:RefreshIntelligence()
    if not self.intelText then return end

    local profile = (self.RefreshLiveProfile and self:RefreshLiveProfile()) or self.db.memory.profile or {}
    local quests = self.state.questSnapshot or {}
    local remaining, rate, seconds, fights = self:Estimate()
    local zone = self.state.zone or profile.zone or "Unknown"
    local zoneRate = self:ZoneHistoricalRate(zone)

    self.intelText:SetText(string.format(
        "|cffff6fae%s|r  •  Level %d %s\n" ..
        "Zone: %s\n\n" ..
        "|cffffd36aLEVELING|r\n" ..
        "Current pace: %s XP/hr\n" ..
        "XP remaining: %s\n" ..
        "Estimated time: %s\n" ..
        "Recent combat pace: %s\n\n" ..
        "|cff75d6ffQUESTS|r\n" ..
        "Active: %d\n" ..
        "Ready to turn in: %d\n" ..
        "Known historical completions: %s\n\n" ..
        "|cff9ef0b8MEMORY|r\n" ..
        "Sessions together: %d\n" ..
        "Deaths witnessed: %d\n" ..
        "Quest turn-ins witnessed: %d\n" ..
        "Historical zone pace here: %s XP/hr",
        profile.name or (UnitName and UnitName("player")) or "Hero",
        (UnitLevel and UnitLevel("player")) or 0,
        profile.class or "",
        zone,
        self:FormatNumber(rate),
        self:FormatNumber(remaining),
        seconds and self:FormatDuration(seconds) or "learning",
        fights and ("~" .. fights .. " fights") or "learning",
        quests.active or 0,
        quests.complete or 0,
        self:FormatNumber(profile.completedHistoryKnown or 0),
        self.db.memory.sessions or 0,
        self.db.memory.lifetimeDeaths or 0,
        self.db.memory.questTurnins or 0,
        self:FormatNumber(zoneRate)
    ))
end

function FC:BuildGoldPage(page)
    makeLabel(page, "Gold Farming", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Track vendor floor, Auctionator scanned AH value, item mix, and gold-per-hour while you farm.", 10, -40, "GameFontHighlightSmall")

    self.goldStatusText = makeLabel(page, "", 10, -78, "GameFontHighlight")
    self.goldStatusText:SetWidth(610)
    self.goldStatusText:SetJustifyH("LEFT")
    self.goldStatusText:SetJustifyV("TOP")

    makeButton(page, "Start / Stop Farm", 10, -265, 160, function()
        self:ToggleGoldFarm()
        self:RefreshGoldPage()
    end)
    makeButton(page, "Reset Current", 180, -265, 140, function()
        self:ResetGoldFarm()
        self:RefreshGoldPage()
    end)
    makeButton(page, "Tell Me My Pace", 330, -265, 155, function() self:ShowGoldFarmStats() end)
    makeButton(page, "Refresh Auctionator", 495, -265, 150, function()
        self:RefreshGoldIntegration()
        self:RevalueGoldSession()
        self:RefreshGoldPage()
    end)

    makeCheck(page, "Use Auctionator scan data", 10, -320, "useAuctionator", "goldFarming", function() self:RefreshGoldIntegration() end)
    makeCheck(page, "Vexa comments on valuable drops and pace", 10, -355, "commentary", "goldFarming")

    makeSlider(page, "Valuable-drop comment threshold (gold)", 10, -405, "valuableGold", "goldFarming", 0.25, 25, 0.25)
    makeSlider(page, "Pace commentary interval (minutes)", 330, -405, "paceMinutes", "goldFarming", 1, 15, 1)

    local note = makeLabel(page, "Tip: /fc farm start [label] • /fc farm stats • /fc farm stop • /fc value [shift-click item]. Auction value uses Auctionator's last scanned AH price; scan age is shown when available. Vendor value is the guaranteed floor.", 10, -468, "GameFontHighlightSmall")
    note:SetWidth(620)
end

function FC:RefreshGoldPage()
    if not self.goldStatusText then return end
    if self.RefreshGoldIntegration then self:RefreshGoldIntegration() end

    local gold = self.state.gold or {}
    local summary = self.GetGoldFarmSummary and self:GetGoldFarmSummary(gold) or {}
    local active = gold.active and "|cff68f59aACTIVE|r" or "|cffb8b8c8stopped|r"
    local auctionator = self.state.integrations and self.state.integrations.Auctionator
    local auctionatorDetail = self.state.integrationDetails and self.state.integrationDetails.Auctionator
    local version = auctionatorDetail and auctionatorDetail.version or nil
    local source = auctionator and ("|cff68f59aAuctionator connected" .. (version and version ~= "unknown" and (" (v" .. tostring(version) .. ")") or "") .. "|r") or "|cffffb35cAuctionator not detected|r"
    local top = summary.topItem and (summary.topItem.name or summary.topItem.link) or "learning"
    local itemCount = 0
    for _ in pairs(gold.items or {}) do itemCount = itemCount + 1 end

    self.goldStatusText:SetText(string.format(
        "Status: %s   •   %s\n" ..
        "Farm: %s\n" ..
        "Elapsed: %s   •   Loot events: %d   •   Unique items: %d\n\n" ..
        "|cffffd36aAUCTIONATOR SCAN VALUE|r  %s   •   %s/hour\n" ..
        "|cff9ef0b8VENDOR FLOOR|r   %s   •   %s/hour\n" ..
        "Field cash: %s   •   Total cash gained: %s   •   Cash spent: %s\n" ..
        "Top item: %s",
        active,
        source,
        tostring(gold.label or "No active session"),
        self:FormatDuration(summary.seconds or 0),
        gold.lootEvents or 0,
        itemCount,
        self:FormatMoneyCopper(summary.market or 0),
        self:FormatMoneyCopper(summary.marketPerHour or 0),
        self:FormatMoneyCopper(summary.vendor or 0),
        self:FormatMoneyCopper(summary.vendorPerHour or 0),
        self:FormatMoneyCopper(summary.fieldCashEarned or 0),
        self:FormatMoneyCopper(summary.cashEarned or 0),
        self:FormatMoneyCopper(summary.cashSpent or 0),
        tostring(top)
    ))
end

function FC:BuildAppearancePage(page)
    makeLabel(page, "Appearance & Art Lab", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Use the bundled Vexa art by default, or test game-client 3D models if you want.", 10, -40, "GameFontHighlightSmall")

    self.rendererText = makeLabel(page, "", 10, -76, "GameFontHighlight")
    self.rendererText:SetWidth(610)

    makeButton(page, "Use Vexa art", 10, -125, 150, function()
        self.db.appearance.renderer = "sprite"
        ReloadUI()
    end)

    makeButton(page, "Use game 3D model", 170, -125, 170, function()
        self.db.appearance.renderer = "model"
        ReloadUI()
    end)

    makeLabel(page, "Display ID (optional, 3D model mode)", 10, -185, "GameFontNormal")
    local edit = CreateFrame("EditBox", nil, page, "InputBoxTemplate")
    self.displayEdit = edit
    edit:SetSize(170, 28)
    edit:SetPoint("TOPLEFT", 10, -208)
    edit:SetAutoFocus(false)
    edit:SetText(self.db.appearance.displayID and tostring(self.db.appearance.displayID) or "")

    makeButton(page, "Apply model", 195, -208, 120, function()
        self.db.appearance.renderer = "model"
        self.db.appearance.displayID = tonumber(edit:GetText())
        self:ApplyModelLab()
        self:RefreshAppearanceStatus()
    end)

    makeButton(page, "Use my character", 325, -208, 140, function()
        self.db.appearance.renderer = "model"
        self.db.appearance.displayID = nil
        edit:SetText("")
        self:ApplyModelLab()
        self:RefreshAppearanceStatus()
    end)

    makeLabel(page, "Animation test", 10, -275, "GameFontNormal")
    local animations = { "idle", "talk", "celebrate", "think", "point", "laugh", "flirty", "playful", "worried", "angry", "magic", "combat" }
    for index, animation in ipairs(animations) do
        makeButton(
            page,
            animation,
            10 + ((index - 1) % 4) * 145,
            -300 - math.floor((index - 1) / 4) * 36,
            130,
            function() self:SetAnimation(animation) end
        )
    end

    makeSlider(page, "Model distance / scale", 10, -430, "modelScale", "appearance", 0.5, 2, 0.05)
    makeSlider(page, "Rotation", 330, -430, "rotation", "appearance", 0, 6.28, 0.05)
    makeButton(page, "Apply camera", 10, -478, 150, function() self:ApplyModelLab() end)

end

function FC:RefreshAppearanceStatus()
    if not self.rendererText then return end

    local source = self.state.renderer == "SpriteHD" and "Bundled HD state art" or "Game-client 3D assets"
    self.rendererText:SetText(
        "Renderer: |cffffffff" .. self:RendererStatus() ..
        "|r\nVisual source: |cffffffff" .. source .. "|r"
    )
end

function FC:BuildMemoryPage(page)
    makeLabel(page, "Memory Journal", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "A readable history of what the companion actually witnessed.", 10, -40, "GameFontHighlightSmall")

    local scrollFrame = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -75)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 55)

    local child = CreateFrame("Frame", nil, scrollFrame)
    child:SetSize(570, 800)
    scrollFrame:SetScrollChild(child)

    self.journalText = makeLabel(child, "", 0, 0, "GameFontHighlight")
    self.journalText:SetWidth(560)
    self.journalText:SetJustifyH("LEFT")
    self.journalText:SetJustifyV("TOP")

    makeButton(page, "Refresh", 10, -478, 110, function() self:RefreshJournal() end)
    makeButton(page, "Export memory", 135, -478, 130, function() self:OpenMemoryTransfer("export") end)
    makeButton(page, "Import memory", 280, -478, 130, function() self:OpenMemoryTransfer("import") end)
    makeButton(page, "Last session", 425, -478, 120, function() self:ShowLastSession() end)
end

function FC:RefreshJournal()
    if not self.journalText then return end

    local header = {}
    local profile = (self.RefreshLiveProfile and self:RefreshLiveProfile()) or self.db.memory.profile or {}
    header[#header + 1] = "|cffff6faeCurrent character:|r " .. tostring(profile.name or "Hero") .. "  •  " .. tostring(profile.class or "Unknown")

    local remembered = {}
    if self.db.sharedMemory and self.db.sharedMemory.characters then
        for _, info in pairs(self.db.sharedMemory.characters) do
            if info and info.name then
                remembered[#remembered + 1] = tostring(info.name) .. " (" .. tostring(info.class or "Unknown") .. ", " .. tostring(info.level or "?") .. ")"
            end
        end
    end
    table.sort(remembered)
    header[#header + 1] = "|cff9ef0b8Characters Vexa remembers:|r " .. (#remembered > 0 and table.concat(remembered, ", ") or "none yet")

    local lines = self:JournalLines(50)
    header[#header + 1] = ""
    for _, line in ipairs(lines) do header[#header + 1] = line end

    self.journalText:SetText(table.concat(header, "\n\n"))
    local height = math.max(500, self.journalText:GetStringHeight() + 30)
    self.journalText:GetParent():SetHeight(height)
end

function FC:BuildAdvancedPage(page)
    makeLabel(page, "Advanced & Diagnostics", 8, -8, "GameFontNormalHuge")

    makeCheck(page, "Enable addon", 10, -65, "enabled")
    makeCheck(page, "Debug output", 10, -100, "debug")
    makeCheck(page, "Lock companion", 10, -135, "locked", "ui")

    local minimapCheck = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    minimapCheck:SetPoint("TOPLEFT", 10, -170)
    setCheckText(minimapCheck, "Show minimap button")
    minimapCheck:SetChecked(not (self.db.minimap and self.db.minimap.hide))
    minimapCheck:SetScript("OnClick", function(button)
        self:SetMinimapButtonShown(button:GetChecked() and true or false)
    end)

    self.capText = makeLabel(page, "", 10, -210, "GameFontHighlight")
    self.capText:SetWidth(600)

    makeButton(page, "Run compatibility scan", 10, -300, 190, function()
        self:DetectCapabilities()
        local lines = {}
        for key, value in pairs(self.state.capabilities) do
            lines[#lines + 1] = key .. ": " .. tostring(value)
        end
        table.sort(lines)
        self.capText:SetText(table.concat(lines, "   •   "))
    end)

    makeButton(page, "Reset position", 220, -300, 140, function()
        self.db.x = 360
        self.db.y = 180
        self:ApplyPosition()
    end)

    makeButton(page, "Catch-up scan", 370, -300, 140, function()
        self:RunCatchup(true)
    end)

    makeButton(page, "Print version", 520, -300, 120, function()
        self:PrintVersion()
    end)

    makeButton(page, "Run Doctor", 10, -345, 140, function()
        self:RunDoctor()
    end)
    makeButton(page, "Why last line?", 165, -345, 140, function()
        self:WhyLastStatement()
    end)
    makeButton(page, "Integration scan", 320, -345, 150, function()
        self.capText:SetText(self:IntegrationSummary())
    end)
    makeButton(page, "Full test suite", 485, -345, 145, function()
        self:RunTestSuite()
    end)
end


function FC:BuildCharactersPage(page)
    makeLabel(page, "Character Roster", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Vexa keeps separate progression memory for each character while remembering that all of them are yours.", 10, -40, "GameFontHighlightSmall")
    self.charactersText = makeLabel(page, "", 10, -82, "GameFontHighlight")
    self.charactersText:SetWidth(625)
    self.charactersText:SetJustifyH("LEFT")
    self.charactersText:SetJustifyV("TOP")
    makeButton(page, "Refresh roster", 10, -470, 130, function() self:RefreshCharactersPage() end)
    makeButton(page, "Current profile scan", 155, -470, 155, function() self:RunCatchup(true); self:RefreshCharactersPage() end)
    makeButton(page, "Last session", 325, -470, 130, function() self:ShowLastSession() end)
end

function FC:RefreshCharactersPage()
    if not self.charactersText then return end
    local lines = {}
    local characters = self.db.sharedMemory and self.db.sharedMemory.characters or {}
    for key, info in pairs(characters) do
        local marker = key == self.characterKey and " |cffff6fae< current >|r" or ""
        local lastSeen = info.lastSeen and date and date("%b %d %H:%M", info.lastSeen) or "unknown"
        lines[#lines + 1] = string.format(
            "|cffffffff%s|r — level %s %s\nRealm: %s  •  Sessions: %s  •  Last seen: %s%s",
            tostring(info.name or key), tostring(info.level or "?"), tostring(info.class or "Unknown"), tostring(info.realm or "?"), tostring(info.sessions or 0), tostring(lastSeen), marker
        )
    end
    table.sort(lines)
    if #lines == 0 then lines[1] = "No remembered characters yet." end
    self.charactersText:SetText(table.concat(lines, "\n\n"))
end

function FC:BuildConversationPage(page)
    makeLabel(page, "Conversation & Personality", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Control Vexa's ambient chatter and review what she has said recently.", 10, -40, "GameFontHighlightSmall")

    makeSlider(page, "Conversation frequency", 10, -66, "frequency", "conversation", 0.10, 1.00, 0.05)
    makeCheck(page, "Ambient conversations", 330, -78, "enabled", "conversation")
    makeCheck(page, "Walking chatter", 330, -112, "walking", "conversation")
    makeCheck(page, "WoW trivia", 470, -78, "facts", "conversation")
    makeCheck(page, "Jokes & banter", 470, -112, "jokes", "conversation")
    makeCheck(page, "Class-specific chatter", 330, -146, "classBanter", "conversation")
    makeCheck(page, "Cross-character callbacks", 470, -146, "memoryBanter", "conversation")

    self.vocabularyText = makeLabel(page, "", 10, -165, "GameFontHighlightSmall")
    self.vocabularyText:SetWidth(610)

    local scroll = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 10, -200)
    scroll:SetPoint("BOTTOMRIGHT", -30, 70)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(590, 900)
    scroll:SetScrollChild(child)
    self.conversationText = makeLabel(child, "", 0, 0, "GameFontHighlight")
    self.conversationText:SetWidth(580)
    self.conversationText:SetJustifyH("LEFT")
    self.conversationText:SetJustifyV("TOP")

    makeButton(page, "Tell me something", 10, -478, 135, function() self:ForceConversation() end)
    makeButton(page, "Refresh", 155, -478, 95, function() self:RefreshConversationPage() end)
    makeButton(page, "Repeat last", 260, -478, 110, function() self:RepeatLastStatement() end)
    makeButton(page, "Why last?", 380, -478, 105, function() self:WhyLastStatement() end)
    makeButton(page, "Block last", 495, -478, 100, function() self:BlockLastStatement() end)
end

function FC:RefreshConversationPage()
    if not self.conversationText then return end
    local lines = self:DialogueHistoryLines(60)
    self.conversationText:SetText(table.concat(lines, "\n\n"))
    self.conversationText:GetParent():SetHeight(math.max(600, self.conversationText:GetStringHeight() + 30))
    if self.vocabularyText then
        local total, pools = self:RefreshVocabularyStats()
        local riddles = type(self.BuildRiddleBank) == "function" and #(self:BuildRiddleBank() or {}) or 0
        local trivia = type(self.BuildTriviaBank) == "function" and #(self:BuildTriviaBank() or {}) or 0
        local lexicon = #(self.lexicon or {})
        self.vocabularyText:SetText(string.format("|cffff6faeLibrary:|r %s dialogue variants across %s Vexa topic pools + %s riddles + %s trivia variants + %s dictionary words.  /fc word • vocabquiz • trivia • story • vocab", tostring(total or 0), tostring(pools or 0), tostring(riddles), tostring(trivia), tostring(lexicon)))
    end
end

function FC:BuildTestLabPage(page)
    makeLabel(page, "Test Lab", 8, -8, "GameFontNormalHuge")
    makeLabel(page, "Simulate reactions and run internal checks before relying on live gameplay to reproduce a bug.", 10, -40, "GameFontHighlightSmall")

    local tests = {
        { "98% XP validation", "xp98" }, { "Death reaction", "death" }, { "Elite target", "elite" },
        { "Rare/Epic loot", "loot" }, { "Bags warning", "bags" }, { "Boss kill", "boss" },
        { "Class resource", "class" }, { "Bubble wrapping", "bubble" },
    }
    for i, test in ipairs(tests) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        makeButton(page, test[1], 10 + col * 225, -90 - row * 45, 205, function() self:TestScenario(test[2]) end)
    end
    makeButton(page, "Run full QA suite", 10, -300, 205, function()
        local ok = self:RunTestSuite()
        self.testLabOutput:SetText(ok and "All internal checks passed. Full details were printed to chat." or "One or more checks failed. See chat for details.")
    end)
    makeButton(page, "Run Doctor", 230, -300, 160, function()
        local ok = self:RunDoctor()
        self.testLabOutput:SetText(ok and "Doctor passed. Required systems are present." or "Doctor found a problem. See chat.")
    end)
    self.testLabOutput = makeLabel(page, "", 10, -360, "GameFontHighlight")
    self.testLabOutput:SetWidth(620)
    self.testLabOutput:SetJustifyH("LEFT")
end
