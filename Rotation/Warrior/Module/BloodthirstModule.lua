--- @class BloodthirstModule : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstModule = setmetatable({}, { __index = Module })
BloodthirstModule.__index = BloodthirstModule

--- @return BloodthirstModule
function BloodthirstModule.new()
    --- @class BloodthirstModule
    return setmetatable(Module.new(ABILITY_BLOODTHIRST, nil, "Interface\\Icons\\Spell_Nature_Bloodlust"), BloodthirstModule)
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
        end
    end
    return -1;
end
