--- @alias LightningStrikeTrackers { clearcastingTracker: ClearcastingTracker }
--- @class LightningStrikeModule : Module
--- @field trackers LightningStrikeTrackers
--- @diagnostic disable: duplicate-set-field
LightningStrikeModule = setmetatable({}, { __index = Module })
LightningStrikeModule.__index = LightningStrikeModule

--- @return LightningStrikeModule
function LightningStrikeModule.new()
    --- @type LightningStrikeTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class LightningStrikeModule
    return setmetatable(Module.new(ABILITY_LIGHTNING_STRIKE, trackers, "Interface\\Icons\\Spell_Nature_ThunderClap"), LightningStrikeModule)
end

function LightningStrikeModule:run()
    Logging:Debug("Casting Lightning Strike")
    CastSpellByName(ABILITY_LIGHTNING_STRIKE)
end

--- @param context ShamanModuleRunContext
function LightningStrikeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_LIGHTNING_STRIKE) then
        local cost = self.trackers.clearcastingTracker:ShouldCast() and math.floor(context.lsCost * 0.33) or context.lsCost
        if context.remainingManaPercents < 10 then
            return 95;
        elseif context.mana > cost then
            return 50;
        end
    end
    return -1;
end
