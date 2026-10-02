local FC = _G.ForeverCompanion

local function encodePart(value)
    local s = tostring(value)
    return (s:gsub("([^%w%-%_%.])", function(c) return string.format("%%%02X", string.byte(c)) end))
end

local function decodePart(value)
    return (tostring(value):gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

local function walk(lines, value, path, seen)
    local kind = type(value)
    if kind == "table" then
        if seen[value] then return end
        seen[value] = true
        for key, child in pairs(value) do
            local keyType = type(key) == "number" and "n" or "s"
            local segment = keyType .. encodePart(key)
            local childPath = path == "" and segment or (path .. "/" .. segment)
            walk(lines, child, childPath, seen)
        end
    elseif kind == "string" then
        lines[#lines + 1] = "S\t" .. path .. "\t" .. encodePart(value)
    elseif kind == "number" then
        lines[#lines + 1] = "N\t" .. path .. "\t" .. tostring(value)
    elseif kind == "boolean" then
        lines[#lines + 1] = "B\t" .. path .. "\t" .. (value and "1" or "0")
    end
end

function FC:ExportMemoryText()
    local lines = { "FOREVERCOMPANION_MEMORY_V1" }
    walk(lines, self.db.characters or {}, "scharacters", {})
    walk(lines, self.db.sharedMemory or {}, "ssharedMemory", {})
    return table.concat(lines, "\n")
end

local function setPath(root, path, value)
    local parts = {}
    for part in tostring(path):gmatch("[^/]+") do parts[#parts + 1] = part end
    if #parts == 0 then return end
    local node = root
    for i = 1, #parts - 1 do
        local part = parts[i]
        local kind = part:sub(1, 1)
        local raw = decodePart(part:sub(2))
        local key = kind == "n" and tonumber(raw) or raw
        node[key] = type(node[key]) == "table" and node[key] or {}
        node = node[key]
    end
    local part = parts[#parts]
    local kind = part:sub(1, 1)
    local raw = decodePart(part:sub(2))
    local key = kind == "n" and tonumber(raw) or raw
    node[key] = value
end

function FC:ImportMemoryText(text)
    if type(text) ~= "string" or not text:find("^FOREVERCOMPANION_MEMORY_V1") then
        return false, "That does not look like a Forever Companion memory export."
    end
    local imported = { characters = {}, sharedMemory = {} }
    local count = 0
    for line in text:gmatch("[^\r\n]+") do
        if not line:find("^FOREVERCOMPANION_MEMORY_V1") then
            local kind, path, encoded = line:match("^([SNB])\t([^\t]+)\t(.*)$")
            if kind and path then
                local value
                if kind == "S" then value = decodePart(encoded)
                elseif kind == "N" then value = tonumber(encoded)
                elseif kind == "B" then value = encoded == "1" end
                if value ~= nil then setPath(imported, path, value); count = count + 1 end
            end
        end
    end
    if count == 0 then return false, "No memory records were found in that export." end
    self.db.characters = imported.characters or {}
    self.db.sharedMemory = imported.sharedMemory or {}
    self.db.sharedMemory.characters = self.db.sharedMemory.characters or {}
    self.db.sharedMemory.dialogueHistory = self.db.sharedMemory.dialogueHistory or {}
    self.db.sharedMemory.preferences = self.db.sharedMemory.preferences or {}
    self.db.sharedMemory.blockedLines = self.db.sharedMemory.blockedLines or {}
    self.db.sharedMemory.favoriteLines = self.db.sharedMemory.favoriteLines or {}
    self:ActivateCharacterMemory()
    self:RefreshLiveProfile()
    return true, "Imported " .. tostring(count) .. " memory records."
end

function FC:OpenMemoryTransfer(mode)
    if not self.memoryTransfer then
        local frame = CreateFrame("Frame", "ForeverCompanionMemoryTransfer", UIParent, "BackdropTemplate")
        self.memoryTransfer = frame
        frame:SetSize(700, 500)
        frame:SetPoint("CENTER")
        frame:SetFrameStrata("DIALOG")
        frame:SetClampedToScreen(true)
        if frame.SetBackdrop then
            frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 14 })
            frame:SetBackdropColor(0.02, 0.02, 0.04, 0.98)
        end

        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        frame.FCTitle = title
        title:SetPoint("TOPLEFT", 18, -16)

        local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -4, -4)

        local edit = CreateFrame("EditBox", nil, frame)
        frame.FCEdit = edit
        if edit.SetMultiLine then edit:SetMultiLine(true) end
        if edit.SetAutoFocus then edit:SetAutoFocus(false) end
        if edit.SetFontObject then edit:SetFontObject(ChatFontNormal or GameFontHighlight) end
        edit:SetPoint("TOPLEFT", 20, -52)
        edit:SetPoint("BOTTOMRIGHT", -20, 60)
        if edit.SetTextInsets then edit:SetTextInsets(8, 8, 8, 8) end
        if edit.EnableMouse then edit:EnableMouse(true) end

        local import = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        import:SetSize(150, 28)
        import:SetPoint("BOTTOMLEFT", 20, 18)
        import:SetText("Import pasted text")
        import:SetScript("OnClick", function()
            local ok, message = FC:ImportMemoryText(edit:GetText() or "")
            FC:Debug(message)
            if ok then frame:Hide() end
        end)

        local selectAll = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        selectAll:SetSize(120, 28)
        selectAll:SetPoint("LEFT", import, "RIGHT", 10, 0)
        selectAll:SetText("Select all")
        selectAll:SetScript("OnClick", function() edit:SetFocus(); edit:HighlightText() end)
    end

    local frame = self.memoryTransfer
    if mode == "import" then
        frame.FCTitle:SetText("Import Companion Memory")
        frame.FCEdit:SetText("")
    else
        frame.FCTitle:SetText("Export Companion Memory")
        frame.FCEdit:SetText(self:ExportMemoryText())
        frame.FCEdit:SetFocus()
        frame.FCEdit:HighlightText()
    end
    frame:Show()
end
