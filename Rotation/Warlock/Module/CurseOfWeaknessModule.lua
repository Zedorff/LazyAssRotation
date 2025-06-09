--- @alias CurseOfWeaknessTrackers { cowTracker: CurseOfWeaknessTracker }
--- @class CurseOfWeaknessModule : Module
--- @field trackers CurseOfWeaknessTrackers
--- @field allowAgonyWithOtherCurses boolean
--- @diagnostic disable: duplicate-set-field
CurseOfWeaknessModule = setmetatable({}, { __index = Module })
CurseOfWeaknessModule.__index = CurseOfWeaknessModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfWeaknessModule
function CurseOfWeaknessModule.new(allowAgonyWithOtherCurses)
    --- @type CurseOfWeaknessTrackers
    local trackers = {
        cowTracker = CurseOfWeaknessTracker.new()
    }
    --- @class CurseOfWeaknessModule
    local self = Module.new(ABILITY_COW, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfMannoroth")
    setmetatable(self, CurseOfWeaknessModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_COR)
        ModuleRegistry:DisableModule(ABILITY_COE)
        ModuleRegistry:DisableModule(ABILITY_COS)
        if not self.allowAgonyWithOtherCurses then
            ModuleRegistry:DisableModule(ABILITY_COA)
        end
    end

    return self
end

function CurseOfWeaknessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_COR)
    ModuleRegistry:DisableModule(ABILITY_COE)
    ModuleRegistry:DisableModule(ABILITY_COS)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COA)
    end
end

function CurseOfWeaknessModule:run()
    Logging:Debug("Casting " .. ABILITY_COW)
    CastSpellByName(ABILITY_COW)
end

--- @param context WarlockModuleRunContext
function CurseOfWeaknessModule:getPriority(context)
    if self.enabled and self.trackers.cowTracker:ShouldCast() and context.mana > context.cowCost then
        return 95;
    end
    return -1;
end
