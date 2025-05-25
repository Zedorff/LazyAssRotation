--- @alias SealOfCrusaderTrackers { socrTracker: SealOfCrusaderTargetTracker }
--- @class SealOfCrusaderTargetModule : Module
--- @field trackers SealOfCrusaderTrackers
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderTargetModule = setmetatable({}, { __index = Module })
SealOfCrusaderTargetModule.__index = SealOfCrusaderTargetModule

--- @return SealOfCrusaderTargetModule
function SealOfCrusaderTargetModule.new()
    --- @type SealOfCrusaderTrackers
    local trackers = {
        socrTracker = SealOfCrusaderTargetTracker.new()
    }
    --- @class SealOfCrusaderTargetModule
    return setmetatable(Module.new(ABILITY_SEAL_OF_CRUSADER, trackers), SealOfCrusaderTargetModule)
end

function SealOfCrusaderTargetModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_WISDOM)
end

function SealOfCrusaderTargetModule:run()
    Logging:Debug("Casting " .. ABILITY_SEAL_OF_CRUSADER)
    CastSpellByName(ABILITY_SEAL_OF_CRUSADER)
end

--- @param context PaladinModuleRunContext
function SealOfCrusaderTargetModule:getPriority(context)
    if self.enabled and context.mana > context.socrCost and self.trackers.socrTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
