--- @class AutoAttackTracker : CooldownTracker
--- @diagnostic disable: duplicate-set-field
AutoAttackTracker = setmetatable({}, { __index = CooldownTracker })
AutoAttackTracker.__index = AutoAttackTracker

-- Variables
local LastAutoAttack = 0;

--- @return AutoAttackTracker
function AutoAttackTracker:new()
    return setmetatable({}, self)
end

---@param event string
function AutoAttackTracker:onEvent(event)
    if ((event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_SELF_MISSES") and string.find(arg1, CHAT_HEROIC_STRIKE))
        or (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") then
        LastAutoAttack = GetTime();
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
    local timeElapsed = now - LastAutoAttack
    local timeRemaining = attackSpeed - timeElapsed

    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end
