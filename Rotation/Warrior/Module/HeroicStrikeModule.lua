--- @alias HeroicStrikeTrackers { autoAttackTracker: AutoAttackTracker, actionSlotTracker: ActionBarSlotTracker }
--- @class HeroicStrikeModule : Module
--- @field trackers HeroicStrikeTrackers
--- @diagnostic disable: duplicate-set-field
HeroicStrikeModule = setmetatable({}, { __index = Module })
HeroicStrikeModule.__index = HeroicStrikeModule

--- @return HeroicStrikeModule
function HeroicStrikeModule.new()
    --- @type HeroicStrikeTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.GetInstance(),
        actionSlotTracker = ActionBarSlotTracker.GetInstance()
    }
    --- @class HeroicStrikeModule
    return setmetatable(Module.new(Abilities.HeroicStrike.name, trackers, "Interface\\Icons\\Ability_Rogue_Ambush"),
        HeroicStrikeModule);
end

function HeroicStrikeModule:run()
    Logging:Debug("Casting "..Abilities.HeroicStrike.name)
    CastSpellByName(Abilities.HeroicStrike.name)
end

function HeroicStrikeModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.Cleave.name)
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:getPriority(context)
    local hsSlot = self.trackers.actionSlotTracker:GetActionBarSlot(Abilities.HeroicStrike.name)
    if self.enabled and hsSlot ~= nil and not IsCurrentAction(hsSlot) then
        if context.spec == WarriorSpec.ARMS then
            return self:GetArmsHeroicPriority(context)
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryHeroicPriority(context)
        elseif context.spec == WarriorSpec.PROT then
            return self:GetProtHeroicPriority(context)
        end
    end
    return -1;
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetArmsHeroicPriority(context)
    local msCost = ModuleRegistry:IsModuleEnabled(Abilities.MortalStrike.name) and context.msCost or 0
    local bsCost = ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name) and context.bsCost or 0
    local wwCost = ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name) and context.wwCost or 0
    local slamCost = ModuleRegistry:IsModuleEnabled(Abilities.Slam.name) and context.slamCost or 0
    if context.rage >= msCost + bsCost + wwCost + slamCost + context.hsCost then
        return 75
    end
    return -1;
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetFuryHeroicPriority(context)
    if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.6 then
        return -1;
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

    if context.rage >= (reserve + context.hsCost) then
        return 65
    end

    return -1
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetProtHeroicPriority(context)
    if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.7 then
        return -1
    end

    local btAlmostReady = Helpers:SpellAlmostReady(Abilities.Bloodthirst.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name)
    local ssAlmostReady = Helpers:SpellAlmostReady(Abilities.ShieldSlam.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name)

    local mainCost = ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name) and context.shieldSlamCost or context.bsCost
    
    local canAffordMainAndHS = context.rage >= mainCost + context.hsCost
    local rageThreshold = context.rage >= 45

    if (not (ssAlmostReady or btAlmostReady) and canAffordMainAndHS) or rageThreshold then
        return 70
    end

    return -1
end
