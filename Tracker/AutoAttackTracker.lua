MLDps = MLDps or {}
local instance = MLDps

--- @class AutoAttackTracker : CooldownTracker
--- @field lastAutoAttack number
--- @diagnostic disable: duplicate-set-field
AutoAttackTracker = setmetatable({}, { __index = CooldownTracker })
AutoAttackTracker.__index = AutoAttackTracker

--- @return AutoAttackTracker
function AutoAttackTracker:new()
    local obj = {
        lastAutoAttack = 0
    }
    return setmetatable(obj, self)
end

--- @param event string
--- @vararg any
function AutoAttackTracker:onEvent(event, ...)
    local arg1 = unpack(arg)
    if ((event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_SELF_MISSES") and string.find(arg1, CHAT_HEROIC_STRIKE))
        or (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") then
        Logging:Debug("Autoattack")
        self.lastAutoAttack = GetTime();
    end
end


--- @return boolean
function AutoAttackTracker:isAvailable()
    return true;
end

--- @return number
function AutoAttackTracker:GetWhenAvailable()
    local attackSpeed, _ = UnitAttackSpeed("player")
    local now = GetTime()
    local timeElapsed = now - self.lastAutoAttack
    local timeRemaining = attackSpeed - timeElapsed

    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end
