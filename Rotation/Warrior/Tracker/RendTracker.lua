--- @class RendTracker : DotTracker
RendTracker = setmetatable({}, { __index = DotTracker })
RendTracker.__index = RendTracker

--- @return RendTracker
function RendTracker.new()
    --- @class RendTracker
    local self = DotTracker.new(Abilities.Rend)
    setmetatable(self, RendTracker)
    return self
end
