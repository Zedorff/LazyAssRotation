--- @alias CleaveTrackers { autoAttackTracker: AutoAttackTracker }
--- @class CleaveModule : Module
--- @field trackers CleaveTrackers
--- @diagnostic disable: duplicate-set-field
CleaveModule = setmetatable({}, { __index = Module })
CleaveModule.__index = CleaveModule

--- @return CleaveModule
function CleaveModule.new()
    --- @type CleaveTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.GetInstance()
    }
    --- @class CleaveModule
    return setmetatable(Module.new(Abilities.Cleave.name, trackers, "Interface\\Icons\\Ability_Warrior_Cleave", false),
        CleaveModule);
end

function CleaveModule:run()
    Logging:Debug("Casting "..Abilities.Cleave.name)
    CastSpellByName(Abilities.Cleave.name)
end

function CleaveModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.HeroicStrike.name)
end

--- @param context WarriorModuleRunContext
function CleaveModule:getPriority(context)
    if self.enabled then
        if context.spec == WarriorSpec.ARMS then
            return self:GetArmsCleavePriority(context)
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryCleavePriority(context)
        elseif context.spec == WarriorSpec.PROT then
            return self:GetProtCleavePriority(context)
        end
    end
    return -1;
end

function CleaveModule:isMultiCastAllowed()
    return true;
end

--- @param context WarriorModuleRunContext
function CleaveModule:GetArmsCleavePriority(context)
    if context.rage >= 70 then
        return 50
    else
        return -1;
    end
end

--- @param context WarriorModuleRunContext
function CleaveModule:GetFuryCleavePriority(context)
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

    if context.rage >= (reserve + context.cleaveCost) then
        return 65
    end

    return -1
end

--- @param context WarriorModuleRunContext
function CleaveModule:GetProtCleavePriority(context)
    if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.7 then
        return -1
    end

    local ssAlmostReady = Helpers:SpellAlmostReady(Abilities.ShieldSlam.name, 1.5)
    local canAffordSSAndCleave = context.rage >= context.shieldSlamCost + context.cleaveCost
    local rageThreshold = context.rage >= 45

    if (not ssAlmostReady and canAffordSSAndCleave) or rageThreshold then
        return 70
    end

    return -1
end
