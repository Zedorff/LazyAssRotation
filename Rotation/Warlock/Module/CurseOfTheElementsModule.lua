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
    local self = Module.new(ABILITY_COE, trackers, "Interface\\Icons\\Spell_Shadow_ChillTouch")
    setmetatable(self, CurseOfTheElementsModule)

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

function CurseOfTheElementsModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_COW)
    ModuleRegistry:DisableModule(ABILITY_COR)
    ModuleRegistry:DisableModule(ABILITY_COS)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COA)
    end
end

function CurseOfTheElementsModule:run()
    Logging:Debug("Casting " .. ABILITY_COE)
    CastSpellByName(ABILITY_COE)
end

--- @param context WarlockModuleRunContext
function CurseOfTheElementsModule:getPriority(context)
    if self.enabled and self.trackers.coeTracker:ShouldCast() and context.mana > context.coeCost then
        return 95;
    end
    return -1;
end
