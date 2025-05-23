--- @class HeroicStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
HeroicStrikeModule = setmetatable({}, { __index = Module })
HeroicStrikeModule.__index = HeroicStrikeModule


function HeroicStrikeModule.new()
    return setmetatable(Module.new(ABILITY_HEROIC_STRIKE), HeroicStrikeModule);
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
            return self:GetFuryHeroicPriority(context.rage)
        else
            return -1;
        end
    else
        return -1;
    end
end

function HeroicStrikeModule:GetArmsHeroicPriority(rage)
    if rage >= 80 then
        return 50
    else
        return -1;
    end
end

function HeroicStrikeModule:GetFuryHeroicPriority(rage)
    local bsCost = Helpers:RageCost(ABILITY_BLOODTHIRST)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if Helpers:SpellReady(ABILITY_HEROIC_STRIKE) and rage >= bsCost + wwCost then
        return 50
    else
        return -1;
    end
end
