--- @class MaulModule : Module
--- @diagnostic disable: duplicate-set-field
MaulModule = setmetatable({}, { __index = Module })
MaulModule.__index = MaulModule

--- @return MaulModule
function MaulModule.new()
    --- @class MaulModule
    return setmetatable(Module.new(ABILITY_MAUL, trackers, "Interface\\Icons\\Ability_Druid_Maul"), MaulModule)
end

function MaulModule:run()
    Logging:Debug("Casting "..ABILITY_MAUL)
    CastSpellByName(ABILITY_MAUL)
end

--- @param context DruidModuleRunContext
function MaulModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_MAUL) then
        if context.rage >= context.maulCost then
            return 70;
        end
    end
    return -1;
end
