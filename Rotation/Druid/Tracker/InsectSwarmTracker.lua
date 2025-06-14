--- @class InsectSwarmTracker : DotTracker
InsectSwarmTracker = setmetatable({}, { __index = DotTracker })
InsectSwarmTracker.__index = InsectSwarmTracker

--- @return InsectSwarmTracker
function InsectSwarmTracker.new()
    --- @class InsectSwarmTracker
    local self = DotTracker.new(24977, ABILITY_INSECT_SWARM)
    setmetatable(self, InsectSwarmTracker)
    return self
end
