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
    local self = Module.new(Abilities.CoS.name, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", true)
    setmetatable(self, CurseOfShadowModule)

    self.allowAgonyWithOtherCurses = allowAgonyWithOtherCurses

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoR.name)
        if not self.allowAgonyWithOtherCurses then
            ModuleRegistry:DisableModule(Abilities.CoA.name)
        end
    end

    return self
end

function CurseOfShadowModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoE.name)
    ModuleRegistry:DisableModule(Abilities.CoR.name)
    if not self.allowAgonyWithOtherCurses then
        ModuleRegistry:DisableModule(Abilities.CoA.name)
    end
end

function CurseOfShadowModule:run()
    Logging:Debug("Casting " .. Abilities.CoS.name)
    CastSpellByName(Abilities.CoS.name)
end

--- @param context WarlockModuleRunContext
function CurseOfShadowModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.CoS.name) and self.trackers.cosTracker:ShouldCast() and context.mana > context.cosCost then
        return 95;
    end
    return -1;
end
