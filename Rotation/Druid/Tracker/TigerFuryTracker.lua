--- @class TigerFuryTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
TigerFuryTracker = setmetatable({}, { __index = SelfBuffTracker })
TigerFuryTracker.__index = TigerFuryTracker

--- @return TigerFuryTracker
function TigerFuryTracker.new()
    --- @class TigerFuryTracker
    local self = SelfBuffTracker.new("Blood Frenzy", "Ability_GhoulFrenzy")
    setmetatable(self, TigerFuryTracker)
    return self
end
