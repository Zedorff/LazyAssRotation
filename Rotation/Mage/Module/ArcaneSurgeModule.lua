--- @alias ArcaneSurgeTrackers { arcaneSurgeTracker: ArcaneSurgeTracker, channelingTracker: ChannelingTracker, mqgTracker: MindQuickingGemTracker, arcanePowerTracker: ArcanePowerTracker }
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
        arcanePowerTracker = ArcanePowerTracker.new()
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
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        if self.trackers.arcaneSurgeTracker:ShouldCast()
            and self.trackers.mqgTracker:ShouldCast()
            and self.trackers.arcanePowerTracker:ShouldCast()
            and context.mana >= context.asCost then
            return 90;
        end
    else
        return -1;
    end
end
