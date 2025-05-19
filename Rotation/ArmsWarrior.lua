MLDps = MLDps or {}
local global = MLDps

--- @class ArmsWarrior : ClassRotation
--- @field autoAttackTracker AutoAttackTracker
--- @field overpowerTracker OverpowerTracker
--- @field rendTracker RendTracker
--- @diagnostic disable: duplicate-set-field
ArmsWarrior = setmetatable({}, { __index = ClassRotation })
ArmsWarrior.__index = ArmsWarrior

--- @return ArmsWarrior
function ArmsWarrior:new()
    Logging:Log("Using Arms Warrior rotation")
    local trackers = {
        autoAttackTracker = AutoAttackTracker:new(),
        overpowerTracker = OverpowerTracker:new(),
        rendTracker = RendTracker:new(),
    }
    table.insert(global.trackers, trackers.autoAttackTracker)
    table.insert(global.trackers, trackers.overpowerTracker)
    table.insert(global.trackers, trackers.rendTracker)
    return setmetatable(trackers, self)
end

function ArmsWarrior:execute()
    local rage = UnitMana("player");
    local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
    local timeToNextAttack = self.autoAttackTracker:GetWhenAvailable()
    local slamCost = Helpers:RageCost(ABILITY_SLAM);
    local shoutCost = Helpers:RageCost(ABILITY_BATTLE_SHOUT)
    
    if not CheckInteractDistance("target", 3) then
        if not Helpers:HasBuff("player", "Ability_Warrior_BattleShout") and rage >= shoutCost then
            Logging:Debug("Casting Battle Shout")
            CastSpellByName(ABILITY_BATTLE_SHOUT)
        end
        Logging:Debug("Too far away!")
        return
    end

    if Helpers:ShouldUseExecute() then
        Logging:Debug("Casting Execute")
        CastSpellByName(ABILITY_EXECUTE)
        return
    end

    if (timeToNextAttack > slamCastTime) and rage >= slamCost then
        Logging:Debug("Casting Slam")
        CastSpellByName(ABILITY_SLAM)
    else
        self:NoSlamWarriorRotation(rage)
    end
end

--- @param rage number
function ArmsWarrior:NoSlamWarriorRotation(rage)
    local msCost = Helpers:RageCost(ABILITY_MORTAL_STRIKE);
    local activeStance = Helpers:ActiveStance()
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    local rendCost = Helpers:RageCost(ABILITY_REND)
    if not Helpers:HasBuff("player", "Ability_Warrior_BattleShout") and rage >= 20 then
        Logging:Debug("Casting Battle Shout")
        CastSpellByName(ABILITY_BATTLE_SHOUT)
    end
    
    if activeStance == 1 and self.overpowerTracker:isAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and rage >= 5 then
        Logging:Debug("Casting overpower")
        CastSpellByName(ABILITY_OVERPOWER)
    elseif Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= msCost then
        Logging:Debug("Casting Mortal Strike")
        CastSpellByName(ABILITY_MORTAL_STRIKE)
    elseif activeStance == 3 and Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= wwCost then
        Logging:Debug("Casting whirlwind")
        CastSpellByName(ABILITY_WHIRLWIND)
    elseif activeStance == 1 and self.rendTracker:isAvailable() and not Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage>= rendCost then
        Logging:Debug("Casting rend")
        CastSpellByName(ABILITY_REND)
    end

    if rage >= 80 then
        Logging:Debug("Queue heroic strike")
        CastSpellByName(ABILITY_HEROIC_STRIKE)
    end
end
