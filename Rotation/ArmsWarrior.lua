--- @class ArmsWarrior : ClassRotation
--- @diagnostic disable: duplicate-set-field
ArmsWarrior = setmetatable({}, { __index = ClassRotation })
ArmsWarrior.__index = ArmsWarrior

--- @return ArmsWarrior
function ArmsWarrior:new(deps)
    Logging:Log("Using Arms Warrior rotation")
    local trackers = {
        autoAttackTracker = deps.autoAttackTracker,
        overpowerTracker = deps.overpowerTracker,
    }
    return setmetatable(trackers, self)
end

function ArmsWarrior:execute()
    local rage = UnitMana("player");
    local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
    local timeToNextAttack = self.autoAttackTracker:GetWhenAvailable()
    local slamCost = Helpers:RageCost(ABILITY_SLAM);
    if Helpers:ShouldUseExecute() then
        Logging:Debug("Casting Execute")
        CastSpellByName(ABILITY_EXECUTE)
        return
    end

    if (timeToNextAttack > slamCastTime) and rage >= slamCost then
        CastSpellByName(ABILITY_SLAM)
    else
        ArmsWarrior:NoSlamWarriorRotation(rage)
    end
end

--- @param rage number
function ArmsWarrior:NoSlamWarriorRotation(rage)
    local msCost = Helpers:RageCost(ABILITY_MORTAL_STRIKE);
    local activeStance = Helpers:ActiveStance()
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if not Helpers:HasBuff("player", "Ability_Warrior_BattleShout") and rage >= 20 then
        Logging:Debug("Casting Battle Shout")
        CastSpellByName(ABILITY_BATTLE_SHOUT)
    elseif activeStance == 1 and self.overpowerTracker:IsAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and rage >= 5 then
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
