--- @class SealOfWisdomTargetModule : Module
--- @field sowTracker SealOfWisdomTracker
--- @diagnostic disable: duplicate-set-field
SealOfWisdomTargetModule = setmetatable({}, { __index = Module })
SealOfWisdomTargetModule.__index = SealOfWisdomTargetModule

--- @return SealOfWisdomTargetModule
function SealOfWisdomTargetModule.new()
    --- @class SealOfWisdomTargetModule
    local self = Module.new(ABILITY_SEAL_OF_WISDOM)
    setmetatable(self, SealOfWisdomTargetModule)
    self.sowTracker = SealOfWisdomTracker.new()

    if self.enabled then
        self.sowTracker:subscribe()
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_CRUSADER)
    end

    return self
end

function SealOfWisdomTargetModule:enable()
    Module.enable(self)
    self.sowTracker:subscribe()
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_CRUSADER)
end

function SealOfWisdomTargetModule:disable()
    Module.disable(self)
    self.sowTracker:unsubscribe()
end

function SealOfWisdomTargetModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_WISDOM)
    CastSpellByName(ABILITY_SEAL_OF_WISDOM)
end

--- @param context PaladinModuleRunContext
function SealOfWisdomTargetModule:getPriority(context)
    if self.enabled and context.mana > context.sowCost and self.sowTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
