local FC = _G.ForeverCompanion

local function isLoaded(name)
    if C_AddOns and C_AddOns.IsAddOnLoaded then
        local ok, value = pcall(C_AddOns.IsAddOnLoaded, name)
        if ok then return value and true or false end
    end
    if IsAddOnLoaded then
        local ok, value = pcall(IsAddOnLoaded, name)
        if ok then return value and true or false end
    end
    return false
end

function FC:RefreshIntegrations()
    local integrations = {
        Questie = isLoaded("Questie") or _G.Questie ~= nil,
        Details = isLoaded("Details") or _G.Details ~= nil,
        ElvUI = isLoaded("ElvUI") or _G.ElvUI ~= nil,
        Grid = isLoaded("Grid") or isLoaded("Grid2") or _G.Grid ~= nil or _G.Grid2 ~= nil,
        ChatSentry = isLoaded("ChatSentry") or _G.ChatSentry ~= nil,
        Auctionator = isLoaded("Auctionator") and _G.Auctionator and _G.Auctionator.API and _G.Auctionator.API.v1 and type(_G.Auctionator.API.v1.GetAuctionPriceByItemLink) == "function" or false,
    }
    self.state.integrations = integrations
    self.state.integrationDetails = self.state.integrationDetails or {}
    if integrations.Auctionator then
        local version = nil
        if C_AddOns and type(C_AddOns.GetAddOnMetadata) == "function" then
            local ok, value = pcall(C_AddOns.GetAddOnMetadata, "Auctionator", "Version")
            if ok then version = value end
        elseif type(GetAddOnMetadata) == "function" then
            local ok, value = pcall(GetAddOnMetadata, "Auctionator", "Version")
            if ok then version = value end
        end
        self.state.integrationDetails.Auctionator = { version = version or "unknown", api = "v1" }
    else
        self.state.integrationDetails.Auctionator = nil
    end
    return integrations
end

function FC:GetDetailsSnapshot()
    if not self.state.integrations or not self.state.integrations.Details then return nil end
    local details = _G.Details
    if not details or type(details.GetCurrentCombat) ~= "function" then return nil end
    local ok, combat = pcall(details.GetCurrentCombat, details)
    if not ok or not combat then return nil end

    local snapshot = {}
    local playerName = UnitName and UnitName("player") or nil
    if playerName and type(combat.GetActor) == "function" then
        local okActor, actor = pcall(combat.GetActor, combat, 1, playerName)
        if okActor and actor then
            snapshot.totalDamage = actor.total or actor.total_damage or nil
            snapshot.dps = actor.last_dps or actor.dps or nil
        end
    end
    return snapshot
end

function FC:IntegrationSummary()
    local integrations = self:RefreshIntegrations()
    local names = {}
    for name, active in pairs(integrations) do
        names[#names + 1] = name .. "=" .. tostring(active)
    end
    table.sort(names)
    return table.concat(names, "  ")
end
