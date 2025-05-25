--- @alias SealOfWisdomTargeTrackers { sowTracker: SealOfWisdomTracker }
--- @class SealOfWisdomTargetModule : Module
--- @field trackers SealOfWisdomTargeTrackers
--- @diagnostic disable: duplicate-set-field
SealOfWisdomTargetModule = setmetatable({}, { __index = Module })
SealOfWisdomTargetModule.__index = SealOfWisdomTargetModule

--- @return SealOfWisdomTargetModule
function SealOfWisdomTargetModule.new()
    --- @type SealOfWisdomTargeTrackers
    local trackers = {
        sowTracker = SealOfWisdomTracker.new()
    }
    --- @class SealOfWisdomTargetModule
    local self = Module.new(ABILITY_SEAL_OF_WISDOM, trackers)
    setmetatable(self, SealOfWisdomTargetModule)

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_CRUSADER)
    end

    return self
end

function SealOfWisdomTargetModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_CRUSADER)
end

function SealOfWisdomTargetModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_WISDOM)
    CastSpellByName(ABILITY_SEAL_OF_WISDOM)
end

--- @param context PaladinModuleRunContext
function SealOfWisdomTargetModule:getPriority(context)
    if self.enabled and context.mana > context.sowCost and self.trackers.sowTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
