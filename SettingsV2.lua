local FC = _G.ForeverCompanion

local ART_FRAME = "Interface/AddOns/ForeverCompanion/Media/UI/SettingsFrame.tga"
local ART_NAV = "Interface/AddOns/ForeverCompanion/Media/UI/SidebarButton.tga"
local ART_BANNER = "Interface/AddOns/ForeverCompanion/Media/UI/TitleBanner.tga"

local TABS = {
    "Companion",
    "Personality",
    "Commentary",
    "Combat Calls",
    "Dungeons",
    "Intelligence",
    "Characters",
    "Conversation",
    "Gold Farming",
    "Appearance",
    "Memory",
    "Test Lab",
    "Advanced",
}

local PAGE_META = {
    Companion = { "Vexa", "Presentation, speech, and on-screen behavior." },
    Personality = { "Personality", "Tune Vexa's tone, attitude, and personality balance." },
    Commentary = { "Commentary", "Choose what Vexa notices and comments on." },
    ["Combat Calls"] = { "Combat Calls", "Proc alerts, screen effects, and spoken combat callouts." },
    Dungeons = { "Dungeon Intelligence", "Boss progress, dungeon priorities, and loot intelligence." },
    Intelligence = { "Intelligence", "See the facts, progress, and memory Vexa is using." },
    Characters = { "Characters", "Per-character memory with shared cross-character awareness." },
    Conversation = { "Conversation", "Ambient chatter, jokes, trivia, and dialogue history." },
    ["Gold Farming"] = { "Gold Farming", "Auctionator pricing, farming pace, and valuable drops." },
    Appearance = { "Appearance", "Vexa art, reactions, animations, and model controls." },
    Memory = { "Memory", "Journal, remembered characters, and import/export tools." },
    ["Test Lab"] = { "Test Lab", "Safely simulate gameplay events and validate reactions." },
    Advanced = { "Advanced", "Diagnostics, compatibility, recovery, and debug tools." },
}

local function setFont(fs, size, outline)
    if not fs or not fs.SetFont then return end
    local flags = outline and "OUTLINE" or ""
    local ok = pcall(fs.SetFont, fs, "Fonts\\FRIZQT__.TTF", size or 12, flags)
    if not ok then return end
    if fs.SetShadowOffset then
        fs:SetShadowOffset(1, -1)
        fs:SetShadowColor(0, 0, 0, 0.95)
    end
end

local function label(parent, text, size, color)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetText(text or "")
    setFont(fs, size or 12, size and size >= 15)
    color = color or { 0.92, 0.92, 0.98 }
    fs:SetTextColor(color[1], color[2], color[3])
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    return fs
end

local function addBackdrop(frame, bgAlpha, borderAlpha)
    if not frame.SetBackdrop then return end
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0.025, 0.035, 0.09, bgAlpha or 0.82)
    frame:SetBackdropBorderColor(0.72, 0.52, 0.18, borderAlpha or 0.75)
end

local function createButton(parent, text, width, height, callback)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(width or 130, height or 30)

    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(ART_NAV)
    bg:SetVertexColor(0.70, 0.72, 0.88, 0.98)
    b.FCBG = bg

    local glow = b:CreateTexture(nil, "BORDER")
    glow:SetAllPoints()
    glow:SetTexture(ART_NAV)
    glow:SetBlendMode("ADD")
    glow:SetAlpha(0)
    b.FCGlow = glow

    local fs = label(b, text, 12, { 1, 0.83, 0.20 })
    fs:SetPoint("CENTER", 0, 0)
    fs:SetJustifyH("CENTER")
    fs:SetJustifyV("MIDDLE")
    fs:SetWidth((width or 130) - 16)
    b.FCText = fs

    b:SetScript("OnEnter", function(self)
        self.FCBG:SetVertexColor(0.92, 0.86, 1, 1)
        self.FCGlow:SetAlpha(0.25)
    end)
    b:SetScript("OnLeave", function(self)
        if self.FCSelected then
            self.FCBG:SetVertexColor(1.0, 0.72, 0.82, 1)
            self.FCGlow:SetAlpha(0.35)
        else
            self.FCBG:SetVertexColor(0.70, 0.72, 0.88, 0.98)
            self.FCGlow:SetAlpha(0)
        end
    end)
    b:SetScript("OnClick", callback)
    return b
end

local function selectButton(button, selected)
    if not button then return end
    button.FCSelected = selected and true or false
    if selected then
        button.FCBG:SetVertexColor(1.0, 0.72, 0.82, 1)
        button.FCGlow:SetAlpha(0.35)
        button.FCText:SetTextColor(1, 0.95, 0.65)
    else
        button.FCBG:SetVertexColor(0.70, 0.72, 0.88, 0.98)
        button.FCGlow:SetAlpha(0)
        button.FCText:SetTextColor(1, 0.83, 0.20)
    end
end

local function createCheck(parent, text, getter, setter)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(28)

    local check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
    check:SetPoint("LEFT", 0, 0)
    check:SetChecked(getter() and true or false)
    check:SetScript("OnClick", function(self)
        setter(self:GetChecked() and true or false)
    end)

    local fs = label(row, text, 12, { 0.95, 0.90, 0.72 })
    fs:SetPoint("LEFT", check, "RIGHT", 4, 0)
    fs:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    fs:SetJustifyV("MIDDLE")
    return row
end

local sliderID = 0
local function createSlider(parent, title, getter, setter, minimum, maximum, step, formatter)
    local box = CreateFrame("Frame", nil, parent)
    box:SetSize(280, 66)

    local titleText = label(box, title, 12, { 1, 0.82, 0.18 })
    titleText:SetPoint("TOPLEFT", 0, -2)
    titleText:SetWidth(205)

    local valueText = label(box, "", 12, { 0.96, 0.96, 1 })
    valueText:SetPoint("TOPRIGHT", 0, -2)
    valueText:SetWidth(68)
    valueText:SetJustifyH("RIGHT")

    sliderID = sliderID + 1
    local slider = CreateFrame("Slider", "ForeverCompanionV2Slider" .. sliderID, box, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 0, -26)
    slider:SetSize(270, 18)
    slider:SetMinMaxValues(minimum, maximum)
    slider:SetValueStep(step)
    if slider.SetObeyStepOnDrag then slider:SetObeyStepOnDrag(true) end
    if slider.Text then slider.Text:Hide() end
    if slider.Low then slider.Low:Hide() end
    if slider.High then slider.High:Hide() end

    local function fmt(v)
        if formatter then return formatter(v) end
        if step >= 1 then return tostring(math.floor(v + 0.5)) end
        return string.format("%.2f", v)
    end

    local value = tonumber(getter()) or minimum
    slider:SetValue(value)
    valueText:SetText(fmt(value))
    slider:SetScript("OnValueChanged", function(_, v)
        setter(v)
        valueText:SetText(fmt(v))
    end)

    return box
