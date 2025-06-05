--- @alias HeroicStrikeTrackers { autoAttackTracker: AutoAttackTracker }
--- @class HeroicStrikeModule : Module
--- @field trackers HeroicStrikeTrackers
--- @diagnostic disable: duplicate-set-field
HeroicStrikeModule = setmetatable({}, { __index = Module })
HeroicStrikeModule.__index = HeroicStrikeModule

--- @return HeroicStrikeModule
function HeroicStrikeModule.new()
    --- @type HeroicStrikeTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.new()
    }
    --- @class HeroicStrikeModule
    return setmetatable(Module.new(ABILITY_HEROIC_STRIKE, trackers, "Interface\\Icons\\Ability_Rogue_Ambush"),
        HeroicStrikeModule);
end

function HeroicStrikeModule:run()
    Logging:Debug("Casting Heroic Strike")
    CastSpellByName(ABILITY_HEROIC_STRIKE)
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:getPriority(context)
    if self.enabled then
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
    if context.rage >= 80 then
        return 50
    else
        return -1;
    end
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetFuryHeroicPriority(context)
    local btCD      = Helpers:SpellNotReadyFor(ABILITY_BLOODTHIRST)
    local wwCD      = Helpers:SpellNotReadyFor(ABILITY_WHIRLWIND)
    --- since we don't have reliable way to detect OH auto attacks, let's just use 2s await
    local awaitTime = 2
    local btReady   = btCD <= awaitTime and ModuleRegistry:IsModuleEnabled(ABILITY_BLOODTHIRST)
    local wwReady   = wwCD <= awaitTime and ModuleRegistry:IsModuleEnabled(ABILITY_WHIRLWIND)
    local bothSoon  = btReady and wwReady and math.abs(btCD - wwCD) < awaitTime

    local reserve   = context.hsCost
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
    local nextSwing = self.trackers.autoAttackTracker:GetNextSwingTime()
    if nextSwing > 0.7 then
        return -1
    end

    local ssAlmostReady = Helpers:SpellAlmostReady(ABILITY_SHIELD_SLAM, 1.0)
    local canAffordSSAndHS = context.rage >= context.shieldSlamCost + context.hsCost
    local rageThreshold = context.rage >= 45

    if (not ssAlmostReady and canAffordSSAndHS) or rageThreshold then
        return 70
    end

    return -1
end
