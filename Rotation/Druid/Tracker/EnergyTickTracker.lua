--- @class EnergyTickTracker : CooldownTracker
--- @field lastEnergy number
--- @field lastTickTime number|nil
EnergyTickTracker = setmetatable({}, { __index = CooldownTracker })
EnergyTickTracker.__index = EnergyTickTracker

local TICK_SEC = 2

local function isEnergyTickDelta(delta)
    return delta == 20
end

--- @return EnergyTickTracker
function EnergyTickTracker.new()
    --- @class EnergyTickTracker
    local self = CooldownTracker.new()
    setmetatable(self, EnergyTickTracker)

    self.lastEnergy = GetUnitField("player", "power4")
    self.lastTickTime = nil

    return self
end

--- @param event string
--- @param arg1 string
function EnergyTickTracker:onEvent(event, arg1)
    if event == "UNIT_ENERGY" and arg1 == "player" then
        local now = GetTime()
        local current = GetUnitField("player", "power4")
        local delta = current - self.lastEnergy

        if isEnergyTickDelta(delta) and (self.lastTickTime == nil or (now - self.lastTickTime) > 1.5) then
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
    if self.lastTickTime == nil then
        return 999
    end

    local wait = (self.lastTickTime + TICK_SEC) - GetTime()
    while wait < 0 do
        wait = wait + TICK_SEC
    end
    return wait
end
