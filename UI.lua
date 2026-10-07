local FC = _G.ForeverCompanion

local function applyComicFont(fontString, size, outline)
    if not fontString or not fontString.SetFont then return end
    local flags = outline and "OUTLINE" or ""
    local ok, result = pcall(fontString.SetFont, fontString, "Fonts\\MORPHEUS.TTF", size, flags)
    if not ok or result == false then
        pcall(fontString.SetFont, fontString, "Fonts\\FRIZQT__.TTF", size, flags)
    end
end

local function applyReadableNameFont(fontString, size)
    if not fontString or not fontString.SetFont then return end
    local ok, result = pcall(fontString.SetFont, fontString, "Fonts\\FRIZQT__.TTF", size, "OUTLINE")
    if not ok or result == false then
        pcall(fontString.SetFont, fontString, "Fonts\\ARIALN.TTF", size, "OUTLINE")
    end
end

function FC:CreateUI()
    if self.frame then return self.frame end

    local frame = CreateFrame("Frame", "ForeverCompanionFrame", UIParent)
    self.frame = frame

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)

    frame:SetScript("OnDragStart", function(f)
        if FC.db and FC.db.ui and not FC.db.ui.locked then f:StartMoving() end
    end)

    frame:SetScript("OnDragStop", function(f)
        f:StopMovingOrSizing()
        local _, _, _, x, y = f:GetPoint()
        if FC.db then
            FC.db.x = x or FC.db.x
            FC.db.y = y or FC.db.y
        end
        if FC.ReanchorBubble then FC:ReanchorBubble() end
    end)

    if frame.EnableMouseWheel then
        frame:EnableMouseWheel(true)
        frame:SetScript("OnMouseWheel", function(_, delta)
            if IsAltKeyDown and IsAltKeyDown() and FC.db then
                FC.db.scale = math.max(0.70, math.min(1.8, (FC.db.scale or 1) + delta * 0.05))
                FC:ApplyPosition()
            end
        end)
    end

    frame:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            FC:ShowCompanionMenu()
        elseif button == "LeftButton" and IsShiftKeyDown and IsShiftKeyDown() then
            FC:ShowStats()
        end
    end)

    self:CreateRenderer(frame)

    local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.nameText = nameText
    nameText:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
    nameText:SetTextColor(1, 0.56, 0.84)
    applyComicFont(nameText, 18, true)

    local miniStats = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.miniStats = miniStats
    miniStats:Hide()

    local bubble = CreateFrame("Frame", "ForeverCompanionSpeechBubble", UIParent)
    self.bubble = bubble
    bubble:SetFrameStrata("DIALOG")
    bubble:SetClampedToScreen(true)
    bubble:EnableMouse(true)
    bubble:SetSize(300, 180)
    bubble:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", -10, -18)
    bubble.pinned = false
    bubble.hovered = false
    bubble:SetScript("OnEnter", function(self) self.hovered = true end)
    bubble:SetScript("OnLeave", function(self) self.hovered = false end)
    bubble:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            self.pinned = not self.pinned
            FC:Debug(self.pinned and "Speech bubble pinned. Right-click it again to unpin." or "Speech bubble unpinned.")
        elseif button == "LeftButton" then
            self.pinned = false
            if FC.CancelBubbleSequence then FC:CancelBubbleSequence() end
            self:Hide()
            FC:SetAnimation("idle")
        end
    end)

    local bubbleBG = bubble:CreateTexture(nil, "BACKGROUND")
    self.bubbleBG = bubbleBG
    bubbleBG:SetAllPoints()
    bubbleBG:SetTexture("Interface/AddOns/ForeverCompanion/Media/SpeechBubble.tga")
    bubbleBG:SetBlendMode("BLEND")

    local bubbleName = bubble:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.bubbleName = bubbleName
    bubbleName:SetJustifyH("LEFT")
    bubbleName:SetTextColor(0.62, 0.18, 0.88)
    if bubbleName.SetShadowOffset then
        bubbleName:SetShadowOffset(1, -1)
        bubbleName:SetShadowColor(0.22, 0.03, 0.34, 0.72)
    end
    applyReadableNameFont(bubbleName, 16)

    local bubbleText = bubble:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.bubbleText = bubbleText
    bubbleText:SetJustifyH("CENTER")
    bubbleText:SetJustifyV("MIDDLE")
    bubbleText:SetTextColor(0.12, 0.08, 0.20)
    if bubbleText.SetWordWrap then bubbleText:SetWordWrap(true) end
    if bubbleText.SetNonSpaceWrap then bubbleText:SetNonSpaceWrap(false) end
    if bubbleText.SetShadowOffset then
        bubbleText:SetShadowOffset(0.5, -0.5)
        bubbleText:SetShadowColor(1, 1, 1, 0.25)
    end
    applyComicFont(bubbleText, 14, false)

    local bubblePage = bubble:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.bubblePage = bubblePage
    bubblePage:SetJustifyH("RIGHT")
    bubblePage:SetTextColor(0.38, 0.24, 0.48, 0.72)
    bubblePage:Hide()
    applyComicFont(bubblePage, 9, false)

    bubble:Hide()

    self:ApplyPosition()
    self:ApplyPresentationMode()
    self:ReanchorBubble()
    self:RefreshCompanion()
    self:UpdateMiniStats()
    self:ApplyModelLab()

    return frame
