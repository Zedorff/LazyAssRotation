--- @class BattleShoutTracker : CooldownTracker
--- @field battleShoutIsUp boolean
--- @diagnostic disable: duplicate-set-field
BattleShoutTracker = setmetatable({}, { __index = CooldownTracker })
BattleShoutTracker.__index = BattleShoutTracker

--- @return BattleShoutTracker
function BattleShoutTracker.new()
    --- @class BattleShoutTracker
    local self = CooldownTracker.new()
    setmetatable(self, BattleShoutTracker)
    self.battleShoutIsUp = Helpers:HasBuffName("player", ABILITY_BATTLE_SHOUT)
    return self
end

function BattleShoutTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.battleShoutIsUp = Helpers:HasBuffName("player", ABILITY_BATTLE_SHOUT)
end

--- @param event string
--- @param arg1 string
function BattleShoutTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_BATTLE_SHOUT) then
        Logging:Debug(ABILITY_BATTLE_SHOUT.." is up")
        self.battleShoutIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_BATTLE_SHOUT) then
        Logging:Debug(ABILITY_BATTLE_SHOUT.." is down")
        self.battleShoutIsUp = false
    end 
end

--- @return boolean
function BattleShoutTracker:ShouldCast()
    return not self.battleShoutIsUp
end
