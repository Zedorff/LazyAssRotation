--- @class BloodthirstModule : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstModule = setmetatable({}, { __index = Module })
BloodthirstModule.__index = BloodthirstModule

--- @return BloodthirstModule
--- @param enabledByDefault boolean|nil
function BloodthirstModule.new(enabledByDefault)
    --- @class BloodthirstModule
    return setmetatable(Module.new(Abilities.Bloodthirst.name, nil, "Interface\\Icons\\Spell_Nature_Bloodlust", enabledByDefault), BloodthirstModule)
end

function BloodthirstModule:run()
    Logging:Debug("Casting "..Abilities.Bloodthirst.name)
    CastSpellByName(Abilities.Bloodthirst.name)
end

function BloodthirstModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.MortalStrike.name)
end

--- @param context WarriorModuleRunContext
function BloodthirstModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Bloodthirst.name) and context.rage >= context.bsCost then
        if context.spec == WarriorSpec.ARMS then
            return 80;
        elseif context.spec == WarriorSpec.FURY then
            return 90;
        elseif context.spec == WarriorSpec.PROT then
            return 90;
        end
    end
    return -1;
end
