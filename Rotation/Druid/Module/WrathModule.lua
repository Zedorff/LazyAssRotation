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
    return setmetatable(Module.new(ABILITY_WRATH, trackers, "Interface\\Icons\\Spell_Nature_AbolishMagic"), WrathModule)
end

function WrathModule:run()
    Logging:Debug("Casting "..ABILITY_WRATH)
    CastSpellByName(ABILITY_WRATH)
end

--- @param context DruidModuleRunContext
function WrathModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(ABILITY_WRATH) then
        return -1
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.NATURE then
        if self.trackers.eclipseTracker:GetEclipseRemainingTime() >= Helpers:CastTime(ABILITY_WRATH) then
            return 90;
        end
    end

    if self.trackers.solsticeTracker:IsSolsticeTypeUp(SolsticeType.ARCANE) then
        return 51;
    end

    if self.trackers.sequenceTracker:GetLastCastedSpellId() ~= 9912 and not self.trackers.solsticeTracker:IsAnySolsticeUp() then
        return 51;
    end

    return -1;
end