end

local Layout = {}
Layout.__index = Layout

function Layout.new(page)
    return setmetatable({
        page = page,
        y = -8,
        width = 620,
        gap = 16,
        col = 296,
    }, Layout)
end

function Layout:space(px)
    self.y = self.y - (px or 12)
end

function Layout:section(title, description, height)
    local card = CreateFrame("Frame", nil, self.page, "BackdropTemplate")
    card:SetPoint("TOPLEFT", 0, self.y)
    card:SetSize(self.width, height)
    addBackdrop(card, 0.62, 0.52)

    local t = label(card, title, 14, { 1, 0.82, 0.18 })
    t:SetPoint("TOPLEFT", 16, -13)
    t:SetPoint("TOPRIGHT", -16, -13)

    local bodyTop = -42
    if description and description ~= "" then
        local d = label(card, description, 11, { 0.74, 0.79, 0.93 })
        d:SetPoint("TOPLEFT", 16, -38)
        d:SetPoint("TOPRIGHT", -16, -38)
        d:SetWordWrap(true)
        bodyTop = -66
    end

    self.y = self.y - height - self.gap
    return card, bodyTop
end

function Layout:sliderPair(title, leftSpec, rightSpec)
    local card, top = self:section(title, nil, 104)
    local a = createSlider(card, leftSpec[1], leftSpec[2], leftSpec[3], leftSpec[4], leftSpec[5], leftSpec[6], leftSpec[7])
    a:SetPoint("TOPLEFT", 16, top - 4)
    if rightSpec then
        local b = createSlider(card, rightSpec[1], rightSpec[2], rightSpec[3], rightSpec[4], rightSpec[5], rightSpec[6], rightSpec[7])
        b:SetPoint("TOPLEFT", 318, top - 4)
    end
end

