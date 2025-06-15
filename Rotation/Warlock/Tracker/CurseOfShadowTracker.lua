--- @class CurseOfShadowTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
CurseOfShadowTracker = setmetatable({}, { __index = DebuffTracker })
CurseOfShadowTracker.__index = CurseOfShadowTracker

--- @return CurseOfShadowTracker
function CurseOfShadowTracker.new()
    --- @class CurseOfShadowTracker
    local self = DebuffTracker.new(Abilities.CoS.name, "Spell_Shadow_CurseOfAchimonde")
    setmetatable(self, CurseOfShadowTracker)
    return self
end
