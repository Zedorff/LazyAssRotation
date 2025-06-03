--- @alias ArcaneRuptureTrackers { arcaneRuptureTracker: ArcaneRuptureTracker, convergenceTracker: TemporalConvergenceTracker, channelingTracker: ChannelingTracker }
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
        channelingTracker = ChannelingTracker.new()
    }
    --- @class ArcaneRuptureModule
    return setmetatable(Module.new(ABILITY_ARCANE_RUPTURE, trackers, "Interface\\Icons\\Spell_Arcane_Blast"), ArcaneRuptureModule)
end

function ArcaneRuptureModule:run()
    Logging:Debug("Casting "..ABILITY_ARCANE_RUPTURE)
    CastSpellByName(ABILITY_ARCANE_RUPTURE)
end

--- @param context MageModuleRunContext
function ArcaneRuptureModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        local hasMana = context.mana >= context.arCost
        if self.trackers.convergenceTracker:ShouldCast() and self.trackers.arcaneRuptureTracker:GetRuptureRemainingTime() < 2 and hasMana then
            return 95;
        elseif Helpers:SpellReady(ABILITY_ARCANE_RUPTURE) and self.trackers.arcaneRuptureTracker:ShouldCast() and hasMana then
            return 85;
        end
    end
    return -1;
end
