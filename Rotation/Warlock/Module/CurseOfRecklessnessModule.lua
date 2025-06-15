--- @alias CurseOfRecklessnessTrackers { corTracker: CurseOfRecklessnessTracker }
--- @class CurseOfRecklessnessModule : Module
--- @field trackers CurseOfRecklessnessTrackers
--- @field allowAgonyWithOtherCurses boolean
--- @diagnostic disable: duplicate-set-field
CurseOfRecklessnessModule = setmetatable({}, { __index = Module })
CurseOfRecklessnessModule.__index = CurseOfRecklessnessModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfRecklessnessModule
function CurseOfRecklessnessModule.new(allowAgonyWithOtherCurses)
    --- @type CurseOfRecklessnessTrackers
    local trackers = {
        corTracker = CurseOfRecklessnessTracker.new()
    }
    --- @class CurseOfRecklessnessModule
    local self = Module.new(Abilities.CoR.name, trackers, "Interface\\Icons\\Spell_Shadow_UnholyStrength")
    setmetatable(self, CurseOfRecklessnessModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)

        if not self.allowAgonyWithOtherCurses then
            ModuleRegistry:DisableModule(Abilities.CoA.name)
        end
    end

    return self
end

function CurseOfRecklessnessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoE.name)
    ModuleRegistry:DisableModule(Abilities.CoS.name)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(Abilities.CoA.name)
    end
end

function CurseOfRecklessnessModule:run()
    Logging:Debug("Casting " .. Abilities.CoR.name)
    CastSpellByName(Abilities.CoR.name)
end

--- @param context WarlockModuleRunContext
function CurseOfRecklessnessModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.CoR.name) and self.trackers.corTracker:ShouldCast() and context.mana > context.corCost then
        return 95;
    end
    return -1;
end
