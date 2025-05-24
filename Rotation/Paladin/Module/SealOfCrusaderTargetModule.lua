--- @class SealOfCrusaderTargetModule : Module
--- @field socrTracker SealOfCrusaderTargetTracker
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderTargetModule = setmetatable({}, { __index = Module })
SealOfCrusaderTargetModule.__index = SealOfCrusaderTargetModule

--- @return SealOfCrusaderTargetModule
function SealOfCrusaderTargetModule.new()
    --- @class SealOfCrusaderTargetModule
    local self = Module.new(ABILITY_SEAL_OF_CRUSADER)
    setmetatable(self, SealOfCrusaderTargetModule)

    self.socrTracker = SealOfCrusaderTargetTracker.new()

    if self.enabled then
        self.socrTracker:subscribe()
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_WISDOM)
    end

    return self
end

function SealOfCrusaderTargetModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_WISDOM)
    self.socrTracker:subscribe()
end

function SealOfCrusaderTargetModule:disable()
    Module.disable(self)
    self.socrTracker:unsubscribe()
end

function SealOfCrusaderTargetModule:run()
    Logging:Debug("Casting " .. ABILITY_SEAL_OF_CRUSADER)
    CastSpellByName(ABILITY_SEAL_OF_CRUSADER)
end

--- @param context PaladinModuleRunContext
function SealOfCrusaderTargetModule:getPriority(context)
    if self.enabled and context.mana > context.socrCost and self.socrTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
