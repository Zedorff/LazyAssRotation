--- @class WhirlwindModule : Module
--- @diagnostic disable: duplicate-set-field
WhirlwindModule = setmetatable({}, { __index = Module })
WhirlwindModule.__index = WhirlwindModule

--- @return WhirlwindModule 
function WhirlwindModule.new()
    --- @class WhirlwindModule
    return setmetatable(Module.new(ABILITY_WHIRLWIND, nil, "Interface\\Icons\\Ability_Whirlwind"), WhirlwindModule)
end

function WhirlwindModule:run()
    Logging:Debug("Casting Whirlwind")
    CastSpellByName(ABILITY_WHIRLWIND)
end

--- @param context WarriorModuleRunContext
function WhirlwindModule:getPriority(context)
    if self.enabled and context.stance == 3 then
        if context.spec == WarriorSpec.ARMS then
            return self:GetArmsWhirlwindPriority(context)
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryWhirlwindPriority(context)
        else
            return -1;
        end
    else
        return -1;
    end
end

--- @param context WarriorModuleRunContext
function WhirlwindModule:GetArmsWhirlwindPriority(context)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellAlmostReady(ABILITY_MORTAL_STRIKE, 0.5) and context.rage >= context.wwCost then
        return 70
    else
        return -1;
    end
end

--- @param context WarriorModuleRunContext
function WhirlwindModule:GetFuryWhirlwindPriority(context)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellAlmostReady(ABILITY_BLOODTHIRST, 0.5) and context.rage >= context.wwCost then
        return 70
    else
        return -1;
    end
end
