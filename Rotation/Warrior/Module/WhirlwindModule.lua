--- @class WhirlwindModule : Module
--- @diagnostic disable: duplicate-set-field
WhirlwindModule = setmetatable({}, { __index = Module })
WhirlwindModule.__index = WhirlwindModule

--- @return WhirlwindModule 
function WhirlwindModule.new()
    --- @class WhirlwindModule
    return setmetatable(Module.new(Abilities.Whirlwind.name, nil, "Interface\\Icons\\Ability_Whirlwind"), WhirlwindModule)
end

function WhirlwindModule:run()
    Logging:Debug("Casting "..Abilities.Whirlwind.name)
    CastSpellByName(Abilities.Whirlwind.name)
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
    if Helpers:SpellReady(Abilities.Whirlwind.name) and not Helpers:SpellAlmostReady(Abilities.MortalStrike.name, 0.5) and context.rage >= context.wwCost then
        return 70
    else
        return -1;
    end
end

--- @param context WarriorModuleRunContext
function WhirlwindModule:GetFuryWhirlwindPriority(context)
    if Helpers:SpellReady(Abilities.Whirlwind.name) and not Helpers:SpellAlmostReady(Abilities.Bloodthirst.name, 0.5) and context.rage >= context.wwCost then
        return 70
    else
        return -1;
    end
end
