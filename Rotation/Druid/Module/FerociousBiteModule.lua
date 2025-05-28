--- @alias FerociousBiteTrackers { ripTracker: RipTracker }
--- @class FerociousBiteModule : Module
--- @field trackers FerociousBiteTrackers
--- @diagnostic disable: duplicate-set-field
FerociousBiteModule = setmetatable({}, { __index = Module })
FerociousBiteModule.__index = FerociousBiteModule

--- @return FerociousBiteModule
function FerociousBiteModule.new()
    --- @type FerociousBiteTrackers
    local trackers = {
        ripTracker = RipTracker.new()
    }
    --- @class FerociousBiteModule
    return setmetatable(Module.new(ABILITY_FEROCIOUS_BITE, trackers), FerociousBiteModule)
end

function FerociousBiteModule:run()
    Logging:Debug("Casting "..ABILITY_FEROCIOUS_BITE)
    CastSpellByName(ABILITY_FEROCIOUS_BITE)
end

--- @param context DruidModuleRunContext
function FerociousBiteModule:getPriority(context)
    if self.enabled then
        local psEnabled = ModuleRegistry:IsModuleEnabled(MODULE_POWERSHIFTING)
        if psEnabled and context.cp == 5 then
            return 90;
        elseif not psEnabled and context.cp >= 1 and self.trackers.ripTracker:GetRipRemainingTime() < 3 and context.energy >= context.ferociousBiteCost then
            return 90;
        elseif not psEnabled and context.cp == 5 and self.trackers.ripTracker:GetRipRemainingTime() > 3 and context.energy >= context.ferociousBiteCost then
            return 90;
        end
    end
    return -1;
end
