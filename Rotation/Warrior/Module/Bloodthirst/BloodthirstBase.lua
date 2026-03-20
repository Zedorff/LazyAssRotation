--- @class BloodthirstBase : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstBase = setmetatable({}, { __index = Module })
BloodthirstBase.__index = BloodthirstBase

--- @return BloodthirstBase
--- @param enabledByDefault boolean|nil
function BloodthirstBase.new(enabledByDefault)
    --- @class BloodthirstBase
    return setmetatable(Module.new(Abilities.Bloodthirst.name, nil, "Interface\\Icons\\Spell_Nature_Bloodlust", enabledByDefault), BloodthirstBase)
end

function BloodthirstBase:run()
    Logging:Debug("Casting "..Abilities.Bloodthirst.name)
    CastSpellByName(Abilities.Bloodthirst.name)
end

function BloodthirstBase:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.MortalStrike.name)
    ModuleRegistry:DisableModule(Abilities.ShieldSlam.name)
end

--- @param context WarriorModuleRunContext
--- @return integer
function BloodthirstBase:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Bloodthirst.name) and context.rage >= context.bsCost then
        return self:getSpecPriority(context)
    end
    return -1
end

--- @param context WarriorModuleRunContext
--- @return integer
function BloodthirstBase:getSpecPriority(context)
    return -1
end
