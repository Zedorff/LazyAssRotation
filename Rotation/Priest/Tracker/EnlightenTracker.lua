--- @class EnlightenTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
EnlightenTracker = setmetatable({}, { __index = SelfBuffTracker })
EnlightenTracker.__index = EnlightenTracker

--- @return EnlightenTracker
function EnlightenTracker.new()
    --- @class EnlightenTracker
    local self = SelfBuffTracker.new(Abilities.Enlighten.name, "btnholyscriptures")
    setmetatable(self, EnlightenTracker)
    return self
end
