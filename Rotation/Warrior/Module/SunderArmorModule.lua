--- @class SunderArmorModule : Module
--- @diagnostic disable: duplicate-set-field
SunderArmorModule = setmetatable({}, { __index = Module })
SunderArmorModule.__index = SunderArmorModule

--- @return SunderArmorModule
function SunderArmorModule.new()
    --- @class SunderArmorModule
    return setmetatable(Module.new(ABILITY_SUNDER_ARMOR, nil, "Interface\\Icons\\Ability_Warrior_Sunder"), SunderArmorModule)
end

function SunderArmorModule:run()
    Logging:Debug("Casting "..ABILITY_SUNDER_ARMOR)
    CastSpellByName(ABILITY_SUNDER_ARMOR)
end

--- @param context WarriorModuleRunContext
function SunderArmorModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(ABILITY_SUNDER_ARMOR) and context.rage >= 80 then
            return 50;
        end
    end
    return -1;
end
