Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

-- Variables
local OverpowerReadyUntil = 0;
local LastAutoAttack = 0;
local SlamIsCasting = false;

function Warrior:new()
    return setmetatable({}, self)
end

function Warrior:execute()
    local rage = UnitMana("player");
    local mainSpeed, offSpeed = UnitAttackSpeed("player")
    local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
    local timeToNextAttack = TimeToNextSwing(mainSpeed)
    local slamCost = Helpers:RageCost(ABILITY_SLAM);
    if (timeToNextAttack > slamCastTime) and not SlamIsCasting and rage >= slamCost then
        CastSlam()
    else
        NoSlamWarriorRotation(rage)
    end

    if not SlamIsCasting then
        NoSlamWarriorRotation(rage)
    end
end

function Warrior:onEvent(event)
    if (event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_COMBAT_SELF_HITS") then
        SlamIsCasting = false;
        LastAutoAttack = GetTime();
    end

    if (event == "CHAT_MSG_SPELL_SELF_DAMAGE"
            or event == "CHAT_MSG_SPELL_SELF_BUFF"
            or event == "CHAT_MSG_SPELL_SELF_MISSES") then
        if string.find(arg1, "Slam") then
            Common:Debug("Slam CASTED")
            SlamIsCasting = false;
        end
    end

    if (event == "CHAT_MSG_COMBAT_SELF_MISSES"
            or event == "CHAT_MSG_SPELL_SELF_DAMAGE"
            or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF")
        and (string.find(arg1, CHAT_DODGE_OVERPOWER) or string.find(arg1, CHAT_DODGE_OVERPOWER2)) then
        Common:Debug("Overpower ready");
        OverpowerReadyUntil = GetTime() + 5;
    elseif event == "PLAYER_TARGET_CHANGED" then
        OverpowerReadyUntil = 0
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE"
        and (string.find(arg1, CHAT_OVERPOWER1)
            or string.find(arg1, CHAT_OVERPOWER2)
            or string.find(arg1, CHAT_OVERPOWER3)) then
        Common:Debug("Overpower used")
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

function CastSlam()
    Common:Debug("Casting Slam")
    CastSpellByName(ABILITY_SLAM)
    SlamIsCasting = true
end

function NoSlamWarriorRotation(rage)
    local slamCost = Helpers:RageCost(ABILITY_SLAM);
    local msCost = Helpers:RageCost(ABILITY_MORTAL_STRIKE);
    local rendCost = Helpers:RageCost(ABILITY_REND);
    if OverpowerAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and rage >= 5 then
        Common:Debug("Casting overpower")
        CastSpellByName(ABILITY_OVERPOWER)
    end

    -- 2. While casting Slam, use Heroic Strike if you have rage
    if rage >= 80 then
        Common:Debug("Queue heroic strike")
        CastSpellByName(ABILITY_HEROIC_STRIKE)
    end

    -- 3. Cast Mortal Strike during Slam if still inside bounds and enough rage
    if Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= msCost + slamCost then
        Common:Debug("Casting Mortal Strike")
        CastSpellByName(ABILITY_MORTAL_STRIKE)
    end

    -- 4. Apply Rend if not on target and time still allows before next swing
    if rage >= slamCost + rendCost and not Helpers:HasDebuff("target", "Ability_Gouge") then
        Common:Debug("Casting rend")
        CastSpellByName(ABILITY_REND)
    end
end
