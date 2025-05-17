Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

-- Variables
local OverpowerReadyUntil = 0;
local LastAutoAttack = 0;

function Warrior:new()
    return setmetatable({}, self)
end

function Warrior:execute()
    local rage = UnitMana("player");
    local mainSpeed, _ = UnitAttackSpeed("player")
    local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
    local timeToNextAttack = TimeToNextSwing(mainSpeed)
    local slamCost = Helpers:RageCost(ABILITY_SLAM);
    if (timeToNextAttack > slamCastTime) and rage >= slamCost then
        CastSpellByName(ABILITY_SLAM)
    else
        NoSlamWarriorRotation(rage)
    end
end

function Warrior:onEvent(event)
    if ((event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_SELF_MISSES") and string.find(arg1, CHAT_HEROIC_STRIKE)) then
        LastAutoAttack = GetTime();
    end
    if (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") then
        LastAutoAttack = GetTime();
    end

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

function TimeToNextSwing(attackSpeed)
    local now = GetTime()
    local timeElapsed = now - LastAutoAttack
    local timeRemaining = attackSpeed - timeElapsed

    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end

function OverpowerAvailable()
    if GetTime() < OverpowerReadyUntil then
        return true;
    else
        return nil;
    end
end

function NoSlamWarriorRotation(rage)
    local msCost = Helpers:RageCost(ABILITY_MORTAL_STRIKE);
    local activeStance = Helpers:ActiveStance()
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if activeStance == 1 and OverpowerAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and rage >= 5 then
        Logging:Debug("Casting overpower")
        CastSpellByName(ABILITY_OVERPOWER)
    elseif Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= msCost then
        Logging:Debug("Casting Mortal Strike")
        CastSpellByName(ABILITY_MORTAL_STRIKE)
    elseif activeStance == 3 and Helpers:SpellReady(ABILITY_WHIRLWIND) and rage >= wwCost then
        Logging:Debug("Casting whirlwind")
        CastSpellByName(ABILITY_WHIRLWIND)
    end

    if rage >= 80 then
        Logging:Debug("Queue heroic strike")
        CastSpellByName(ABILITY_HEROIC_STRIKE)
    end
end
