--- @class SunderArmorBase : Module
--- @diagnostic disable: duplicate-set-field
SunderArmorBase = setmetatable({}, { __index = Module })
SunderArmorBase.__index = SunderArmorBase

--- @return SunderArmorBase
function SunderArmorBase.new()
    --- @class SunderArmorBase
    return setmetatable(Module.new(Abilities.SunderArmor.name, nil, "Interface\\Icons\\Ability_Warrior_Sunder"), SunderArmorBase)
end

function SunderArmorBase:run()
    Logging:Debug("Casting "..Abilities.SunderArmor.name)
    CastSpellByName(Abilities.SunderArmor.name)
end

--- @param context WarriorModuleRunContext
--- @return integer
function SunderArmorBase:getPriority(context)
    if self.enabled then
        return self:getSpecPriority(context)
    end
    return -1
end

--- @param context WarriorModuleRunContext
--- @return integer
function SunderArmorBase:getSpecPriority(context)
    return -1
end
