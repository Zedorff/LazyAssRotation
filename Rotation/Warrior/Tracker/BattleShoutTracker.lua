--- @class BattleShoutTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
BattleShoutTracker = setmetatable({}, { __index = SelfBuffTracker })
BattleShoutTracker.__index = BattleShoutTracker

--- @return BattleShoutTracker
function BattleShoutTracker.new()
    --- @class BattleShoutTracker
    local self = SelfBuffTracker.new(Abilities.BattleShout.name, "Ability_Warrior_BattleShout")
    setmetatable(self, BattleShoutTracker)
    return self
end
