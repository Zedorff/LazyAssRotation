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
    return setmetatable(Module.new(ABILITY_WATER_SHIELD, trackers, "Interface\\Icons\\Ability_Shaman_WaterShield"),
        WaterShieldModule)
end

function WaterShieldModule:run()
    Logging:Debug("Casting Water Shield")
    CastSpellByName(ABILITY_WATER_SHIELD)
end

--- @param context ShamanModuleRunContext
function WaterShieldModule:getPriority(context)
    if self.enabled then
        if context.spec == ShamanSpec.ENHANCE then
            return self:GetEnhPriority(context)
        elseif context.spec == ShamanSpec.ELEM then
            return self:GetElemPriority(context)
        end
    end
    return -1;
end

--- @param context ShamanModuleRunContext
function WaterShieldModule:GetEnhPriority(context)
    if self.trackers.waterShieldTracker:ShouldCast() and context.remainingManaPercents <= 40 then
        return 95;
    end
end

--- @param context ShamanModuleRunContext
function WaterShieldModule:GetElemPriority(context)
    if self.trackers.waterShieldTracker:ShouldCast() then
        return 95;
    end
end
