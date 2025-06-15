--- @alias CurseOfTheElementsTrackers { coeTracker: CurseOfTheElementsTracker }
--- @class CurseOfTheElementsModule : Module
--- @field trackers CurseOfTheElementsTrackers
--- @field allowAgonyWithOtherCurses boolean
--- @diagnostic disable: duplicate-set-field
CurseOfTheElementsModule = setmetatable({}, { __index = Module })
CurseOfTheElementsModule.__index = CurseOfTheElementsModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfTheElementsModule
function CurseOfTheElementsModule.new(allowAgonyWithOtherCurses)
    --- @type CurseOfTheElementsTrackers
    local trackers = {
        coeTracker = CurseOfTheElementsTracker.new()
    }
    --- @class CurseOfTheElementsModule
    local self = Module.new(Abilities.CoE.name, trackers, "Interface\\Icons\\Spell_Shadow_ChillTouch")
    setmetatable(self, CurseOfTheElementsModule)

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

function CurseOfTheElementsModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoR.name)
    ModuleRegistry:DisableModule(Abilities.CoS.name)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(Abilities.CoA.name)
    end
end

function CurseOfTheElementsModule:run()
    Logging:Debug("Casting " .. Abilities.CoE.name)
    CastSpellByName(Abilities.CoE.name)
end

--- @param context WarlockModuleRunContext
function CurseOfTheElementsModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.CoE.name) and self.trackers.coeTracker:ShouldCast() and context.mana > context.coeCost then
        return 95;
    end
    return -1;
end
