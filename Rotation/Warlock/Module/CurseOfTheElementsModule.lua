--- @alias CurseOfTheElementsTrackers { coeTracker: CurseOfTheElementsTracker }
--- @class CurseOfTheElementsModule : Module
--- @field trackers CurseOfTheElementsTrackers
--- @diagnostic disable: duplicate-set-field
CurseOfTheElementsModule = setmetatable({}, { __index = Module })
CurseOfTheElementsModule.__index = CurseOfTheElementsModule

--- @return CurseOfTheElementsModule
function CurseOfTheElementsModule.new()
    --- @type CurseOfTheElementsTrackers
    local trackers = {
        coeTracker = CurseOfTheElementsTracker.new()
    }
    --- @class CurseOfTheElementsModule
    local self = Module.new(Abilities.CoE.name, trackers, "Interface\\Icons\\Spell_Shadow_ChillTouch")
    setmetatable(self, CurseOfTheElementsModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.CoW.name)
        ModuleRegistry:DisableModule(Abilities.CoR.name)
        ModuleRegistry:DisableModule(Abilities.CoS.name)
    end

    return self
end

function CurseOfTheElementsModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.CoW.name)
    ModuleRegistry:DisableModule(Abilities.CoR.name)
    ModuleRegistry:DisableModule(Abilities.CoS.name)
end

function CurseOfTheElementsModule:run()
    Logging:Debug("Casting " .. Abilities.CoE.name)
    CastSpellByName(Abilities.CoE.name)
end

--- @param context WarlockModuleRunContext
function CurseOfTheElementsModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled and Helpers:SpellReady(Abilities.CoE.name) and self.trackers.coeTracker:ShouldCast() and context.mana > context.coeCost then
        return 95;
    end
    return -1;
end