end

function FC:UpdateBubbleLayout()
    if not self.bubble or not self.bubbleText or not self.bubbleName then return end

    local width = self.bubble:GetWidth() or 300
    local height = self.bubble:GetHeight() or 180
    local mirrored = self.bubbleMirrored and true or false

    -- The bubble art is visually asymmetric because of the tail. Center text in the
    -- main body safe area rather than the full texture bounds.
    local bodyShiftX = mirrored and -22 or 22
    local bodyShiftY = 6
    local bodyWidth = math.max(160, math.floor(width * 0.58))
    local bodyHeight = math.max(54, math.floor(height * 0.38))

    -- Keep the companion name fully inside the bright top-left body of the bubble.
    -- No backing rectangle: readability comes from a clean font + outline/shadow.
    local nameInsetX = mirrored and 92 or 88
    local nameInsetY = -31
    local nameWidth = math.max(90, math.floor(width * 0.24))
    local nameHeight = 18

    self.bubbleName:ClearAllPoints()
    self.bubbleName:SetPoint("TOPLEFT", self.bubble, "TOPLEFT", nameInsetX, nameInsetY)
    self.bubbleName:SetWidth(nameWidth)
    self.bubbleName:SetHeight(nameHeight)

    self.bubbleText:ClearAllPoints()
    self.bubbleText:SetPoint("CENTER", self.bubble, "CENTER", bodyShiftX, bodyShiftY)
    self.bubbleText:SetWidth(bodyWidth)
    self.bubbleText:SetHeight(bodyHeight)
    if self.bubbleText.SetSpacing then self.bubbleText:SetSpacing(2) end

    if self.bubblePage then
        self.bubblePage:ClearAllPoints()
        local pageShiftX = mirrored and -34 or 34
        self.bubblePage:SetPoint("BOTTOM", self.bubble, "BOTTOM", pageShiftX, 29)
        self.bubblePage:SetWidth(math.max(54, math.floor(width * 0.20)))
    end
end

function FC:ApplyPosition()
    if not self.frame or not self.db then return end
    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", UIParent, "CENTER", self.db.x or 360, self.db.y or 180)
    self.frame:SetScale(self.db.scale or 1)
    if self.ReanchorBubble then self:ReanchorBubble() end
end

function FC:ReanchorBubble()
    if not self.bubble or not self.frame then return end
    local frameX = self.frame.GetCenter and select(1, self.frame:GetCenter()) or nil
    local uiX = UIParent and UIParent.GetCenter and select(1, UIParent:GetCenter()) or nil
    self.bubble:ClearAllPoints()
    if frameX and uiX and frameX > uiX then
        self.bubble:SetPoint("BOTTOMRIGHT", self.frame, "TOPLEFT", 10, -18)
        self.bubbleMirrored = true
        if self.bubbleBG and self.bubbleBG.SetTexCoord then self.bubbleBG:SetTexCoord(1, 0, 0, 1) end
    else
        self.bubble:SetPoint("BOTTOMLEFT", self.frame, "TOPRIGHT", -10, -18)
        self.bubbleMirrored = false
        if self.bubbleBG and self.bubbleBG.SetTexCoord then self.bubbleBG:SetTexCoord(0, 1, 0, 1) end
    end
    local appearance = self.db and self.db.appearance or {}
    if self.bubble.SetScale then self.bubble:SetScale(tonumber(appearance.bubbleScale) or 1) end
    self:UpdateBubbleLayout()
end

function FC:ApplyPresentationMode()
    if not self.frame or not self.modelHolder or not self.db then return end

    local mode = (self.db.appearance and self.db.appearance.mode) or "desktop"
    if mode == "full" then
        self.frame:SetSize(300, 400)
        self.modelHolder:SetHeight(310)
        if self.SetSpriteBaseSize then self:SetSpriteBaseSize(300) end
    elseif mode == "portrait" then
        self.frame:SetSize(190, 235)
        self.modelHolder:SetHeight(170)
        if self.SetSpriteBaseSize then self:SetSpriteBaseSize(190) end
    else
        self.frame:SetSize(240, 290)
        self.modelHolder:SetHeight(220)
        if self.SetSpriteBaseSize then self:SetSpriteBaseSize(240) end
    end
