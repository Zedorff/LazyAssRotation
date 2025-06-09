--- @alias CurseOfShadowTrackers { cosTracker: CurseOfShadowTracker }
--- @class CurseOfShadowModule : Module
--- @field trackers CurseOfShadowTrackers
--- @field allowAgonyWithOtherCurses boolean
--- @diagnostic disable: duplicate-set-field
CurseOfShadowModule = setmetatable({}, { __index = Module })
CurseOfShadowModule.__index = CurseOfShadowModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfShadowModule
function CurseOfShadowModule.new(allowAgonyWithOtherCurses)
    --- @type CurseOfShadowTrackers
    local trackers = {
        cosTracker = CurseOfShadowTracker.new()
    }
    --- @class CurseOfShadowModule
    local self = Module.new(ABILITY_COS, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", true)
    setmetatable(self, CurseOfShadowModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_COW)
        ModuleRegistry:DisableModule(ABILITY_COE)
        ModuleRegistry:DisableModule(ABILITY_COR)
        if not self.allowAgonyWithOtherCurses then
            ModuleRegistry:DisableModule(ABILITY_COA)
        end
    end

    return self
end

function CurseOfShadowModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_COW)
    ModuleRegistry:DisableModule(ABILITY_COE)
    ModuleRegistry:DisableModule(ABILITY_COR)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(ABILITY_COA)
    end
end

function CurseOfShadowModule:run()
    Logging:Debug("Casting " .. ABILITY_COS)
    CastSpellByName(ABILITY_COS)
end

--- @param context WarlockModuleRunContext
function CurseOfShadowModule:getPriority(context)
    if self.enabled and self.trackers.cosTracker:ShouldCast() and context.mana > context.cosCost then
        return 95;
    end
    return -1;
end
