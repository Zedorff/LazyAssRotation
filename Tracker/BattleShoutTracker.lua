MLDps = MLDps or {}
local global = MLDps

--- @class BattleShoutTracker : CooldownTracker
--- @field battleShoutIsUp boolean
--- @diagnostic disable: duplicate-set-field
BattleShoutTracker = setmetatable({}, { __index = CooldownTracker })
BattleShoutTracker.__index = BattleShoutTracker

function BattleShoutTracker:new()
    local obj = {
        battleShoutIsUp = Helpers:HasBuff("player", "Ability_Warrior_BattleShout")
    }

    local instance = setmetatable(obj, BattleShoutTracker)

    global.eventBus:subscribe(function(event, arg1)
        instance:onEvent(event, arg1)
    end)

    return instance
end

--- @param event string
--- @param arg1 string
function BattleShoutTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Battle Shout") then
        Logging:Debug("Battle Shout is up")
        self.battleShoutIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Battle Shout") then
        Logging:Debug("Battle Shout is down")
        self.battleShoutIsUp = false
    end 
end

--- @return boolean
function BattleShoutTracker:isAvailable()
    return not self.battleShoutIsUp
end

--- @return number
function BattleShoutTracker:GetWhenAvailable()
    return 0;
end
