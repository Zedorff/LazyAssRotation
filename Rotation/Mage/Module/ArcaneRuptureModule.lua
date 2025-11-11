--- @alias ArcaneRuptureTrackers { arcaneRuptureTracker: ArcaneRuptureTracker, convergenceTracker: TemporalConvergenceTracker, castingTracker: CastingTracker }
--- @class ArcaneRuptureModule : Module
--- @field trackers ArcaneRuptureTrackers
--- @diagnostic disable: duplicate-set-field
ArcaneRuptureModule = setmetatable({}, { __index = Module })
ArcaneRuptureModule.__index = ArcaneRuptureModule

--- @return ArcaneRuptureModule
function ArcaneRuptureModule.new()
    --- @type ArcaneRuptureTrackers
    local trackers = {
        arcaneRuptureTracker = ArcaneRuptureTracker.new(),
        convergenceTracker = TemporalConvergenceTracker.new(),
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class ArcaneRuptureModule
    return setmetatable(Module.new(Abilities.ArcaneRupture.name, trackers, "Interface\\Icons\\Spell_Arcane_Blast"), ArcaneRuptureModule)
end

function ArcaneRuptureModule:run()
    Logging:Debug("Casting "..Abilities.ArcaneRupture.name)
    if self.trackers.castingTracker:IsChanneling() then
        _ = SpellStopCasting()
    end

    CastSpellByName(Abilities.ArcaneRupture.name)
end

--- @param context MageModuleRunContext
function ArcaneRuptureModule:getPriority(context)
    local hasMana = context.mana >= context.arCost
    if self.enabled and hasMana then
        if (Helpers:SpellReady(Abilities.ArcaneRupture.name) and self.trackers.arcaneRuptureTracker:ShouldCast()) or (self.trackers.convergenceTracker:ShouldCast() and self.trackers.arcaneRuptureTracker:TimeUntilRuptureExpires() < 2) then
            return 100;
        end
    end
    return -1;
end
