--- @class ShadowformTracker : SelfBuffTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
ShadowformTracker = setmetatable({}, { __index = SelfBuffTracker })
ShadowformTracker.__index = ShadowformTracker
--- @return ShadowformTracker
function ShadowformTracker.new()
    --- @class ShadowformTracker
    local self = SelfBuffTracker.new(Abilities.Shadowform.name, "Spell_Shadow_Shadowform")
    setmetatable(self, ShadowformTracker)
    return self
end
