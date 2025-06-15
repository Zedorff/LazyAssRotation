--- @alias MoonfireTrackers { eclipseTracker: EclipseTracker, solsticeTracker: SolsticeTracker, moonfireTracker: MoonfireTracker }
--- @class MoonfireModule : Module
--- @field trackers MoonfireTrackers
--- @diagnostic disable: duplicate-set-field
MoonfireModule = setmetatable({}, { __index = Module })
MoonfireModule.__index = MoonfireModule

--- @return MoonfireModule
function MoonfireModule.new()
    --- @type MoonfireTrackers
    local trackers = {
        eclipseTracker = EclipseTracker.GetInstance(),
        solsticeTracker = SolsticeTracker.GetInstance(),
        moonfireTracker = MoonfireTracker.new()
    }
    --- @class MoonfireModule
    return setmetatable(Module.new(ABILITY_MOONFIRE, trackers, "Interface\\Icons\\Spell_Nature_StarFall"), MoonfireModule)
end

function MoonfireModule:run()
    Logging:Debug("Casting " .. ABILITY_MOONFIRE)
    CastSpellByName(ABILITY_MOONFIRE)
end

--- @param context DruidModuleRunContext
function MoonfireModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(ABILITY_MOONFIRE) then
        return -1;
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.ARCANE
        and (Helpers:CastTime(ABILITY_STARFIRE) > self.trackers.eclipseTracker:GetEclipseRemainingTime()
            and self.trackers.moonfireTracker:GetRemainingDuration() <= 3.5) then
        return 100;
    end

    if self.trackers.moonfireTracker:ShouldCast() then
        return 60;
    end

    return -1;
end
