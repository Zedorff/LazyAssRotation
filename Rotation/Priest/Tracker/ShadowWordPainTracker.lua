--- @class ShadowWordPainTracker : DotTracker
--- @diagnostic disable: duplicate-set-field
ShadowWordPainTracker = setmetatable({}, { __index = DotTracker })
ShadowWordPainTracker.__index = ShadowWordPainTracker

--- @return ShadowWordPainTracker
function ShadowWordPainTracker.new()
    --- @class ShadowWordPainTracker
    local self = DotTracker.new(Abilities.ShadowWordPain)
    setmetatable(self, ShadowWordPainTracker)
    return self
end

