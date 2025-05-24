--- @class WaterShieldModule : Module
--- @field tracker WaterShieldTracker
--- @diagnostic disable: duplicate-set-field
WaterShieldModule = setmetatable({}, { __index = Module })
WaterShieldModule.__index = WaterShieldModule

--- @return WaterShieldModule 
function WaterShieldModule.new()
    --- @class WaterShieldModule
    local instance = Module.new(ABILITY_WATER_SHIELD)
    setmetatable(instance, WaterShieldModule)

    instance.tracker = WaterShieldTracker.new()

    if instance.enabled then
        instance.tracker:subscribe()
    end

    return instance
end

function WaterShieldModule:enable()
    Module.enable(self)
    self.tracker:subscribe()
end

function WaterShieldModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function WaterShieldModule:run()
    Logging:Debug("Casting Water Shield")
    CastSpellByName(ABILITY_WATER_SHIELD)
end

--- @param context ShamanModuleRunContext
function WaterShieldModule:getPriority(context)
    if self.enabled then
        if self.tracker:isAvailable() and context.remainingManaPercents <= 40 then
            return 95; --- always cast when no buff on yourself
        end
    end
    return -1;
end
