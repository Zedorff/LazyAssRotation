--- Shared priority logic for next-swing abilities (Heroic Strike, Cleave).
--- @class OnNextSwingPriority
OnNextSwingPriority = {}

--- @param context WarriorModuleRunContext
--- @param abilityCost integer Rage cost of the ability (e.g. hsCost, cleaveCost)
--- @return integer Priority or -1
function OnNextSwingPriority.GetArmsPriority(context, abilityCost)
    local msCost = ModuleRegistry:IsModuleEnabled(Abilities.MortalStrike.name) and context.msCost or 0
    local bsCost = ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name) and context.bsCost or 0
    local wwCost = ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name) and context.wwCost or 0
    local slamCost = ModuleRegistry:IsModuleEnabled(Abilities.Slam.name) and context.slamCost or 0
    if context.rage >= msCost + bsCost + wwCost + slamCost + abilityCost then
        return 75
    end
    return -1
end

--- @param module Module with trackers.autoAttackTracker
--- @param context WarriorModuleRunContext
--- @param abilityCost integer Rage cost of the ability
--- @return integer Priority or -1
function OnNextSwingPriority.GetFuryPriority(module, context, abilityCost)
    if module.trackers.autoAttackTracker:GetNextSwingTime() > 0.6 then
        return -1
    end

    local btCD      = Helpers:SpellNotReadyFor(Abilities.Bloodthirst.name)
    local wwCD      = Helpers:SpellNotReadyFor(Abilities.Whirlwind.name)
    local GCD = 1.5
    local btReady   = btCD <= GCD and ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name)
    local wwReady   = wwCD <= GCD and ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name)
    local bothSoon  = btReady and wwReady and math.abs(btCD - wwCD) < GCD

    local reserve   = 0
    if bothSoon then
        reserve = context.bsCost + context.wwCost
    elseif btReady then
        reserve = context.bsCost
    elseif wwReady then
        reserve = context.wwCost
    end

    if context.rage >= (reserve + abilityCost) then
        return 65
    end

    return -1
end

--- @param module Module with trackers.autoAttackTracker
--- @param context WarriorModuleRunContext
--- @param abilityCost integer Rage cost of the ability
--- @return integer Priority or -1
function OnNextSwingPriority.GetProtPriority(module, context, abilityCost)
    if module.trackers.autoAttackTracker:GetNextSwingTime() > 0.7 then
        return -1
    end

    local btAlmostReady = Helpers:SpellAlmostReady(Abilities.Bloodthirst.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name)
    local ssAlmostReady = Helpers:SpellAlmostReady(Abilities.ShieldSlam.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name)

    local mainCost = ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name) and context.shieldSlamCost or context.bsCost

    local canAffordMainAndAbility = context.rage >= mainCost + abilityCost
    local rageThreshold = context.rage >= 45

    if (not (ssAlmostReady or btAlmostReady) and canAffordMainAndAbility) or rageThreshold then
        return 70
    end

    return -1
end
