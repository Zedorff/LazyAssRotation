--- @class WhirlwindBase : Module
--- @diagnostic disable: duplicate-set-field
WhirlwindBase = setmetatable({}, { __index = Module })
WhirlwindBase.__index = WhirlwindBase

--- @return WhirlwindBase
function WhirlwindBase.new()
    --- @class WhirlwindBase
    return setmetatable(Module.new(Abilities.Whirlwind.name, nil, "Interface\\Icons\\Ability_Whirlwind"), WhirlwindBase)
end

function WhirlwindBase:run()
    Logging:Debug("Casting "..Abilities.Whirlwind.name)
    CastSpellByName(Abilities.Whirlwind.name)
end

--- @param context WarriorModuleRunContext
--- @return integer
function WhirlwindBase:getPriority(context)
    if self.enabled and context.stance == 3 then
        return self:getSpecPriority(context)
    end
    return -1
end

--- @param context WarriorModuleRunContext
--- @return integer
function WhirlwindBase:getSpecPriority(context)
    return -1
end
