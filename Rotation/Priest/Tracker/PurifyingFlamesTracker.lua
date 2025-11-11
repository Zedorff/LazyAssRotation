--- @class PurifyingFlamesTracker : DurationedSelfBuffTracker
--- @diagnostic disable: duplicate-set-field
PurifyingFlamesTracker = setmetatable({}, { __index = DurationedSelfBuffTracker })
PurifyingFlamesTracker.__index = PurifyingFlamesTracker

--- @return PurifyingFlamesTracker
function PurifyingFlamesTracker.new()
    --- @class PurifyingFlamesTracker
    local self = DurationedSelfBuffTracker.new("Purifying Flames", "Spell_Holy_SearingLight", 10)
    setmetatable(self, PurifyingFlamesTracker)
    return self
end
