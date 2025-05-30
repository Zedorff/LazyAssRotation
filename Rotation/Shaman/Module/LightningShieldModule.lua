--- @alias LightningShieldTrackers { lightningTracker: LightningShieldTracker, waterTracker: WaterShieldTracker }
--- @class LightningShieldModule : Module
--- @field trackers LightningShieldTrackers
--- @diagnostic disable: duplicate-set-field
LightningShieldModule = setmetatable({}, { __index = Module })
LightningShieldModule.__index = LightningShieldModule

--- @return LightningShieldModule
function LightningShieldModule.new()
    --- @type LightningShieldTrackers
    local trackers = {
        lightningTracker = LightningShieldTracker.new(),
        waterTracker = WaterShieldTracker.new()
    }
    --- @class LightningShieldModule
    return setmetatable(Module.new(ABILITY_LIGHTNING_SHIELD, trackers, "Interface\\Icons\\Spell_Nature_LightningShield"), LightningShieldModule)
end

function LightningShieldModule:run()
    Logging:Debug("Casting Lightning Shield")
    CastSpellByName(ABILITY_LIGHTNING_SHIELD)
end

--- @param context ShamanModuleRunContext
function LightningShieldModule:getPriority(context)
    if self.enabled then
        if not self.trackers.waterTracker:ShouldCast() and context.remainingManaPercents < 60 then
            return -1;
        end
        if self.trackers.lightningTracker:ShouldCast() and context.remainingManaPercents > 40 then
            return 95; --- always cast when no buff on yourself
        end
    end
    return -1;
end
