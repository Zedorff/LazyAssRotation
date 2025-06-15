--- @alias WrathTrackers { eclipseTracker: EclipseTracker, sequenceTracker: SequenceTracker, solsticeTracker: SolsticeTracker }
--- @class WrathModule : Module
--- @field trackers WrathTrackers
--- @diagnostic disable: duplicate-set-field
WrathModule = setmetatable({}, { __index = Module })
WrathModule.__index = WrathModule

--- @return WrathModule
function WrathModule.new()
    --- @type WrathTrackers
    local trackers = {
        eclipseTracker = EclipseTracker.GetInstance(),
        sequenceTracker = SequenceTracker.GetInstance(),
        solsticeTracker = SolsticeTracker.GetInstance()
    }
    --- @class WrathModule
    return setmetatable(Module.new(Abilities.Wrath.name, trackers, "Interface\\Icons\\Spell_Nature_AbolishMagic"), WrathModule)
end

function WrathModule:run()
    Logging:Debug("Casting "..Abilities.Wrath.name)
    CastSpellByName(Abilities.Wrath.name)
end

--- @param context DruidModuleRunContext
function WrathModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(Abilities.Wrath.name) then
        return -1
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.NATURE and self.trackers.eclipseTracker:GetEclipseRemainingTime() >= Helpers:CastTime(Abilities.Wrath.name) then
        return 90;
    end

    if self.trackers.solsticeTracker:IsSolsticeTypeUp(SolsticeType.ARCANE) then
        return 51;
    end

    if not ModuleRegistry:IsModuleEnabled(Abilities.Starfire.name) or (not self.trackers.sequenceTracker:IsLastCastWasWrath() and not self.trackers.solsticeTracker:IsAnySolsticeUp()) then
        return 51;
    end

    return -1;
end
