--- @class BloodthirstModule : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstModule = setmetatable({}, { __index = Module })
BloodthirstModule.__index = BloodthirstModule

--- @return BloodthirstModule
function BloodthirstModule.new()
    --- @class BloodthirstModule
    return setmetatable(Module.new(ABILITY_BLOODTHIRST), BloodthirstModule)
end

function BloodthirstModule:run()
    Logging:Debug("Casting Bloodthirst")
    CastSpellByName(ABILITY_BLOODTHIRST)
end

--- @param context WarriorModuleRunContext
function BloodthirstModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(ABILITY_BLOODTHIRST) and context.rage >= context.bsCost then
            return 90;
        else
            return -1;
        end
    else
        return -1;
    end
end
