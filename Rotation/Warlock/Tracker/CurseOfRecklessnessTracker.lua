--- @class CurseOfRecklessnessTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
CurseOfRecklessnessTracker = setmetatable({}, { __index = DebuffTracker })
CurseOfRecklessnessTracker.__index = CurseOfRecklessnessTracker

--- @return CurseOfRecklessnessTracker
function CurseOfRecklessnessTracker.new()
    --- @class CurseOfRecklessnessTracker
    local self = DebuffTracker.new(Abilities.CoR.name, "Spell_Shadow_UnholyStrength")
    setmetatable(self, CurseOfRecklessnessTracker)
    return self
end
