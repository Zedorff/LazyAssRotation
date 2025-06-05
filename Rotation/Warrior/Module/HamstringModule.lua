--- @class HamstringModule : Module
--- @diagnostic disable: duplicate-set-field
HamstringModule = setmetatable({}, { __index = Module })
HamstringModule.__index = HamstringModule

--- @class HamstringModule
function HamstringModule.new()
    --- @class HamstringModule
    return setmetatable(Module.new(ABILITY_HAMSTRING, nil, "Interface\\Icons\\Ability_ShockWave"), HamstringModule)
end

function HamstringModule:run()
    Logging:Debug("Casting Hamstring")
    CastSpellByName(ABILITY_HAMSTRING)
end

--- @param context WarriorModuleRunContext
function HamstringModule:getPriority(context)
    if self.enabled and context.stance ~= 2 then
        if Helpers:SpellReady(ABILITY_HAMSTRING) and context.rage >= 90 then
            return 10
        else
            return -1;
        end
    end
    return -1;
end
