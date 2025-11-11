--- @class SmiteModule : Module
--- @diagnostic disable: duplicate-set-field
SmiteModule = setmetatable({}, { __index = Module })
SmiteModule.__index = SmiteModule

--- @return SmiteModule
function SmiteModule.new()
    --- @class SmiteModule
    return setmetatable(Module.new(Abilities.Smite.name, nil, "Interface\\Icons\\Spell_Holy_HolySmite"), SmiteModule)
end

function SmiteModule:run()
    Logging:Debug("Casting "..Abilities.Smite.name)
    CastSpellByName(Abilities.Smite.name)
end

--- @param context PriestModuleRunContext
function SmiteModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Smite.name) and context.mana > context.smiteCost then
        return 50;
    end
    return -1;
end
