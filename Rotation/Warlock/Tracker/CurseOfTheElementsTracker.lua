--- @class CurseOfTheElementsTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
CurseOfTheElementsTracker = setmetatable({}, { __index = DebuffTracker })
CurseOfTheElementsTracker.__index = CurseOfTheElementsTracker

--- @return CurseOfTheElementsTracker
function CurseOfTheElementsTracker.new()
    --- @class CurseOfTheElementsTracker
    local self = DebuffTracker.new(ABILITY_COE, "Spell_Shadow_ChillTouch")
    setmetatable(self, CurseOfTheElementsTracker)
    return self
end
