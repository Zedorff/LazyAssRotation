--- @class SunderArmorModule : Module
--- @diagnostic disable: duplicate-set-field
SunderArmorModule = setmetatable({}, { __index = Module })
SunderArmorModule.__index = SunderArmorModule

--- @return SunderArmorModule
function SunderArmorModule.new()
    --- @class SunderArmorModule
    return setmetatable(Module.new(Abilities.SunderArmor.name, nil, "Interface\\Icons\\Ability_Warrior_Sunder"), SunderArmorModule)
end

function SunderArmorModule:run()
    Logging:Debug("Casting "..Abilities.SunderArmor.name)
    CastSpellByName(Abilities.SunderArmor.name)
end

--- @param context WarriorModuleRunContext
function SunderArmorModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(Abilities.SunderArmor.name) and context.rage >= 80 then
            return 50;
        end
    end
    return -1;
end
