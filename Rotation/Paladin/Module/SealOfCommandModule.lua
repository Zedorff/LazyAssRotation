--- @class SealOfCommandModule : Module
--- @field socTracker SealOfCommandTracker
--- @diagnostic disable: duplicate-set-field
SealOfCommandModule = setmetatable({}, { __index = Module })
SealOfCommandModule.__index = SealOfCommandModule

--- @return SealOfCommandModule
function SealOfCommandModule.new()
    --- @class SealOfCommandModule
    local self = Module.new(ABILITY_SEAL_OF_COMMAND)
    setmetatable(self, SealOfCommandModule)

    self.socTracker = SealOfCommandTracker.new()

    if self.enabled then
        self.socTracker:subscribe()
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_RIGHTEOUSNESS)
    end

    return self
end

function SealOfCommandModule:enable()
    Module.enable(self)
    self.socTracker:subscribe()
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_RIGHTEOUSNESS)
end

function SealOfCommandModule:disable()
    Module.disable(self)
    self.socTracker:unsubscribe()
end

function SealOfCommandModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_COMMAND)
    CastSpellByName(ABILITY_SEAL_OF_COMMAND)
end

--- @param context PaladinModuleRunContext
function SealOfCommandModule:getPriority(context)
    if self.enabled and context.mana > context.socCost and self.socTracker:ShouldCast() then
        return 80;
    end
    return -1;
end
