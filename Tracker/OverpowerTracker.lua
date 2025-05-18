---@diagnostic disable: duplicate-set-field
OverpowerTracker = setmetatable({}, { __index = CooldownTracker })
OverpowerTracker.__index = OverpowerTracker

-- Variables
local OverpowerReadyUntil = 0;

function OverpowerTracker:new()
    return setmetatable({}, self)
end

function OverpowerTracker:onEvent(event)
    if (event == "CHAT_MSG_COMBAT_SELF_MISSES"
            or event == "CHAT_MSG_SPELL_SELF_DAMAGE"
            or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
        and (string.find(arg1, CHAT_DODGE_OVERPOWER) or string.find(arg1, CHAT_DODGE_OVERPOWER2)) then
        OverpowerReadyUntil = GetTime() + 5;
    elseif event == "PLAYER_TARGET_CHANGED" then
        OverpowerReadyUntil = 0
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE"
        and (string.find(arg1, CHAT_OVERPOWER1)
            or string.find(arg1, CHAT_OVERPOWER2)
            or string.find(arg1, CHAT_OVERPOWER3)) then
        OverpowerReadyUntil = 0
    end
end

function OverpowerTracker:isAvailable()
    if GetTime() < OverpowerReadyUntil then
        return true;
    else
        return nil;
    end
end

function OverpowerTracker:GetWhenAvailable()
    return OverpowerReadyUntil;
end
