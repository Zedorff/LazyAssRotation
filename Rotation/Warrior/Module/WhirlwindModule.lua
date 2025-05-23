--- @class WhirlwindModule : Module
--- @diagnostic disable: duplicate-set-field
WhirlwindModule = setmetatable({}, { __index = Module })
WhirlwindModule.__index = WhirlwindModule

function WhirlwindModule.new()
    return setmetatable(Module.new(ABILITY_WHIRLWIND), WhirlwindModule)
end

function WhirlwindModule:run()
    Logging:Debug("Casting Whirlwind")
    CastSpellByName(ABILITY_WHIRLWIND)
end

--- @param context WarriorModuleRunContext
function WhirlwindModule:getPriority(context)
    if self.enabled and context.stance == 3 then
        if context.spec == WarriorSpec.ARMS then
            return self:GetArmsWhirlwindPriority(context.rage)
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryWhirlwindPriority(context.rage)
        else
            return -1;
        end
    else
        return -1;
    end
end

function WhirlwindModule:GetArmsWhirlwindPriority(rage)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= wwCost then
        return 70
    else
        return -1;
    end
end

function WhirlwindModule:GetFuryWhirlwindPriority(rage)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_BLOODTHIRST) and rage >= wwCost then
        return 70
    else
        return -1;
    end
end
