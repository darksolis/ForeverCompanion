local FC = _G.ForeverCompanion

function FC:OnZoneChanged()
    if type(self.TouchZone) ~= "function" then return end
    if type(self.IsDungeonContext) == "function" and self:IsDungeonContext() then
        self:TouchZone()
        return
    end

    local zone, oldZone = self:TouchZone()
    if not oldZone or oldZone == zone or not self.db or not self.db.world then
        return
    end

    local newRate = self:ZoneHistoricalRate(zone)
    local oldRate = self:ZoneHistoricalRate(oldZone)

    local expectedZone = zone
    if type(self.QueueZoneArrival) == "function" then
        self:QueueZoneArrival(zone, oldZone)
    else
        self:QueueTopic(
            "zone",
            { zone = zone },
            18,
            90,
            false,
            function()
                local current = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText()) or "Unknown"
                return current == expectedZone
            end
        )
    end

    if newRate > 0 and oldRate > 0 and newRate > oldRate * 1.2 then
        local expectedZoneForRate = zone
        self:QueueTopic(
            "zonebetter",
            { percent = math.floor((newRate / oldRate - 1) * 100) },
            16,
            240,
            false,
            function()
                local current = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText()) or "Unknown"
                return current == expectedZoneForRate
            end
        )
    end
end

function FC:CheckWorldState()
    if not self.db then return end

    if type(self.IsDungeonContext) == "function" and self:IsDungeonContext() then
        local free, total = self:BagSpace()
        if total > 0 and free <= 0 then
            self:QueueTopic("bagfull", {}, 70, 180, false, function()
                local liveFree = FC:BagSpace()
                return liveFree ~= nil and liveFree <= 0 and FC:IsDungeonContext()
            end)
        end
        local durability = self:LowestDurability()
        if durability < 0.08 then
            local expectedPercent = math.floor(durability * 100)
            self:QueueTopic("repair", { percent = expectedPercent }, 55, 300, false, function()
                return FC:IsDungeonContext() and (FC:LowestDurability() or 1) < 0.08
            end)
        end
        return
    end

    local idle = GetTime() - (self.state.lastAction or GetTime())
    if idle > 300 and not self.state.wasIdle then
        self.state.wasIdle = true
        self:QueueTopic("idle", {}, 8, 600)
    end

    local free, total = self:BagSpace()
    if total > 0 and free / total < 0.1 then
        local expectedFree = free
        self:QueueTopic(
            "bags",
            { free = free, total = total },
            14,
            300,
            false,
            function()
                local liveFree, liveTotal = FC:BagSpace()
                return liveTotal > 0 and liveFree == expectedFree and liveFree / liveTotal < 0.1
            end
        )
    end

    local durability = self:LowestDurability()
    if durability < 0.22 then
        local expectedPercent = math.floor(durability * 100)
        self:QueueTopic(
            "repair",
            { percent = expectedPercent },
            18,
            420,
            false,
            function()
                local livePercent = math.floor((FC:LowestDurability() or 1) * 100)
                return livePercent < 22 and math.abs(livePercent - expectedPercent) <= 2
            end
        )
    end
end
