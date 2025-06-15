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
    return setmetatable(Module.new(ABILITY_STARFIRE, trackers, "Interface\\Icons\\Spell_Arcane_StarFire"), StarfireModule)
end

function StarfireModule:run()
    Logging:Debug("Casting "..ABILITY_STARFIRE)
    CastSpellByName(ABILITY_STARFIRE)
end

--- @param context DruidModuleRunContext
function StarfireModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(ABILITY_STARFIRE) then
        return -1
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.ARCANE and self.trackers.eclipseTracker:GetEclipseRemainingTime() >= Helpers:CastTime(ABILITY_STARFIRE) then
        return 90;
    end

    if self.trackers.solsticeTracker:IsSolsticeTypeUp(SolsticeType.NATURE) then
        return 50;
    end

    if not ModuleRegistry:IsModuleEnabled(ABILITY_WRATH) or (self.trackers.sequenceTracker:GetLastCastedSpellId() ~= 25298 and not self.trackers.solsticeTracker:IsAnySolsticeUp()) then
        return 50;
    end
    return -1;
end
