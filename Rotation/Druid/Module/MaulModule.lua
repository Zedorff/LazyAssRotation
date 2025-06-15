--- @class MaulModule : Module
--- @diagnostic disable: duplicate-set-field
MaulModule = setmetatable({}, { __index = Module })
MaulModule.__index = MaulModule

--- @return MaulModule
function MaulModule.new()
    --- @class MaulModule
    return setmetatable(Module.new(Abilities.Maul.name, trackers, "Interface\\Icons\\Ability_Druid_Maul"), MaulModule)
end

function MaulModule:run()
    Logging:Debug("Casting "..Abilities.Maul.name)
    CastSpellByName(Abilities.Maul.name)
end

--- @param context DruidModuleRunContext
function MaulModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Maul.name) then
        if context.rage >= context.maulCost then
            return 70;
        end
    end
    return -1;
end
