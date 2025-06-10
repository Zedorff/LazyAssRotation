--- @alias CurseOfAgonyTrackers { coaTracker: CurseOfAgonyTracker, channelingTracker: ChannelingTracker }
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
        channelingTracker = ChannelingTracker.GetInstance()
    }
    --- @class CurseOfAgonyModule
    local self = Module.new(ABILITY_COA, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfSargeras")
    setmetatable(self, CurseOfAgonyModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled and not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COW)
        ModuleRegistry:DisableModule(ABILITY_COE)
        ModuleRegistry:DisableModule(ABILITY_COS)
        ModuleRegistry:DisableModule(ABILITY_COR)
    end

    return self
end

function CurseOfAgonyModule:enable()
    Module.enable(self)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COW)
        ModuleRegistry:DisableModule(ABILITY_COE)
        ModuleRegistry:DisableModule(ABILITY_COS)
        ModuleRegistry:DisableModule(ABILITY_COR)
    end
end

function CurseOfAgonyModule:run()
    _ = SpellStopCasting()
    Logging:Debug("Casting " .. ABILITY_COA)
    CastSpellByName(ABILITY_COA)
end

--- @param context WarlockModuleRunContext
function CurseOfAgonyModule:getPriority(context)
    if self.enabled
        and Helpers:SpellReady(ABILITY_COA)
        and self.trackers.coaTracker:ShouldCast()
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana > context.coaCost then
        return 60;
    end
    return -1;
end
