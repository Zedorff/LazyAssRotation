--- @alias StarfireTrackers { eclipseTracker: EclipseTracker, sequenceTracker: SequenceTracker, solsticeTracker: SolsticeTracker }
--- @class StarfireModule : Module
--- @field trackers StarfireTrackers
--- @diagnostic disable: duplicate-set-field
StarfireModule = setmetatable({}, { __index = Module })
StarfireModule.__index = StarfireModule

--- @return StarfireModule
function StarfireModule.new()
    --- @type StarfireTrackers
    local trackers = {
        eclipseTracker = EclipseTracker.GetInstance(),
        sequenceTracker = SequenceTracker.GetInstance(),
        solsticeTracker = SolsticeTracker.GetInstance()
    }
    --- @class StarfireModule
    return setmetatable(Module.new(Abilities.Starfire.name, trackers, "Interface\\Icons\\Spell_Arcane_StarFire"), StarfireModule)
end

function StarfireModule:run()
    Logging:Debug("Casting "..Abilities.Starfire.name)
    CastSpellByName(Abilities.Starfire.name)
end

--- @param context DruidModuleRunContext
function StarfireModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(Abilities.Starfire.name) then
        return -1
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.ARCANE and self.trackers.eclipseTracker:GetEclipseRemainingTime() >= Helpers:CastTime(Abilities.Starfire.name) then
        return 90;
    end

    if self.trackers.solsticeTracker:IsSolsticeTypeUp(SolsticeType.NATURE) then
        return 50;
    end

    if not ModuleRegistry:IsModuleEnabled(Abilities.Wrath.name) or (not self.trackers.sequenceTracker:IsLastCastWasStarfire() and not self.trackers.solsticeTracker:IsAnySolsticeUp()) then
        return 50;
    end
    return -1;
end
