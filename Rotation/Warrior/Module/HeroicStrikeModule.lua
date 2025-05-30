--- @class HeroicStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
HeroicStrikeModule = setmetatable({}, { __index = Module })
HeroicStrikeModule.__index = HeroicStrikeModule

--- @return HeroicStrikeModule 
function HeroicStrikeModule.new()
    --- @class HeroicStrikeModule
    return setmetatable(Module.new(ABILITY_HEROIC_STRIKE, nil, "Interface\\Icons\\Ability_Rogue_Ambush"), HeroicStrikeModule);
end

function HeroicStrikeModule:run()
    Logging:Debug("Casting Heroic Strike")
    CastSpellByName(ABILITY_HEROIC_STRIKE)
end

--- @param context WarriorModuleRunContext
function HeroicStrikeModule:getPriority(context)
    if self.enabled then
        if context.spec == WarriorSpec.ARMS then
            return self:GetArmsHeroicPriority(context.rage)
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryHeroicPriority(context.rage, context)
        elseif context.spec == WarriorSpec.PROT then
            return self:GetProtHeroicPriority(context.rage, context)
        end
    end
    return -1;
end

--- @param rage integer
function HeroicStrikeModule:GetArmsHeroicPriority(rage)
    if rage >= 80 then
        return 50
    else
        return -1;
    end
end

--- @param rage integer
--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetFuryHeroicPriority(rage, context)
    if Helpers:SpellReady(ABILITY_HEROIC_STRIKE) and rage >= context.bsCost + context.wwCost then
        return 50
    else
        return -1;
    end
end

--- @param rage integer
--- @param context WarriorModuleRunContext
function HeroicStrikeModule:GetProtHeroicPriority(rage, context)
    if Helpers:SpellReady(ABILITY_HEROIC_STRIKE) and rage >= context.shieldSlamCost + context.hsCost then
        return 70
    else
        return -1;
    end
end
