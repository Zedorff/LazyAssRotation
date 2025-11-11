--- @class InnerFireTracker : SelfBuffTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
InnerFireTracker = setmetatable({}, { __index = SelfBuffTracker })
InnerFireTracker.__index = InnerFireTracker

--- @return InnerFireTracker
function InnerFireTracker.new()
    --- @class InnerFireTracker
    local self = SelfBuffTracker.new(Abilities.InnerFire.name, "Spell_Holy_InnerFire")
    setmetatable(self, InnerFireTracker)
    return self
end