function Layout:toggleGrid(title, description, specs)
    local rows = math.ceil(#specs / 2)
    local height = 58 + (description and 24 or 0) + rows * 34
    local card, top = self:section(title, description, height)
    for i, spec in ipairs(specs) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local c = createCheck(card, spec[1], spec[2], spec[3])
        c:SetPoint("TOPLEFT", 16 + col * 302, top - row * 34)
        c:SetWidth(286)
    end
end

function Layout:buttonRow(title, buttons, description)
    local rows = math.ceil(#buttons / 4)
    local height = 58 + (description and 24 or 0) + rows * 42
    local card, top = self:section(title, description, height)
    for i, info in ipairs(buttons) do
        local col = (i - 1) % 4
        local row = math.floor((i - 1) / 4)
        local b = createButton(card, info[1], 136, 30, info[2])
        b:SetPoint("TOPLEFT", 16 + col * 148, top - row * 42)
    end
end

function Layout:textCard(title, textGetter, height, refreshButton)
    local card, top = self:section(title, nil, height)
    local fs = label(card, "", 12, { 0.92, 0.92, 0.98 })
    fs:SetPoint("TOPLEFT", 16, top - 2)
    fs:SetPoint("TOPRIGHT", -16, top - 2)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    fs:SetText(textGetter and textGetter() or "")

    if refreshButton then
        local b = createButton(card, refreshButton[1], 150, 28, refreshButton[2])
        b:SetPoint("BOTTOMLEFT", 16, 14)
    end
    return fs, card
end

function Layout:scrollTextCard(title, height, width)
    local card, top = self:section(title, nil, height)
    local scroll = CreateFrame("ScrollFrame", nil, card, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 16, top - 2)
    scroll:SetPoint("BOTTOMRIGHT", -32, 16)

    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(width or 560, 600)
    scroll:SetScrollChild(child)

    local fs = label(child, "", 12, { 0.94, 0.94, 0.98 })
    fs:SetPoint("TOPLEFT", 0, 0)
    fs:SetWidth(width or 560)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    return fs, child, card
end

function Layout:finish(extra)
    local h = math.max(520, math.abs(self.y) + (extra or 10))
    self.page:SetHeight(h)
    return h
end

local function setField(tbl, key, value)
    tbl[key] = value
end

local function currentDB(subsection)
    if subsection then
        FC.db[subsection] = FC.db[subsection] or {}
        return FC.db[subsection]
    end
    return FC.db
end

local function bind(subsection, key)
    return function()
        local t = currentDB(subsection)
        return t[key]
    end, function(v)
        local t = currentDB(subsection)
        t[key] = v
        if subsection == "procAlerts" and (key == "scale" or key == "x" or key == "y" or key == "iconSize" or key == "textSize") and FC.ApplyProcAlertLayout then
            FC:ApplyProcAlertLayout()
        elseif key == "scale" and FC.ApplyPosition then
            FC:ApplyPosition()
        end
        if key == "bubbleScale" and FC.ReanchorBubble then FC:ReanchorBubble() end
        if key == "fontScale" and FC.bubble and FC.bubble:IsShown() and FC.bubbleText then
            local currentText = FC.bubbleText:GetText()
            if currentText and currentText ~= "" then FC:ShowBubble(currentText) end
        end
    end
end

local function bindBool(subsection, key, callback)
    return function()
        local t = currentDB(subsection)
        return t[key] and true or false
    end, function(v)
        local t = currentDB(subsection)
        t[key] = v and true or false
        if callback then callback(v and true or false) end
    end
end

function FC:CreateSettings()
    if self.settings then return self.settings end

    local frame = CreateFrame("Frame", "ForeverCompanionSettingsV2", UIParent)
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

    local banner = frame:CreateTexture(nil, "ARTWORK")
    banner:SetPoint("TOP", 0, -12)
    banner:SetSize(500, 166)
    banner:SetTexture(ART_BANNER)

    local title = label(frame, "FOREVER COMPANION", 22, { 1, 0.84, 1 })
    title:SetPoint("TOP", 0, -27)
    title:SetJustifyH("CENTER")

    local subtitle = label(frame, "Control Center  •  v" .. tostring(self.version), 11, { 0.86, 0.83, 0.95 })
    subtitle:SetPoint("TOP", 0, -57)
    subtitle:SetJustifyH("CENTER")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -12, -10)

    local nav = CreateFrame("Frame", nil, frame)
    nav:SetPoint("TOPLEFT", 42, -108)
    nav:SetSize(190, 610)

    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 272, -112)
    content:SetSize(700, 610)

    -- The active page identity belongs to the ornate center banner, not the content canvas.
    -- Keeping it on the root frame also guarantees every category is centered on the art,
    -- regardless of the wider right-hand content panel.
    local pageTitle = label(frame, "", 18, { 1, 0.84, 0.24 })
    pageTitle:SetWidth(360)
    pageTitle:SetPoint("TOP", frame, "TOP", 0, -88)
    pageTitle:SetJustifyH("CENTER")
    pageTitle:SetJustifyV("MIDDLE")
    pageTitle:SetShadowOffset(0, 0)
    pageTitle:SetShadowColor(0.56, 0.16, 0.78, 0.95)
    self.settingsV2Title = pageTitle

    local pageDesc = label(frame, "", 10, { 0.84, 0.84, 0.96 })
    pageDesc:SetWidth(480)
    pageDesc:SetPoint("TOP", pageTitle, "BOTTOM", 0, -7)
    pageDesc:SetJustifyH("CENTER")
    pageDesc:SetJustifyV("TOP")
    pageDesc:SetWordWrap(true)
    pageDesc:SetShadowOffset(1, -1)
    pageDesc:SetShadowColor(0, 0, 0, 0.95)
    self.settingsV2Desc = pageDesc

    local headerRule = frame:CreateTexture(nil, "ARTWORK")
    headerRule:SetTexture("Interface/Buttons/WHITE8X8")
    headerRule:SetVertexColor(0.57, 0.30, 0.76, 0.38)
    headerRule:SetSize(300, 1)
    headerRule:SetPoint("TOP", frame, "TOP", 0, -134)
    self.settingsV2HeaderRule = headerRule

    self.settingsPages = {}
    self.settingsPageChildren = {}
    self.tabButtons = {}
    self.settingsBuildErrors = {}

    for i, name in ipairs(TABS) do
        local b = createButton(nav, name, 178, 33, function() FC:ShowSettingsTab(name) end)
        b:SetPoint("TOPLEFT", 6, -4 - (i - 1) * 45)
        self.tabButtons[name] = b

        local host = CreateFrame("Frame", nil, content)
        host:SetPoint("TOPLEFT", 18, -88)
        host:SetPoint("BOTTOMRIGHT", -18, 18)
        host.defaultTopOffset = -88
        host:Hide()

        local scroll = CreateFrame("ScrollFrame", nil, host, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 0, 0)
        scroll:SetPoint("BOTTOMRIGHT", -26, 0)

        local child = CreateFrame("Frame", nil, scroll)
        child:SetWidth(620)
        child:SetHeight(520)
        scroll:SetScrollChild(child)

        self.settingsPages[name] = host
        self.settingsPageChildren[name] = child
    end

    local builders = {
        Companion = "BuildCompanionPage",
        Personality = "BuildPersonalityPage",
        Commentary = "BuildCommentaryPage",
        ["Combat Calls"] = "BuildProcAlertsPage",
        Dungeons = "BuildDungeonPage",
        Intelligence = "BuildIntelligencePage",
        Characters = "BuildCharactersPage",
        Conversation = "BuildConversationPage",
        ["Gold Farming"] = "BuildGoldPage",
        Appearance = "BuildAppearancePage",
        Memory = "BuildMemoryPage",
        ["Test Lab"] = "BuildTestLabPage",
        Advanced = "BuildAdvancedPage",
    }

    for name, methodName in pairs(builders) do
        local child = self.settingsPageChildren[name]
        local method = self[methodName]
        local ok, err = pcall(method, self, child)
        if not ok then
            self.settingsBuildErrors[name] = tostring(err)
            local l = Layout.new(child)
            local fs = l:textCard("Page error", function() return tostring(err) end, 180)
            if fs then fs:SetTextColor(1, 0.42, 0.45) end
            l:finish()
        end
    end

    self.settings = frame
    self:ShowSettingsTab((self.db.ui and self.db.ui.lastTab) or "Companion")
    if self.RegisterNativeSettings then self:RegisterNativeSettings() end
    frame:Hide()
    return frame
end

local function pageTitleFontSize(text)
    local n = string.len(tostring(text or ""))
    if n >= 19 then return 15 end
    if n >= 15 then return 16 end
    if n >= 12 then return 17 end
    return 18
end

local function updatePageHeaderLayout(self, activeHost)
    if not self or not self.settingsV2Title or not self.settingsV2Desc then return end

    local titleText = self.settingsV2Title:GetText() or ""
    local desc = self.settingsV2Desc:GetText() or ""
    local titleSize = pageTitleFontSize(titleText)
    setFont(self.settingsV2Title, titleSize, true)
    self.settingsV2Title:SetShadowOffset(0, 0)
    self.settingsV2Title:SetShadowColor(0.56, 0.16, 0.78, 0.95)

    if desc ~= "" then
        self.settingsV2Desc:Show()
    else
        self.settingsV2Desc:Hide()
    end

    -- Keep the actual settings cards visually separated from the banner header.
    local host = activeHost
    if not host and self.settingsPages and self.db and self.db.ui and self.db.ui.lastTab then
        host = self.settingsPages[self.db.ui.lastTab]
    end
    if not host then return end

    local descHeight = 12
    if desc ~= "" and self.settingsV2Desc.GetStringHeight then
        descHeight = math.max(12, math.floor((self.settingsV2Desc:GetStringHeight() or 0) + 0.5))
    end

    local baseTop = host.defaultTopOffset or -88
    local extra = math.max(0, descHeight - 14)
    host:ClearAllPoints()
    host:SetPoint("TOPLEFT", 18, baseTop - extra)
    host:SetPoint("BOTTOMRIGHT", -18, 18)
end

