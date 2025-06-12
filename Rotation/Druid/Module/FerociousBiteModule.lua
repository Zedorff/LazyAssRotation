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
    return setmetatable(Module.new(ABILITY_FEROCIOUS_BITE, trackers, "Interface\\Icons\\Ability_Druid_FerociousBite"),
        FerociousBiteModule)
end

function FerociousBiteModule:run()
    Logging:Debug("Casting " .. ABILITY_FEROCIOUS_BITE)
    CastSpellByName(ABILITY_FEROCIOUS_BITE)
end

--- @param context DruidModuleRunContext
function FerociousBiteModule:getPriority(context)
    if self.enabled then
        if context.spec == DruidSpec.POWERSHIFTING then
            return self:GetPowershiftingFerociousBitePriority(context)
        elseif context.spec == DruidSpec.BLEED then
            return self:GetBleedFerociousBitePriority(context)
        end
    end
    return -1;
end

--- @param context DruidModuleRunContext
function FerociousBiteModule:GetBleedFerociousBitePriority(context)
    if context.cp >= 4 and self.trackers.ripTracker:GetRemainingDuration() < 4 then
        return 90;
    elseif context.cp == 5 and self.trackers.ripTracker:GetRemainingDuration() > 4 then
        return 90;
    end
    return -1;
end

--- @param context DruidModuleRunContext
function FerociousBiteModule:GetPowershiftingFerociousBitePriority(context)
    if context.cp == 5 then
        return 90;
    end
    return -1;
end
