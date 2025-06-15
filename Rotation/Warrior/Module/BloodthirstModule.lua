--- @class BloodthirstModule : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstModule = setmetatable({}, { __index = Module })
BloodthirstModule.__index = BloodthirstModule

--- @return BloodthirstModule
function BloodthirstModule.new()
    --- @class BloodthirstModule
    return setmetatable(Module.new(Abilities.Bloodthirst.name, nil, "Interface\\Icons\\Spell_Nature_Bloodlust"), BloodthirstModule)
end

function BloodthirstModule:run()
    Logging:Debug("Casting "..Abilities.Bloodthirst.name)
    CastSpellByName(Abilities.Bloodthirst.name)
end

--- @param context WarriorModuleRunContext
function BloodthirstModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(Abilities.Bloodthirst.name) and context.rage >= context.bsCost then
            return 90;
        end
    end
    return -1;
end
