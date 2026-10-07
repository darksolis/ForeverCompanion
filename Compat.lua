local FC = _G.ForeverCompanion

function FC:DetectCapabilities()
    local c = self.state.capabilities
    c.questModern = type(C_QuestLog) == "table" and type(C_QuestLog.GetInfo) == "function"
    c.questComplete = type(C_QuestLog) == "table" and type(C_QuestLog.IsQuestFlaggedCompleted) == "function"
    c.questHistory = type(C_QuestLog) == "table" and type(C_QuestLog.GetAllCompletedQuestIDs) == "function"
    c.container = type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function"
    c.reputation = type(C_Reputation) == "table" and type(C_Reputation.GetNumFactions) == "function"
    c.professions = type(GetProfessions) == "function"
    c.playerModel = true
    c.modelScene = type(ModelSceneMixin) == "table" or type(ModelScene) == "table"
    c.achievements = type(GetTotalAchievementPoints) == "function"
    c.stats = type(GetStatistic) == "function"
    c.currency = type(C_CurrencyInfo) == "table"
    c.map = type(C_Map) == "table"
    c.unitAuras = type(C_UnitAuras) == "table" or type(UnitAura) == "function" or type(UnitBuff) == "function"
    c.groupRoles = type(UnitGroupRolesAssigned) == "function"
    c.restedXP = type(GetXPExhaustion) == "function"
    c.itemQuality = type(GetItemInfo) == "function" or (type(C_Item) == "table" and type(C_Item.GetItemQualityByID) == "function")
    c.specialization = type(GetSpecialization) == "function" and type(GetSpecializationInfo) == "function"
    c.falling = type(IsFalling) == "function"
    c.power = type(UnitPowerType) == "function" and type(UnitPower) == "function" and type(UnitPowerMax) == "function"
    c.secretValues = type(issecretvalue) == "function" or type(canaccessvalue) == "function"
    c.instance = type(IsInInstance) == "function"
    c.battlegroundWinner = type(GetBattlefieldWinner) == "function"
    c.memoryIO = type(self.ExportMemoryText) == "function" and type(self.ImportMemoryText) == "function"
    return c
end

function FC:PrintCapabilities()
    local a = {}
    self:DetectCapabilities()
    for k, v in pairs(self.state.capabilities or {}) do a[#a + 1] = k .. "=" .. tostring(v) end
    table.sort(a)
    self:Debug(table.concat(a, "  "))
end

function FC:BagSpace()
    local free, total = 0, 0
    for b = 0, 4 do
        local f, n
        if C_Container and C_Container.GetContainerNumFreeSlots then
            f = self:Safe(C_Container.GetContainerNumFreeSlots, b)
            n = C_Container.GetContainerNumSlots and self:Safe(C_Container.GetContainerNumSlots, b)
        elseif GetContainerNumFreeSlots then
            f = self:Safe(GetContainerNumFreeSlots, b)
            n = GetContainerNumSlots and self:Safe(GetContainerNumSlots, b)
        end
        f = self:ReadableNumber(f) or 0
        n = self:ReadableNumber(n) or 0
        free = free + f
        total = total + n
    end
    return free, total
end

function FC:LowestDurability()
    local low = 1
    for slot = 1, 18 do
        local c, m
        if GetInventoryItemDurability then c, m = self:Safe(GetInventoryItemDurability, slot) end
        c, m = self:ReadableNumber(c), self:ReadableNumber(m)
        if c ~= nil and m ~= nil and m > 0 then low = math.min(low, c / m) end
    end
    return low
end
