--- @alias CurseOfAgonyTrackers { coaTracker: CurseOfAgonyTracker, castingTracker: CastingTracker }
--- @class CurseOfAgonyModule : Module
--- @field trackers CurseOfAgonyTrackers
--- @field allowAgonyWithOtherCurses boolean
--- @diagnostic disable: duplicate-set-field
CurseOfAgonyModule = setmetatable({}, { __index = Module })
CurseOfAgonyModule.__index = CurseOfAgonyModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfAgonyModule
function CurseOfAgonyModule.new(allowAgonyWithOtherCurses)
    --- @type CurseOfAgonyTrackers
    local trackers = {
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses),
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class CurseOfAgonyModule
    local self = Module.new(Abilities.CoA.name, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfSargeras")
    setmetatable(self, CurseOfAgonyModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled and not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)
        ModuleRegistry:DisableModule(Abilities.CoR.name)
    end

    return self
end

function CurseOfAgonyModule:enable()
    Module.enable(self)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)
        ModuleRegistry:DisableModule(Abilities.CoR.name)
    end
end

function CurseOfAgonyModule:run()
    _ = SpellStopCasting()
    Logging:Debug("Casting " .. Abilities.CoA.name)
    CastSpellByName(Abilities.CoA.name)
end

--- @param context WarlockModuleRunContext
function CurseOfAgonyModule:getPriority(context)
    if self.enabled
        and Helpers:SpellReady(Abilities.CoA.name)
        and self.trackers.coaTracker:ShouldCast()
        and self.trackers.castingTracker:ShouldCast()
        and context.mana > context.coaCost then
        return 60;
    end
    return -1;
end
