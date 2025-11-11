--- @class HolyFireTracker : DotTracker
--- @field debuffProbablyUp boolean
--- @diagnostic disable: duplicate-set-field
HolyFireTracker = setmetatable({}, { __index = DotTracker })
HolyFireTracker.__index = HolyFireTracker

--- @return HolyFireTracker
function HolyFireTracker.new()
    --- @class HolyFireTracker
    local self = DotTracker.new(Abilities.HolyFire)
    setmetatable(self, HolyFireTracker)
    return self
end

