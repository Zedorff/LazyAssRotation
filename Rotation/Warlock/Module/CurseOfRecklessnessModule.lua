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
    local self = Module.new(ABILITY_COR, trackers, "Interface\\Icons\\Spell_Shadow_UnholyStrength")
    setmetatable(self, CurseOfRecklessnessModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_COW)
        ModuleRegistry:DisableModule(ABILITY_COE)
        ModuleRegistry:DisableModule(ABILITY_COS)

        if not self.allowAgonyWithOtherCurses then
            ModuleRegistry:DisableModule(ABILITY_COA)
        end
    end

    return self
end

function CurseOfRecklessnessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_COW)
    ModuleRegistry:DisableModule(ABILITY_COE)
    ModuleRegistry:DisableModule(ABILITY_COS)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COA)
    end
end

function CurseOfRecklessnessModule:run()
    Logging:Debug("Casting " .. ABILITY_COR)
    CastSpellByName(ABILITY_COR)
end

--- @param context WarlockModuleRunContext
function CurseOfRecklessnessModule:getPriority(context)
    if self.enabled and self.trackers.corTracker:ShouldCast() and context.mana > context.corCost then
        return 95;
    end
    return -1;
end
