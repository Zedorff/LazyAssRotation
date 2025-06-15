--- @class HamstringModule : Module
--- @diagnostic disable: duplicate-set-field
HamstringModule = setmetatable({}, { __index = Module })
HamstringModule.__index = HamstringModule

--- @class HamstringModule
function HamstringModule.new()
    --- @class HamstringModule
    return setmetatable(Module.new(Abilities.Hamstring.name, nil, "Interface\\Icons\\Ability_ShockWave"), HamstringModule)
end

function HamstringModule:run()
    Logging:Debug("Casting "..Abilities.Hamstring.name)
    CastSpellByName(Abilities.Hamstring.name)
end

--- @param context WarriorModuleRunContext
function HamstringModule:getPriority(context)
    if self.enabled and context.stance ~= 2 then
        if Helpers:SpellReady(Abilities.Hamstring.name) and context.rage >= 90 then
            return 10
        else
            return -1;
        end
    end
    return -1;
end
