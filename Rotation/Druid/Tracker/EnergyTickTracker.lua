--- @class EnergyTickTracker : CooldownTracker
--- @field lastEnergy number
--- @field lastTickTime number
EnergyTickTracker = setmetatable({}, { __index = CooldownTracker })
EnergyTickTracker.__index = EnergyTickTracker

--- @return EnergyTickTracker
function EnergyTickTracker.new()
    --- @class EnergyTickTracker
    local self = CooldownTracker.new()
    setmetatable(self, EnergyTickTracker)

    self.lastEnergy = UnitMana("player")
    self.lastTickTime = GetTime()
    
    return self
end

--- @param event string
--- @param arg1 string
function EnergyTickTracker:onEvent(event, arg1)
    if event == "UNIT_ENERGY" then
        local now = GetTime()
        local current = UnitMana("player")
        local delta = current - self.lastEnergy

        if delta == 20 and (now - self.lastTickTime) > 1.5 then
            self.lastTickTime = now
        end

        self.lastEnergy = current
    end 
end

--- @return boolean
function EnergyTickTracker:ShouldCast()
    return false;
end

--- @return number
function EnergyTickTracker:GetNextEnergyTick()
    local function clampToZero(n)
        return n < 0 and 0 or n
    end

    return clampToZero((self.lastTickTime + 2) - GetTime())
end