--- @class ChastiseHasteTracker : SelfBuffTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
ChastiseHasteTracker = setmetatable({}, { __index = SelfBuffTracker })
ChastiseHasteTracker.__index = ChastiseHasteTracker

--- @return ChastiseHasteTracker
function ChastiseHasteTracker.new()
    --- @class ChastiseHasteTracker
    local self = SelfBuffTracker.new("Chastise Haste", "Spell_Nature_Invisibilty")
    setmetatable(self, ChastiseHasteTracker)
    return self
end
