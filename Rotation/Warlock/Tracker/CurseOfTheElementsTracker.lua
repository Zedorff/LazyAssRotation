--- @class CurseOfTheElementsTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
CurseOfTheElementsTracker = setmetatable({}, { __index = DebuffTracker })
CurseOfTheElementsTracker.__index = CurseOfTheElementsTracker

--- @return CurseOfTheElementsTracker
function CurseOfTheElementsTracker.new()
    --- @class CurseOfTheElementsTracker
    local self = DebuffTracker.new(Abilities.CoE, true, "Spell_Shadow_ChillTouch")
    setmetatable(self, CurseOfTheElementsTracker)
    return self
end
