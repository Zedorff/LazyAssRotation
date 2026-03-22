--- @alias CurseOfRecklessnessTrackers { corTracker: CurseOfRecklessnessTracker }
--- @class CurseOfRecklessnessModule : Module
--- @field trackers CurseOfRecklessnessTrackers
--- @diagnostic disable: duplicate-set-field
CurseOfRecklessnessModule = setmetatable({}, { __index = Module })
CurseOfRecklessnessModule.__index = CurseOfRecklessnessModule

--- @return CurseOfRecklessnessModule
function CurseOfRecklessnessModule.new()
    --- @type CurseOfRecklessnessTrackers
    local trackers = {
        corTracker = CurseOfRecklessnessTracker.new()
    }
    --- @class CurseOfRecklessnessModule
    local self = Module.new(Abilities.CoR.name, trackers, "Interface\\Icons\\Spell_Shadow_UnholyStrength")
    setmetatable(self, CurseOfRecklessnessModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)
    end

    return self
end

function CurseOfRecklessnessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoE.name)
    ModuleRegistry:DisableModule(Abilities.CoS.name)
end

function CurseOfRecklessnessModule:run()
    Logging:Debug("Casting " .. Abilities.CoR.name)
    CastSpellByName(Abilities.CoR.name)
end

--- @param context WarlockModuleRunContext
function CurseOfRecklessnessModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled and Helpers:SpellReady(Abilities.CoR.name) and self.trackers.corTracker:ShouldCast() and context.mana > context.corCost then
        return 95;
    end
    return -1;
end