function FC:ShowSettingsTab(name)
    if not self.settingsPages then return end
    if not self.settingsPages[name] then name = "Companion" end

    for pageName, host in pairs(self.settingsPages) do
        host:SetShown(pageName == name)
    end
    for pageName, b in pairs(self.tabButtons or {}) do
        selectButton(b, pageName == name)
    end

    local meta = PAGE_META[name] or { name, "" }
    if self.settingsV2Title then self.settingsV2Title:SetText(meta[1]) end
    if self.settingsV2Desc then self.settingsV2Desc:SetText(meta[2]) end
    self.db.ui.lastTab = name
    updatePageHeaderLayout(self, self.settingsPages[name])

    if name == "Combat Calls" and self.RefreshProcAlertsPage then self:RefreshProcAlertsPage()
    elseif name == "Dungeons" and self.RefreshDungeonPage then self:RefreshDungeonPage()
    elseif name == "Intelligence" then self:RefreshIntelligence()
    elseif name == "Characters" then self:RefreshCharactersPage()
    elseif name == "Conversation" then self:RefreshConversationPage()
    elseif name == "Gold Farming" then self:RefreshGoldPage()
    elseif name == "Memory" then self:RefreshJournal()
    elseif name == "Appearance" then self:RefreshAppearanceStatus()
    elseif name == "Test Lab" and self.testLabOutput then
        self.testLabOutput:SetText("Choose a scenario below. Test output stays in this page instead of overlapping other controls.")
    end
end

function FC:OpenSettings(tab)
    if not self.settings then
        local ok = self:Call("CreateSettings")
        if not ok then return end
    end
    self.settings:Show()
    self:ShowSettingsTab(tab or (self.db.ui and self.db.ui.lastTab) or "Companion")
end

function FC:ToggleSettings()
    if not self.settings then
        self:OpenSettings("Companion")
        return
    end
    if self.settings:IsShown() then self.settings:Hide() else self:OpenSettings() end
end

function FC:BuildCompanionPage(page)
    local l = Layout.new(page)
    l:buttonRow("Presentation", {
        { "Full", function() self:SetMode("full") end },
        { "Desktop", function() self:SetMode("desktop") end },
        { "Portrait", function() self:SetMode("portrait") end },
    }, "Vexa is the only active companion until additional characters are fully built.")

    local g1, s1 = bind(nil, "scale")
    local g2, s2 = bind("appearance", "motion")
    l:sliderPair("Companion", { "Companion scale", g1, s1, 0.65, 1.60, 0.05 }, { "Idle motion", g2, s2, 0, 0.35, 0.01 })

    local gb, sb = bind("appearance", "bubbleScale")
    local gf, sf = bind("appearance", "fontScale")
    l:sliderPair("Speech", { "Bubble size", gb, sb, 0.70, 1.30, 0.05 }, { "Font size", gf, sf, 0.80, 1.25, 0.05 })

    local gh, sh = bind("appearance", "minMessageHold")
    l:sliderPair("Message pacing", { "Minimum message hold (sec)", gh, sh, 1.50, 5.00, 0.25 })

    local gl, sl = bindBool("ui", "locked")
    local gs, ss = bindBool(nil, "bubble")
    l:toggleGrid("Behavior", "Keep the companion unobtrusive and readable.", {
        { "Lock Vexa in place", gl, sl },
        { "Show speech bubbles", gs, ss },
    })
    l:finish()
end

function FC:BuildPersonalityPage(page)
    local l = Layout.new(page)
    local gh, sh = bind("personality", "helpful")
    local gs, ss = bind("personality", "smartass")
    local gf, sf = bind("personality", "flirty")
    local gc, sc = bind("personality", "chaotic")
    local gr, sr = bind("personality", "roast")
    local gt, st = bind(nil, "chatty")
    l:sliderPair("Tone", { "Helpful", gh, sh, 0, 1, 0.05 }, { "Smartass", gs, ss, 0, 1, 0.05 })
    l:sliderPair("Attitude", { "Flirty", gf, sf, 0, 1, 0.05 }, { "Chaotic", gc, sc, 0, 1, 0.05 })
    l:sliderPair("Energy", { "Roast me", gr, sr, 0, 1, 0.05 }, { "Talk frequency", gt, st, 0.05, 1, 0.05 })
    l:finish()
end

function FC:BuildCommentaryPage(page)
    local l = Layout.new(page)
    local specs = {
        { "XP & leveling", "xp" }, { "Quests", "quests" },
        { "Combat", "combat" }, { "World & travel", "world" },
        { "Loot & gear", "loot" }, { "Tips", "tips" },
        { "Jokes", "jokes" },
    }
    for i = 1, #specs, 2 do
        local a = specs[i]
        local b = specs[i + 1]
        local ga, sa = bind("commentary", a[2])
        local right = nil
        if b then
            local gb, sb = bind("commentary", b[2])
            right = { b[1], gb, sb, 0, 1, 0.05 }
        end
        l:sliderPair(i == 1 and "Gameplay priorities" or "", { a[1], ga, sa, 0, 1, 0.05 }, right)
    end
    l:textCard("Fine control", function()
        return "/fc mute <category> and /fc unmute <category>\nCategories: ambient, xp, quests, combat, world, loot, group, target, class, social, memory."
    end, 100)
    l:finish()
end

