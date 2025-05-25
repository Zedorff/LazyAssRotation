--- @alias WaterShieldTrackers { waterShieldTracker: WaterShieldTracker }
--- @class WaterShieldModule : Module
--- @field trackers WaterShieldTrackers
--- @diagnostic disable: duplicate-set-field
WaterShieldModule = setmetatable({}, { __index = Module })
WaterShieldModule.__index = WaterShieldModule

--- @return WaterShieldModule 
function WaterShieldModule.new()
    --- @type WaterShieldTrackers
    local trackers = {
        waterShieldTracker = WaterShieldTracker.new()
    }
    --- @class WaterShieldModule
    return setmetatable(Module.new(ABILITY_WATER_SHIELD, trackers), WaterShieldModule)
end

function WaterShieldModule:run()
    Logging:Debug("Casting Water Shield")
    CastSpellByName(ABILITY_WATER_SHIELD)
end

--- @param context ShamanModuleRunContext
function WaterShieldModule:getPriority(context)
    if self.enabled then
        if self.trackers.waterShieldTracker:ShouldCast() and context.remainingManaPercents <= 40 then
            return 95; --- always cast when no buff on yourself
        end
    end
    return -1;
end
