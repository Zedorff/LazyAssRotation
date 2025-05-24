--- @class LightningShieldModule : Module
--- @field lightningTracker LightningShieldTracker
--- @field waterTracker WaterShieldTracker
--- @diagnostic disable: duplicate-set-field
LightningShieldModule = setmetatable({}, { __index = Module })
LightningShieldModule.__index = LightningShieldModule

--- @return LightningShieldModule
function LightningShieldModule.new()
    --- @class LightningShieldModule
    local instance = Module.new(ABILITY_LIGHTNING_SHIELD)
    setmetatable(instance, LightningShieldModule)

    instance.lightningTracker = LightningShieldTracker.new()
    instance.waterTracker = WaterShieldTracker.new()

    if instance.enabled then
        instance.lightningTracker:subscribe()
        instance.waterTracker:subscribe()
    end

    return instance
end

function LightningShieldModule:enable()
    Module.enable(self)
    self.lightningTracker:subscribe()
    self.waterTracker:subscribe()
end

function LightningShieldModule:disable()
    Module.disable(self)
    self.lightningTracker:unsubscribe()
    self.waterTracker:unsubscribe()
end

function LightningShieldModule:run()
    Logging:Debug("Casting Lightning Shield")
    CastSpellByName(ABILITY_LIGHTNING_SHIELD)
end

--- @param context ShamanModuleRunContext
function LightningShieldModule:getPriority(context)
    if self.enabled then
        if not self.waterTracker:ShouldCast() and context.remainingManaPercents < 60 then
            return -1;
        end
        if self.lightningTracker:ShouldCast() and context.remainingManaPercents > 40 then
            return 95; --- always cast when no buff on yourself
        end
    end
    return -1;
end
