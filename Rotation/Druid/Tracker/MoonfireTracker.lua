--- @class MoonfireTracker : DotTracker
MoonfireTracker = setmetatable({}, { __index = DotTracker })
MoonfireTracker.__index = MoonfireTracker

--- @return MoonfireTracker
function MoonfireTracker.new()
    --- @class MoonfireTracker
    local self = DotTracker.new(9835, ABILITY_MOONFIRE)
    setmetatable(self, MoonfireTracker)
    return self
end
