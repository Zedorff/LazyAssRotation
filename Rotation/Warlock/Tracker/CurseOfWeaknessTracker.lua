--- @class CurseOfWeaknessTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
CurseOfWeaknessTracker = setmetatable({}, { __index = DebuffTracker })
CurseOfWeaknessTracker.__index = CurseOfWeaknessTracker

--- @return CurseOfWeaknessTracker
function CurseOfWeaknessTracker.new()
    --- @class CurseOfWeaknessTracker
    local self = DebuffTracker.new(ABILITY_COW, "Spell_Shadow_CurseOfMannoroth")
    setmetatable(self, CurseOfWeaknessTracker)
    return self
end