end

function FC:RefreshCompanion()
    if not self.nameText or not self.db then return end
    local companion = self.companions[self.db.companion] or self.companions.Vexa
    if not companion then return end

    self.nameText:SetText((companion.accent or "|cffffffff") .. companion.name .. "|r")
    if self.bubbleName then self.bubbleName:SetText(companion.name) end
end

local function normalizeSpeechText(text)
    text = tostring(text or "")
    text = text:gsub("\r", " "):gsub("\n", " ")
    text = text:gsub("%s+", " ")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    return text
end

local function splitLongChunk(chunk, maxChars, out)
    chunk = normalizeSpeechText(chunk)
    while #chunk > maxChars do
        local cut = maxChars
        local window = chunk:sub(1, maxChars + 1)
        local lastSpace = nil
        for i = 1, #window do
            if window:sub(i, i) == " " then lastSpace = i end
        end
        if lastSpace and lastSpace >= math.floor(maxChars * 0.58) then cut = lastSpace - 1 end
        local piece = chunk:sub(1, cut):gsub("%s+$", "")
        if piece ~= "" then table.insert(out, piece) end
        chunk = chunk:sub(cut + 1):gsub("^%s+", "")
    end
    if chunk ~= "" then table.insert(out, chunk) end
end

function FC:SplitSpeechPages(text, maxChars)
    text = normalizeSpeechText(text)
    maxChars = tonumber(maxChars) or 150
    if text == "" then return {} end
    if #text <= maxChars then return { text } end

    -- First build sentence-like chunks so continuation bubbles feel intentional.
    local chunks = {}
    local pos = 1
    while pos <= #text do
        local s, e = text:find("[%.%!%?]+[%\"%'%)%]]*%s+", pos)
        if s then
            local chunk = text:sub(pos, e):gsub("%s+$", "")
            if chunk ~= "" then table.insert(chunks, chunk) end
            pos = e + 1
        else
            local tail = text:sub(pos):gsub("^%s+", ""):gsub("%s+$", "")
            if tail ~= "" then table.insert(chunks, tail) end
            break
        end
    end
    if #chunks == 0 then chunks = { text } end

    local pages = {}
    local current = ""
    local function flushCurrent()
        if current ~= "" then
            table.insert(pages, current)
            current = ""
        end
    end

    for _, originalChunk in ipairs(chunks) do
        local chunk = originalChunk
        while chunk and chunk ~= "" do
            if current == "" and #chunk <= maxChars then
                current = chunk
                chunk = nil
            elseif current == "" and #chunk > maxChars then
                local temp = {}
                splitLongChunk(chunk, maxChars, temp)
                for i = 1, #temp - 1 do table.insert(pages, temp[i]) end
                current = temp[#temp] or ""
                chunk = nil
            elseif (#current + 1 + #chunk) <= maxChars then
                current = current .. " " .. chunk
                chunk = nil
            else
                local available = maxChars - #current - 1
                -- Avoid tiny orphan pages like "We're back in Westfall." by borrowing
                -- a natural clause from the next sentence when there is safe room.
                if #current < math.floor(maxChars * 0.35) and available >= 36 then
                    local probe = chunk:sub(1, available)
                    local best = nil
                    for i = 1, #probe do
                        local c = probe:sub(i, i)
                        if (c == "," or c == ";" or c == ":") and i >= math.floor(available * 0.45) then
                            best = i
                        end
                    end
                    if not best then
                        for i = 1, #probe do
                            if probe:sub(i, i) == " " and i >= math.floor(available * 0.60) then best = i - 1 end
                        end
                    end
                    if best and best > 0 then
                        local prefix = chunk:sub(1, best):gsub("%s+$", "")
                        current = current .. " " .. prefix
                        chunk = chunk:sub(best + 1):gsub("^%s+", "")
                    end
                end
                flushCurrent()
            end
        end
    end
    flushCurrent()
    return pages
end

function FC:DisplayBubblePage(text, pageIndex, pageCount)
    if not self.bubble or not self.bubbleText then return end

    local length = #tostring(text)
    local width, height, fontSize
    if length <= 42 then
        width, height, fontSize = 278, 150, 15
    elseif length <= 78 then
        width, height, fontSize = 312, 172, 14
    elseif length <= 120 then
        width, height, fontSize = 344, 194, 13
    else
        width, height, fontSize = 372, 220, 12
    end

    local appearance = self.db.appearance or {}
    local fontScale = tonumber(appearance.fontScale) or 1
    self.bubble:SetSize(width, height)
    applyComicFont(self.bubbleText, math.max(10, math.floor(fontSize * fontScale + 0.5)), false)
    self:RefreshCompanion()
    self:ReanchorBubble()
    self:UpdateBubbleLayout()
    self.bubbleText:SetText(text)

    if self.bubblePage then
        if (pageCount or 1) > 1 then
            self.bubblePage:SetText(string.format("%d/%d", pageIndex or 1, pageCount or 1))
            self.bubblePage:Show()
        else
            self.bubblePage:SetText("")
            self.bubblePage:Hide()
        end
    end

    self.bubble:Show()
    -- Every displayed page gets a short protected reading window. Queue items may
    -- continue to accumulate, but normal reactions cannot replace this page until
    -- the player has had a fair chance to read it.
    local now = GetTime()
    local minHold = tonumber(appearance.minMessageHold) or 2.25
    minHold = math.max(1.50, math.min(5.00, minHold))
    self.bubble.readLockUntil = now + minHold

    -- Long thoughts still get a length-based lifetime. Once that lifetime expires,
    -- PumpQueue can replace the page seamlessly if another message is waiting.
    self.bubble.untilTime = now + math.max(5.5, math.min(12.5, length / 12))
end

function FC:ShowBubble(text)
    if not text then return end

    if not self.db or not self.db.bubble then
        self:Debug(text)
        return
    end

    if not self.bubble or not self.bubbleText then
        self:Debug("UI not ready for speech: " .. tostring(text))
        return
    end

    local appearance = self.db.appearance or {}
    local fontScale = tonumber(appearance.fontScale) or 1
    -- Larger fonts need shorter pages so text never gets clipped inside the safe area.
    local maxChars = math.floor(165 / math.max(0.85, fontScale))
    maxChars = math.max(105, math.min(158, maxChars))
    local pages = self:SplitSpeechPages(text, maxChars)
    if #pages == 0 then return end

    self.state = self.state or {}
    self.state.speechSequence = {
        pages = pages,
        index = 1,
        started = GetTime(),
        original = tostring(text),
    }
    self:DisplayBubblePage(pages[1], 1, #pages)
end

function FC:AdvanceBubblePage()
    local seq = self.state and self.state.speechSequence
    if not seq or not seq.pages then return false end
    local nextIndex = (seq.index or 1) + 1
    if nextIndex > #seq.pages then
        self.state.speechSequence = nil
        if self.bubblePage then self.bubblePage:Hide() end
        return false
    end

    seq.index = nextIndex
    self:DisplayBubblePage(seq.pages[nextIndex], nextIndex, #seq.pages)
    return true
end

function FC:CancelBubbleSequence()
    if self.state then self.state.speechSequence = nil end
    if self.bubblePage then self.bubblePage:Hide() end
end

function FC:UpdateMiniStats()
    if not self.miniStats then return end
    self.miniStats:SetText("")
    self.miniStats:Hide()
end

function FC:ShowStats()
    local remaining, rate, seconds, fights = self:Estimate()
    local quests = self.state.questSnapshot or {}

    local message = string.format(
        "Level %d. %s XP left. %s XP/hour. %d quests ready.",
        (UnitLevel and self:ReadableNumber(UnitLevel("player"))) or 0,
        self:FormatNumber(remaining),
        self:FormatNumber(rate),
        quests.complete or 0
    )

    if fights then
        message = message .. " Roughly " .. fights .. " fights at this pace."
    elseif seconds then
        message = message .. " Roughly " .. self:FormatDuration(seconds) .. " to level."
    end

    self:Say(message, "point", 100, true)
end

function FC:ShowHelp()
    self:Say(
        "/fc talk • learn • word • vocabquiz • trivia • riddle • quote • question • strangefact • story • stats • dungeon • farm • timing • profile • test • doctor • settings",
        "talk",
        100,
        true
    )
end

local function quickMenuButton(parent, text, order, callback)
    local button = CreateFrame("Button", nil, parent)
    button:SetHeight(30)
    button:SetPoint("TOPLEFT", 10, -42 - ((order - 1) * 31))
    button:SetPoint("TOPRIGHT", -10, -42 - ((order - 1) * 31))

    local highlight = button:CreateTexture(nil, "BACKGROUND")
    highlight:SetAllPoints()
    highlight:SetColorTexture(0.46, 0.20, 0.60, 0.0)
    button.FCHighlight = highlight

    local label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", 10, 0)
    label:SetPoint("RIGHT", -8, 0)
    label:SetJustifyH("LEFT")
    label:SetText(text)
    button.FCLabel = label

    button:SetScript("OnEnter", function(self)
        if self.FCHighlight then self.FCHighlight:SetColorTexture(0.46, 0.20, 0.60, 0.28) end
        if self.FCLabel then self.FCLabel:SetTextColor(1, 0.72, 0.92) end
    end)
    button:SetScript("OnLeave", function(self)
        if self.FCHighlight then self.FCHighlight:SetColorTexture(0.46, 0.20, 0.60, 0.0) end
        if self.FCLabel then self.FCLabel:SetTextColor(1, 1, 1) end
    end)
    button:SetScript("OnClick", function()
        if callback then callback() end
        if FC.quickMenu then FC.quickMenu:Hide() end
    end)
    return button
end

function FC:CreateQuickMenu()
    if self.quickMenu then return self.quickMenu end

    local menu = CreateFrame("Frame", "ForeverCompanionQuickMenu", UIParent)
    self.quickMenu = menu
    menu:SetSize(290, 758)
    menu:SetFrameStrata("TOOLTIP")
    menu:SetClampedToScreen(true)
    menu:EnableMouse(true)

    local shadow = menu:CreateTexture(nil, "BACKGROUND", nil, -2)
    shadow:SetPoint("TOPLEFT", -5, 5)
    shadow:SetPoint("BOTTOMRIGHT", 5, -5)
    shadow:SetColorTexture(0, 0, 0, 0.40)

    local bg = menu:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.035, 0.025, 0.055, 0.96)

    local accent = menu:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("TOPLEFT", 0, 0)
    accent:SetPoint("TOPRIGHT", 0, 0)
    accent:SetHeight(2)
    accent:SetColorTexture(0.92, 0.28, 0.68, 0.95)

    local title = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    menu.FCTitle = title
    title:SetPoint("TOPLEFT", 18, -14)
    title:SetTextColor(1, 0.45, 0.78)

    local items = {
        { "Tell me something", function() FC:ForceConversation() end },
        { "What should I do next?", function() FC:RecommendNextAction() end },
        { "What's my XP pace?", function() FC:ShowStats() end },
        { "How was that last fight?", function() FC:ShowLastFight() end },
        { "Quest status", function() FC:ShowQuestStatus() end },
        { "How are my bags?", function() FC:ShowBagStatus() end },
        { "Dungeon intelligence", function() FC:ShowDungeonIntel() end },
        { "Dungeon loot watch", function() FC:ShowDungeonLootWatch() end },
        { "Gold farming stats", function() FC:ShowGoldFarmStats() end },
        { "Start / stop gold farm", function() FC:ToggleGoldFarm() end },
        { "Gold farming settings", function() FC:OpenSettings("Gold Farming") end },
        { "What do you know about me?", function() FC:ShowProfile() end },
        { "Characters you remember", function() FC:ShowRosterSummary() end },
        { "What happened last session?", function() FC:ShowLastSession() end },
        { "What did you just say?", function() FC:RepeatLastStatement() end },
        { "Why did you say that?", function() FC:WhyLastStatement() end },
        { "Conversation history", function() FC:OpenSettings("Conversation") end },
        { "Memory Journal", function() FC:OpenSettings("Memory") end },
        { "Talk less / talk more", function()
            FC.db.chatty = ((FC.db.chatty or 0.5) > 0.2) and 0.15 or 0.75
            local line = (FC.db.chatty or 0.5) <= 0.2 and "All right. I'll keep it down." or "Oh, you want commentary? You asked for it."
            FC:Say(line, "talk", 100, true)
        end },
        { "Settings", function() FC:OpenSettings("Companion") end },
        { "Hide companion", function() if FC.frame then FC.frame:Hide() end end },
        { "Close", function() end },
    }

    menu.FCButtons = {}
    for i, item in ipairs(items) do
        menu.FCButtons[i] = quickMenuButton(menu, item[1], i, item[2])
    end

    menu:Hide()
    return menu
end

function FC:ShowCompanionMenu()
    if not self.db then return end

    local menu = self:CreateQuickMenu()
    if menu:IsShown() then
        menu:Hide()
        return
    end

    local companion = self.companions[self.db.companion] or self.companions.Vexa
    menu.FCTitle:SetText(companion and companion.name or "Forever Companion")

    menu:ClearAllPoints()
    if self.frame then
        menu:SetPoint("TOPLEFT", self.frame, "TOPRIGHT", 10, -10)
    else
        menu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
    menu:Show()
end

