local FC = _G.ForeverCompanion

local function setShown(frame, shown)
    if not frame then return end
    if frame.SetShown then
        frame:SetShown(shown)
    elseif shown then
        frame:Show()
    else
        frame:Hide()
    end
end

local function atan2(y, x)
    if math.atan2 then return math.atan2(y, x) end
    if x > 0 then return math.atan(y / x) end
    if x < 0 and y >= 0 then return math.atan(y / x) + math.pi end
    if x < 0 and y < 0 then return math.atan(y / x) - math.pi end
    if x == 0 and y > 0 then return math.pi / 2 end
    if x == 0 and y < 0 then return -math.pi / 2 end
    return 0
end

function FC:CreateMinimapButton()
    if self.minimapButton then
        setShown(self.minimapButton, not (self.db and self.db.minimap and self.db.minimap.hide))
        return self.minimapButton
    end

    self.db.minimap = self.db.minimap or { hide = false, angle = 225 }

    local anchor = Minimap or UIParent
    if not anchor then
        self:Debug("No UI anchor available for minimap launcher.")
        return nil
    end

    -- Parent directly to Minimap so standard minimap button collectors (including
    -- EllesmereUI's button holder) can discover and reparent it.
    local buttonParent = Minimap or UIParent
    local button = CreateFrame("Button", "ForeverCompanionMinimapButton", buttonParent)
    self.minimapButton = button
    button:SetSize(34, 34)
    button:SetFrameStrata("MEDIUM")
    if button.SetFrameLevel and Minimap and Minimap.GetFrameLevel then
        button:SetFrameLevel((Minimap:GetFrameLevel() or 1) + 5)
    end
    button:EnableMouse(true)

    if button.RegisterForClicks then pcall(button.RegisterForClicks, button, "LeftButtonUp", "RightButtonUp") end
    if button.RegisterForDrag then pcall(button.RegisterForDrag, button, "LeftButton") end

    local ring = button:CreateTexture(nil, "BACKGROUND")
    ring:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
    ring:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
    ring:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)

    local icon = button:CreateTexture(nil, "ARTWORK")
    button.icon = icon
    icon:SetTexture("Interface/AddOns/ForeverCompanion/Textures/MinimapIcon.tga")
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", 5, -5)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 5)

    local glow = button:CreateTexture(nil, "HIGHLIGHT")
    glow:SetTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
    glow:SetBlendMode("ADD")
    glow:SetAllPoints()

    local function place()
        button:ClearAllPoints()

        if Minimap and Minimap.GetCenter then
            local angle = math.rad(tonumber(FC.db.minimap.angle) or 225)
            local radius = 78
            if Minimap.GetWidth then
                local w = Minimap:GetWidth()
                if type(w) == "number" and w > 0 then radius = math.max(58, (w / 2) + 10) end
            end
            button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
        else
            -- Last-resort launcher placement if Forever replaces the minimap frame.
            button:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -210, -40)
        end
    end

    local dragging = false
    button:SetScript("OnDragStart", function() dragging = true end)
    button:SetScript("OnDragStop", function() dragging = false end)

    button:SetScript("OnUpdate", function()
        if not dragging or not Minimap or not GetCursorPosition or not UIParent or not UIParent.GetEffectiveScale then return end
        local mx, my = Minimap:GetCenter()
        if not mx or not my then return end
        local cx, cy = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale() or 1
        cx, cy = cx / scale, cy / scale
        FC.db.minimap.angle = math.deg(atan2(cy - my, cx - mx))
        place()
    end)

    button:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "RightButton" then
            FC:ShowCompanionMenu()
        else
            FC:ToggleSettings()
        end
    end)

    button:SetScript("OnEnter", function(owner)
        if not GameTooltip then return end
        GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
        GameTooltip:AddLine("Forever Companion", 0.84, 0.64, 1)
        GameTooltip:AddLine("Left-click: Control Center", 1, 1, 1)
        GameTooltip:AddLine("Right-click: Quick actions", 1, 1, 1)
        GameTooltip:AddLine("Drag: Move around minimap", 0.72, 0.72, 0.72)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

    place()
    setShown(button, not self.db.minimap.hide)
    return button
end

function FC:SetMinimapButtonShown(shown)
    self.db.minimap = self.db.minimap or { angle = 225 }
    self.db.minimap.hide = not shown
    if not self.minimapButton and shown then self:CreateMinimapButton() end
    setShown(self.minimapButton, shown)
end

function FC:ResetMinimapButton()
    self.db.minimap = self.db.minimap or {}
    self.db.minimap.hide = false
    self.db.minimap.angle = 225
    if self.minimapButton then
        self.minimapButton:Show()
        self.minimapButton:ClearAllPoints()
        local angle = math.rad(225)
        local radius = 78
        if Minimap and Minimap.GetWidth then
            local w = Minimap:GetWidth()
            if type(w) == "number" and w > 0 then radius = math.max(58, (w / 2) + 10) end
        end
        if Minimap then
            self.minimapButton:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
        else
            self.minimapButton:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -210, -40)
        end
    else
        self:CreateMinimapButton()
    end
end
