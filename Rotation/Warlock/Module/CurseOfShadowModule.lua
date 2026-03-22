--- @alias CurseOfShadowTrackers { cosTracker: CurseOfShadowTracker }
--- @class CurseOfShadowModule : Module
--- @field trackers CurseOfShadowTrackers
--- @diagnostic disable: duplicate-set-field
CurseOfShadowModule = setmetatable({}, { __index = Module })
CurseOfShadowModule.__index = CurseOfShadowModule

--- @return CurseOfShadowModule
function CurseOfShadowModule.new()
    --- @type CurseOfShadowTrackers
    local trackers = {
        cosTracker = CurseOfShadowTracker.new()
    }
    --- @class CurseOfShadowModule
    local self = Module.new(Abilities.CoS.name, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde", true)
    setmetatable(self, CurseOfShadowModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoE.name)
        ModuleRegistry:DisableModule(Abilities.CoR.name)
    end

    return self
end

function CurseOfShadowModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoE.name)
    ModuleRegistry:DisableModule(Abilities.CoR.name)
end

function CurseOfShadowModule:run()
    Logging:Debug("Casting " .. Abilities.CoS.name)
    CastSpellByName(Abilities.CoS.name)
end

--- @param context WarlockModuleRunContext
function CurseOfShadowModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled and Helpers:SpellReady(Abilities.CoS.name) and self.trackers.cosTracker:ShouldCast() and context.mana > context.cosCost then
        return 95;
    end
    return -1;
end
