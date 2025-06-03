--- @alias ArcaneSurgeTrackers { arcaneSurgeTracker: ArcaneSurgeTracker, channelingTracker: ChannelingTracker, arcaneRuptureTracker: ArcaneRuptureTracker }
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
        channelingTracker = ChannelingTracker.new(),
        arcaneRuptureTracker = ArcaneRuptureTracker.new()
    }
    --- @class ArcaneSurgeModule
    return setmetatable(Module.new(ABILITY_ARCANE_SURGE, trackers, "Interface\\Icons\\INV_Enchant_EssenceMysticalLarge"), ArcaneSurgeModule)
end

function ArcaneSurgeModule:run()
    Logging:Debug("Casting "..ABILITY_ARCANE_SURGE)
    CastSpellByName(ABILITY_ARCANE_SURGE)
end

--- @param context MageModuleRunContext
function ArcaneSurgeModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() and Helpers:SpellReady(ABILITY_ARCANE_SURGE) then
        if self.trackers.arcaneSurgeTracker:ShouldCast() and (self.trackers.arcaneRuptureTracker:ShouldCast() or self.trackers.arcaneRuptureTracker:GetRuptureRemainingTime() < 4) and context.mana >= context.asCost then
            return 90;
        end
    else
        return -1;
    end
end