function FC:BuildProcAlertsPage(page)
    local l = Layout.new(page)

    local ge, se = bindBool("procAlerts", "enabled")
    local gs, ss = bindBool("procAlerts", "screenEffect")
    local gv, sv = bindBool("procAlerts", "vexaShout")
    local gso, sso = bindBool("procAlerts", "sound")
    local gvoice, svoice = bindBool("procAlerts", "voiceEnabled")
    local gres, sres = bindBool("procAlerts", "respectGameSound")
    local gpack, spack = bindBool("procAlerts", "customVoicePack")
    local gtts, stts = bindBool("procAlerts", "ttsFallback")
    local gvpack, svpack = bindBool("voicePack", "enabled")
    local gevents, sevents = bindBool("voicePack", "eventVoices")
    local ghda, shda = bindBool("procAlerts", "hdArt")
    local ga, sa = bindBool("procAlerts", "anyOverlay")
    local gf, sf = bindBool("procAlerts", "fallbackDetection")
    local gc, sc = bindBool("procAlerts", "onlyInCombat")

    l:toggleGrid("Callouts", "Combat audio uses one cue at a time: Vexa voice first, optional TTS second, and the generic alert only when no voice can play.", {
        { "Enable combat callouts", ge, se },
        { "Show screen effect", gs, ss },
        { "Vexa speech bubble shout", gv, sv },
        { "Fallback alert when no voice plays", gso, sso },
        { "Speak proc name aloud", gvoice, svoice },
        { "Respect WoW sound settings", gres, sres },
        { "Prefer custom Vexa proc clips", gpack, spack },
        { "Allow TTS if custom proc clip is missing", gtts, stts },
        { "Enable Vexa voice pack", gvpack, svpack },
        { "Play event/reaction voice clips", gevents, sevents },
        { "Use HD proc artwork", ghda, shda },
        { "Announce any client overlay proc", ga, sa },
        { "Fallback proc detection", gf, sf },
        { "Only announce in combat", gc, sc },
    })

    local gscale, sscale = bind("procAlerts", "scale")
    local gdur, sdur = bind("procAlerts", "duration")
    l:sliderPair("Alert size & timing", { "Overall scale", gscale, sscale, 0.45, 1.60, 0.05 }, { "Duration (sec)", gdur, sdur, 0.60, 3.00, 0.05 })

    local gx, sx = bind("procAlerts", "x")
    local gy, sy = bind("procAlerts", "y")
    l:sliderPair("Alert position", { "Horizontal X", gx, sx, -800, 800, 10 }, { "Vertical Y", gy, sy, -500, 500, 10 })

    local gi, si = bind("procAlerts", "iconSize")
    local gt, st = bind("procAlerts", "textSize")
    l:sliderPair("Alert contents", { "Spell icon size", gi, si, 28, 90, 2 }, { "Text size", gt, st, 16, 46, 1 })

    local gart, sart = bind("procAlerts", "artSize")
    l:sliderPair("HD proc artwork", { "Artwork width", gart, sart, 180, 520, 10 }, nil)

    local gvr, svr = bind("procAlerts", "voiceRate")
    local gvv, svv = bind("procAlerts", "voiceVolume")
    l:sliderPair("Spoken callout", { "Voice rate", gvr, svr, -5, 5, 1 }, { "Voice volume", gvv, svv, 10, 100, 5 })

    l:buttonRow("Placement & voice", {
        { "Unlock & move", function() self:SetProcAlertMoveMode(true) end },
        { "Lock alert", function() self:SetProcAlertMoveMode(false) end },
        { "Reset position", function() self:ResetProcAlertPosition() end },
        { "Test alert", function() self:TestProcAlert() end },
        { "Previous voice", function() self:CycleProcVoice(-1); self:TestProcVoice(); self:RefreshProcAlertsPage() end },
        { "Test voice", function() self:TestProcVoice() end },
        { "Next voice", function() self:CycleProcVoice(1); self:TestProcVoice(); self:RefreshProcAlertsPage() end },
        { "Test interrupt clip", function() self:TestVexaVoiceCue("interrupt") end },
        { "Test death clip", function() self:TestVexaVoiceCue("sarcastic_death") end },
        { "Voice-pack doctor", function() self:VoicePackDoctor() end },
        { "Proc doctor", function() self:ProcDoctor() end },
    }, "Unlock & move shows a draggable preview. The selected TTS voice depends on the voices installed/exposed by your WoW client and operating system.")

    local card, top = l:section("Current class callouts", "Class-specific triggers plus live voice/UI status.", 275)
    self.procClassText = label(card, "", 12, { 0.94, 0.94, 0.99 })
    self.procClassText:SetPoint("TOPLEFT", 18, top - 2)
    self.procClassText:SetPoint("BOTTOMRIGHT", -18, 54)
    self.procClassText:SetJustifyH("LEFT")
    self.procClassText:SetJustifyV("TOP")
    self.procClassText:SetWordWrap(true)

    local test = createButton(card, "Test Overpower", 150, 30, function() self:TestProcAlert("Overpower") end)
    test:SetPoint("BOTTOMLEFT", 18, 14)
    local list = createButton(card, "Print class list", 150, 30, function()
        self:Debug("Proc callouts for current class:")
        for line in string.gmatch(self:GetProcCatalogText(), "[^\n]+") do self:Debug(line) end
    end)
    list:SetPoint("BOTTOMLEFT", 184, 14)

    l:textCard("Voice pack", function()
        return "The complete Jessica Vexa library includes 607 prerecorded clips: 41 core event/reaction clips, 59 combat proc clips, and 507 personality-expansion clips across 60 categories. Personality clips live in Media/Voice/Vexa/Personality and keep their exact recorded text synced to the speech bubble. Use /fc voicepack doctor for status, /fc voicepack personalitylist for categories, /fc voicepack personality <category> to test expansion audio, or /fc proc test <spell> for proc clips."
    end, 150)

    local geventcd, seventcd = bind("voicePack", "globalCooldown")
    l:sliderPair("Event voice pacing", { "Minimum gap between event clips", geventcd, seventcd, 1.0, 10.0, 0.5 }, nil)

    local gcd, scd = bind("procAlerts", "cooldown")
    local gpoll, spoll = bind("procAlerts", "pollInterval")
    l:sliderPair("Detection", { "Same-proc cooldown", gcd, scd, 0.50, 5.00, 0.25 }, { "Fallback poll (sec)", gpoll, spoll, 0.10, 0.50, 0.05 })

    l:finish()
end

