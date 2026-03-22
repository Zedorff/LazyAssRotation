--- @alias CurseOfWeaknessTrackers { cowTracker: CurseOfWeaknessTracker }
--- @class CurseOfWeaknessModule : Module
--- @field trackers CurseOfWeaknessTrackers
--- @diagnostic disable: duplicate-set-field
CurseOfWeaknessModule = setmetatable({}, { __index = Module })
CurseOfWeaknessModule.__index = CurseOfWeaknessModule

--- @return CurseOfWeaknessModule
function CurseOfWeaknessModule.new()
    --- @type CurseOfWeaknessTrackers
    local trackers = {
        cowTracker = CurseOfWeaknessTracker.new()
    }
    --- @class CurseOfWeaknessModule
    local self = Module.new(Abilities.CoW.name, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfMannoroth")
    setmetatable(self, CurseOfWeaknessModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoR.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)
    end

    return self
end

function CurseOfWeaknessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoR.name)
    ModuleRegistry:DisableModule(Abilities.CoE.name)
    ModuleRegistry:DisableModule(Abilities.CoS.name)
end

function CurseOfWeaknessModule:run()
    Logging:Debug("Casting " .. Abilities.CoW.name)
    CastSpellByName(Abilities.CoW.name)
end

--- @param context WarlockModuleRunContext
function CurseOfWeaknessModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled and Helpers:SpellReady(Abilities.CoW.name) and self.trackers.cowTracker:ShouldCast() and context.mana > context.cowCost then
        return 95;
    end
    return -1;
end
