--- @alias ArcaneSurgeTrackers { 
---   arcaneSurgeTracker: ArcaneSurgeTracker, 
---   channelingTracker: ChannelingTracker, 
---   mqgTracker: MindQuickingGemTracker,
---   arcanePowerTracker: ArcanePowerTracker,
---   temporalConvergenceTracker: TemporalConvergenceTracker,
--- }
--- @class ArcaneSurgeModule : Module
--- @field trackers ArcaneSurgeTrackers
--- @diagnostic disable: duplicate-set-field
ArcaneSurgeModule = setmetatable({}, { __index = Module })
ArcaneSurgeModule.__index = ArcaneSurgeModule

--- @return ArcaneSurgeModule
function ArcaneSurgeModule.new()
    --- @type ArcaneSurgeTrackers
    local trackers = {
        arcaneSurgeTracker = ArcaneSurgeTracker.new(),
        channelingTracker = ChannelingTracker.GetInstance(),
        mqgTracker = MindQuickingGemTracker.new(),
        arcanePowerTracker = ArcanePowerTracker.new(),
        temporalConvergenceTracker = TemporalConvergenceTracker.new()
    }
    --- @class ArcaneSurgeModule
    return setmetatable(Module.new(Abilities.ArcaneSurge.name, trackers, "Interface\\Icons\\INV_Enchant_EssenceMysticalLarge"), ArcaneSurgeModule)
end

function ArcaneSurgeModule:run()
    Logging:Debug("Casting "..Abilities.ArcaneSurge.name)
    CastSpellByName(Abilities.ArcaneSurge.name)
end

--- @param context MageModuleRunContext
function ArcaneSurgeModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        local hasMana = context.mana >= context.asCost + context.amCost

        if self.trackers.arcaneSurgeTracker:ShouldCast()
           and self.trackers.mqgTracker:ShouldCast()
           and self.trackers.arcanePowerTracker:ShouldCast()
           and hasMana
        then
            if (self.trackers.temporalConvergenceTracker:TimeUntilBuffExpires() > Helpers:CastTime(Abilities.ArcaneRupture.name) + 1.7) or self.trackers.temporalConvergenceTracker:ShouldCast() then
                return 105
            else
                return 85
            end
        end
    end
    return -1
end