function FC:RefreshProcAlertsPage()
    if not self.procClassText then return end
    local className, token = nil, nil
    if type(UnitClass) == "function" then
        local ok, a, b = pcall(UnitClass, "player")
        if ok then className, token = a, b end
    end
    className = className or token or "Current class"
    local last = self.state and self.state.lastProcAlert
    local lastLine = "None yet this session."
    if last then
        lastLine = tostring(last.spell or "proc") .. " — " .. tostring(last.shout or "") .. " (" .. tostring(last.source or "proc") .. ")"
    end
    local voiceID, voiceName, voices = self:GetProcVoice()
    local cfg = self.db and self.db.procAlerts or {}
    self.procClassText:SetText(
        "|cffffd36a" .. tostring(className) .. "|r\n" .. self:GetProcCatalogText(token) ..
        "\n\n|cffb9b9d8Voice:|r " .. tostring(voiceName or voiceID or "No client TTS voice detected") ..
        "  |cff777799(" .. tostring(#(voices or {})) .. " installed)|r" ..
        "\n|cffb9b9d8Position:|r X " .. tostring(math.floor(tonumber(cfg.x) or 0)) .. " / Y " .. tostring(math.floor(tonumber(cfg.y) or 140)) ..
        "  |cffb9b9d8Scale:|r " .. string.format("%.2f", tonumber(cfg.scale) or 1) ..
        "\n|cffb9b9d8Audio respects game:|r " .. tostring(cfg.respectGameSound ~= false and "yes" or "no") ..
        "  |cffb9b9d8Proc voice:|r " .. tostring(cfg.customVoicePack == true and (cfg.ttsFallback == false and "custom only" or "custom + TTS fallback") or "TTS") ..
        "  |cffb9b9d8Alert SFX:|r " .. tostring(cfg.sound ~= false and "fallback only" or "off") ..
        "  |cffb9b9d8Event voice:|r " .. tostring(self.db.voicePack and self.db.voicePack.eventVoices ~= false and "on" or "off") ..
        "  |cffb9b9d8HD art:|r " .. tostring(cfg.hdArt == true and "on" or "off") ..
        "\n|cffb9b9d8Last callout:|r " .. lastLine
    )
end

function FC:BuildDungeonPage(page)
    local l = Layout.new(page)

    local ge, se = bindBool("dungeon", "enabled")
    local gq, sq = bindBool("dungeon", "suppressQuestReminders")
    local gl, sl = bindBool("dungeon", "lootWatch")
    local gb, sb = bindBool("dungeon", "bossChatter")
    local gc, sc = bindBool("dungeon", "chatter")
    l:toggleGrid("Dungeon mode", "While inside a party or raid instance, Vexa changes priorities instead of behaving like you are still questing in the open world.", {
        { "Enable dungeon intelligence", ge, se },
        { "Suppress turn-in/town reminders", gq, sq },
        { "Class/spec loot watch", gl, sl },
        { "Boss progress chatter", gb, sb },
        { "Dungeon ambient chatter", gc, sc },
    })

    local gn, sn = bind("dungeon", "lootCount")
    local countCard, ctop = l:section("Loot watch depth", "How many class-compatible drops Vexa should keep on the short list.", 108)
    local lootSlider = createSlider(countCard, "Items to watch", gn, sn, 1, 6, 1, function(v) return tostring(math.floor(v + 0.5)) end)
    lootSlider:SetPoint("TOPLEFT", 16, ctop - 4)

    local status, stop = l:section("Current instance", nil, 190)
    self.dungeonStatusText = label(status, "Not currently in a dungeon.", 12, { 0.93, 0.93, 0.99 })
    self.dungeonStatusText:SetPoint("TOPLEFT", 18, stop - 2)
    self.dungeonStatusText:SetPoint("BOTTOMRIGHT", -18, 18)
    self.dungeonStatusText:SetWordWrap(true)

    local lootCard, ltop = l:section("Loot worth watching", "Vexa only recommends drops she can justify from the encounter journal and current class/spec/equipment data.", 238)
    self.dungeonLootText = label(lootCard, "No active loot watch.", 12, { 0.95, 0.90, 0.72 })
    self.dungeonLootText:SetPoint("TOPLEFT", 18, ltop - 2)
    self.dungeonLootText:SetPoint("BOTTOMRIGHT", -18, 18)
    self.dungeonLootText:SetWordWrap(true)

    l:buttonRow("Dungeon actions", {
        { "Refresh intel", function() self:ScanDungeonLoot(true); self:RefreshDungeonPage() end },
        { "Tell me the run", function() self:ShowDungeonIntel() end },
        { "Loot watch", function() self:ShowDungeonLootWatch() end },
        { "Debug source", function() self:DungeonDiagnostics() end },
    })
    l:finish()
end

function FC:BuildIntelligencePage(page)
    local l = Layout.new(page)
    local card, top = l:section("Live knowledge", "This is what Vexa currently believes about your character and progression.", 410)
    self.intelText = label(card, "", 12, { 0.93, 0.93, 0.99 })
    self.intelText:SetPoint("TOPLEFT", 18, top - 4)
    self.intelText:SetPoint("BOTTOMRIGHT", -18, 52)
    self.intelText:SetJustifyH("LEFT")
    self.intelText:SetJustifyV("TOP")
    self.intelText:SetWordWrap(true)
    local b = createButton(card, "Refresh profile", 150, 30, function() self:RunCatchup(true); self:RefreshIntelligence() end)
    b:SetPoint("BOTTOMLEFT", 18, 14)
    l:finish()
end

function FC:BuildCharactersPage(page)
    local l = Layout.new(page)
    local card, top = l:section("Remembered characters", "Each character keeps separate progression memory while Vexa remembers your roster.", 420)
    self.charactersText = label(card, "", 12, { 0.93, 0.93, 0.99 })
    self.charactersText:SetPoint("TOPLEFT", 18, top - 4)
    self.charactersText:SetPoint("BOTTOMRIGHT", -18, 62)
    self.charactersText:SetJustifyH("LEFT")
    self.charactersText:SetJustifyV("TOP")
    self.charactersText:SetWordWrap(true)
    local actions = {
        { "Refresh roster", function() self:RefreshCharactersPage() end },
        { "Profile scan", function() self:RunCatchup(true); self:RefreshCharactersPage() end },
        { "Last session", function() self:ShowLastSession() end },
    }
    for i, info in ipairs(actions) do
        local b = createButton(card, info[1], 150, 30, info[2])
        b:SetPoint("BOTTOMLEFT", 18 + (i - 1) * 164, 16)
    end
    l:finish()
end

function FC:BuildConversationPage(page)
    local l = Layout.new(page)
    local gf, sf = bind("conversation", "frequency")
    local freqCard, top = l:section("Ambient conversation", nil, 108)
    local slider = createSlider(freqCard, "Conversation frequency", gf, sf, 0.10, 1.00, 0.05)
    slider:SetPoint("TOPLEFT", 16, top - 4)

    local toggles = {}
    local names = {
        { "Ambient conversations", "enabled" }, { "Walking chatter", "walking" },
        { "WoW trivia", "facts" }, { "Jokes & banter", "jokes" },
        { "Famous quotes", "quotes" }, { "Riddles + delayed answers", "riddles" },
        { "Questions / would-you-rather", "questions" }, { "Science + history facts", "strangeFacts" },
        { "Mini challenges", "challenges" }, { "Deep thoughts", "deepThoughts" },
        { "Class-specific chatter", "classBanter" }, { "Cross-character callbacks", "memoryBanter" },
        { "Vocabulary builder", "vocabulary" }, { "Vocabulary quizzes", "vocabQuizzes" },
        { "Word roots", "wordRoots" }, { "General trivia", "trivia" },
        { "Idioms / proverbs / wordplay", "languagePlay" }, { "Expanded knowledge library", "expandedFacts" },
        { "Creative prompts / stories", "creativePrompts" }, { "Self-aware banter", "metaBanter" },
        { "Compliments", "compliments" }, { "Roasts", "roasts" },
    }
    for _, spec in ipairs(names) do
        local g, s = bindBool("conversation", spec[2])
        toggles[#toggles + 1] = { spec[1], g, s }
    end
    l:toggleGrid("Topics", nil, toggles)

    local vocabCard = l:section("Vocabulary", nil, 74)
    self.vocabularyText = label(vocabCard, "", 11, { 0.95, 0.83, 0.95 })
    self.vocabularyText:SetPoint("TOPLEFT", 16, -44)
    self.vocabularyText:SetPoint("TOPRIGHT", -16, -44)
    self.vocabularyText:SetWordWrap(true)

    self.conversationText, self.conversationTextChild = l:scrollTextCard("Recent conversation", 290, 548)

    l:buttonRow("Conversation actions", {
        { "Tell me something", function() self:ForceConversation() end },
        { "Quote", function() self:TellQuote() end },
        { "Riddle", function() self:TellRiddle() end },
        { "Answer riddle", function() self:AnswerRiddle(true) end },
        { "Question", function() self:TellQuestion() end },
        { "Strange fact", function() self:TellStrangeFact() end },
        { "Word", function() self:TellVocabularyWord(nil) end },
        { "Vocab quiz", function() self:StartVocabularyQuiz(true) end },
        { "Word root", function() self:TellWordRoot() end },
        { "Trivia", function() self:TellTrivia() end },
        { "Story", function() self:QueueTopic("microstory", {}, 100, 0, true) end },
        { "Repeat last", function() self:RepeatLastStatement() end },
        { "Why last?", function() self:WhyLastStatement() end },
        { "Block last", function() self:BlockLastStatement() end },
        { "Refresh", function() self:RefreshConversationPage() end },
    })
    l:finish()
end

function FC:BuildGoldPage(page)
    local l = Layout.new(page)
    local card, top = l:section("Current farm", "Auctionator pricing and guaranteed vendor floor stay separate.", 238)
    self.goldStatusText = label(card, "", 12, { 0.93, 0.93, 0.99 })
    self.goldStatusText:SetPoint("TOPLEFT", 18, top - 4)
    self.goldStatusText:SetPoint("BOTTOMRIGHT", -18, 18)
    self.goldStatusText:SetJustifyH("LEFT")
    self.goldStatusText:SetJustifyV("TOP")
    self.goldStatusText:SetWordWrap(true)

    l:buttonRow("Farm actions", {
        { "Start / Stop", function() self:ToggleGoldFarm(); self:RefreshGoldPage() end },
        { "Reset", function() self:ResetGoldFarm(); self:RefreshGoldPage() end },
        { "Tell pace", function() self:ShowGoldFarmStats() end },
        { "Refresh AH", function() self:RefreshGoldIntegration(); self:RevalueGoldSession(); self:RefreshGoldPage() end },
    })

    local gu, su = bindBool("goldFarming", "useAuctionator", function() self:RefreshGoldIntegration() end)
    local gc, sc = bindBool("goldFarming", "commentary")
    l:toggleGrid("Gold intelligence", nil, {
        { "Use Auctionator scan data", gu, su },
        { "Comment on valuable drops", gc, sc },
    })

    local gv, sv = bind("goldFarming", "valuableGold")
    local gp, sp = bind("goldFarming", "paceMinutes")
    l:sliderPair("Thresholds", { "Valuable drop (gold)", gv, sv, 0.25, 25, 0.25 }, { "Pace check (minutes)", gp, sp, 1, 15, 1 })
    l:finish()
end

function FC:BuildAppearancePage(page)
    local l = Layout.new(page)
    l:buttonRow("Renderer", {
        { "Use Vexa art", function() self.db.appearance.renderer = "sprite"; ReloadUI() end },
        { "Use 3D model", function() self.db.appearance.renderer = "model"; ReloadUI() end },
    }, "Vexa's bundled HD state art is the default. 3D mode is optional and experimental.")

    local card, top = l:section("Renderer status", nil, 98)
    self.rendererText = label(card, "", 12, { 0.93, 0.93, 0.99 })
    self.rendererText:SetPoint("TOPLEFT", 18, top - 2)
    self.rendererText:SetPoint("TOPRIGHT", -18, top - 2)
    self.rendererText:SetWordWrap(true)

    local model, mtop = l:section("3D model lab", "Only used when 3D model mode is enabled.", 138)
    local edit = CreateFrame("EditBox", nil, model, "InputBoxTemplate")
    self.displayEdit = edit
    edit:SetSize(190, 28)
    edit:SetPoint("TOPLEFT", 18, mtop - 6)
    edit:SetAutoFocus(false)
    edit:SetText(self.db.appearance.displayID and tostring(self.db.appearance.displayID) or "")
    local a = createButton(model, "Apply model", 130, 30, function()
        self.db.appearance.renderer = "model"
        self.db.appearance.displayID = tonumber(edit:GetText())
        self:ApplyModelLab(); self:RefreshAppearanceStatus()
    end)
    a:SetPoint("TOPLEFT", 230, mtop - 6)
    local u = createButton(model, "Use my character", 150, 30, function()
        self.db.appearance.renderer = "model"
        self.db.appearance.displayID = nil
        edit:SetText("")
        self:ApplyModelLab(); self:RefreshAppearanceStatus()
    end)
    u:SetPoint("TOPLEFT", 376, mtop - 6)

    local animations = { "idle", "talk", "celebrate", "think", "point", "laugh", "flirty", "playful", "worried", "angry", "magic", "combat" }
    local buttons = {}
    for _, animation in ipairs(animations) do
        buttons[#buttons + 1] = { animation, function() self:SetAnimation(animation) end }
    end
    l:buttonRow("Reaction test", buttons)

    local gm, sm = bind("appearance", "modelScale")
    local gr, sr = bind("appearance", "rotation")
    l:sliderPair("3D tuning", { "Model scale", gm, sm, 0.5, 2, 0.05 }, { "Rotation", gr, sr, 0, 6.28, 0.05 })
    l:buttonRow("Camera", { { "Apply camera", function() self:ApplyModelLab() end } })
    l:finish()
end

function FC:BuildMemoryPage(page)
    local l = Layout.new(page)
    self.journalText, self.journalTextChild = l:scrollTextCard("Memory journal", 390, 548)
    l:buttonRow("Memory actions", {
        { "Refresh", function() self:RefreshJournal() end },
        { "Export", function() self:OpenMemoryTransfer("export") end },
        { "Import", function() self:OpenMemoryTransfer("import") end },
        { "Last session", function() self:ShowLastSession() end },
    })
    l:finish()
end

function FC:BuildTestLabPage(page)
    local l = Layout.new(page)
    local tests = {
        { "98% XP", "xp98" }, { "Death", "death" }, { "Elite target", "elite" }, { "Rare/Epic loot", "loot" },
        { "Bags warning", "bags" }, { "Boss kill", "boss" }, { "Class resource", "class" }, { "Bubble wrapping", "bubble" },
        { "Proc callout", "proc" }, { "Dungeon mode", "dungeon" },
    }
    local buttons = {}
    for _, t in ipairs(tests) do buttons[#buttons + 1] = { t[1], function() self:TestScenario(t[2]) end } end
    l:buttonRow("Scenarios", buttons, "These simulations validate specific reactions without waiting for them to occur naturally.")

    l:buttonRow("Diagnostics", {
        { "Full QA suite", function()
            local ok = self:RunTestSuite()
            if self.testLabOutput then self.testLabOutput:SetText(ok and "All internal checks passed." or "One or more checks failed. See chat.") end
        end },
        { "Run Doctor", function()
            local ok = self:RunDoctor()
            if self.testLabOutput then self.testLabOutput:SetText(ok and "Doctor passed." or "Doctor found a problem. See chat.") end
        end },
    })

    local card, top = l:section("Output", nil, 150)
    self.testLabOutput = label(card, "Choose a scenario above.", 12, { 0.93, 0.93, 0.99 })
    self.testLabOutput:SetPoint("TOPLEFT", 18, top - 2)
    self.testLabOutput:SetPoint("BOTTOMRIGHT", -18, 18)
    self.testLabOutput:SetWordWrap(true)
    l:finish()
end

function FC:BuildAdvancedPage(page)
    local l = Layout.new(page)
    local ge, se = bindBool(nil, "enabled")
    local gd, sd = bindBool(nil, "debug")
    local gl, sl = bindBool("ui", "locked")
    local gm = function() return not (self.db.minimap and self.db.minimap.hide) end
    local sm = function(v) self:SetMinimapButtonShown(v) end
    l:toggleGrid("Addon", nil, {
        { "Enable addon", ge, se }, { "Debug output", gd, sd },
        { "Lock companion", gl, sl }, { "Show minimap button", gm, sm },
    })

    local card, top = l:section("Compatibility", nil, 180)
    self.capText = label(card, "Run a scan to inspect the current client and integration state.", 11, { 0.93, 0.93, 0.99 })
    self.capText:SetPoint("TOPLEFT", 18, top - 2)
    self.capText:SetPoint("BOTTOMRIGHT", -18, 18)
    self.capText:SetWordWrap(true)

    local reportCard, reportTop = l:section("Vexa Learning Report", "Background observation stays hidden during play. Open this only when you want to copy a report for improving Vexa.", 112)
    self.learningReportSettingsText = label(reportCard, "Report observations are available in the background.", 11, { 0.93, 0.93, 0.99 })
    self.learningReportSettingsText:SetPoint("TOPLEFT", 18, reportTop - 4)
    self.learningReportSettingsText:SetPoint("RIGHT", -18, 0)
    local reportButton = CreateFrame("Button", nil, reportCard, "UIPanelButtonTemplate")
    reportButton:SetSize(150, 24)
    reportButton:SetPoint("BOTTOMLEFT", 18, 14)
    reportButton:SetText("Open Vexa Report")
    reportButton:SetScript("OnClick", function() self:OpenLearningReport() end)

    local function refreshReportSettingsCount()
        if not self.learningReportSettingsText then return end
        local n = self.state and self.state.learningLab and tonumber(self.state.learningLab.badgeCount) or 0
        if n > 0 then
            self.learningReportSettingsText:SetText(tostring(n) .. " report-worthy observation" .. (n == 1 and "" or "s") .. " logged. Nothing is shown beside Vexa during gameplay.")
        else
            self.learningReportSettingsText:SetText("No new report-worthy observations. Background learning is still running quietly.")
        end
    end
    reportButton:SetScript("OnShow", refreshReportSettingsCount)
    refreshReportSettingsCount()

    l:buttonRow("Diagnostics", {
        { "Compatibility", function()
            self:DetectCapabilities()
            local lines = {}
            for key, value in pairs(self.state.capabilities) do lines[#lines + 1] = key .. ": " .. tostring(value) end
            table.sort(lines)
            self.capText:SetText(table.concat(lines, "   •   "))
        end },
        { "Run Doctor", function() self:RunDoctor() end },
        { "Why last?", function() self:WhyLastStatement() end },
        { "Integration scan", function() self.capText:SetText(self:IntegrationSummary()) end },
        { "Full tests", function() self:RunTestSuite() end },
        { "Profile scan", function() self:RunCatchup(true) end },
        { "Reset position", function() self.db.x = 360; self.db.y = 180; self:ApplyPosition() end },
        { "Print version", function() self:PrintVersion() end },
    })
    l:finish()
end

-- Keep refresh functions compatible with the new scrollable text regions.
local oldRefreshConversationPage = FC.RefreshConversationPage
function FC:RefreshConversationPage()
    if oldRefreshConversationPage then oldRefreshConversationPage(self) end
    if self.conversationText and self.conversationTextChild then
        self.conversationTextChild:SetHeight(math.max(300, self.conversationText:GetStringHeight() + 28))
    end
end

local oldRefreshJournal = FC.RefreshJournal
function FC:RefreshJournal()
    if oldRefreshJournal then oldRefreshJournal(self) end
    if self.journalText and self.journalTextChild then
        self.journalTextChild:SetHeight(math.max(300, self.journalText:GetStringHeight() + 28))
    end
end
