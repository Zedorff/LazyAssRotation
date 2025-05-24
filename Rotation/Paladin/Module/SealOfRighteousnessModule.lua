--- @class SealOfRighteousnessModule : Module
--- @field sorTracker SealOfRighteousnessTracker
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessModule = setmetatable({}, { __index = Module })
SealOfRighteousnessModule.__index = SealOfRighteousnessModule

--- @return SealOfRighteousnessModule
function SealOfRighteousnessModule.new()
    --- @class SealOfRighteousnessModule
    local self = Module.new(ABILITY_SEAL_OF_RIGHTEOUSNESS)
    setmetatable(self, SealOfRighteousnessModule)

    self.sorTracker = SealOfRighteousnessTracker.new()

    if self.enabled then
        self.sorTracker:subscribe()
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_COMMAND)
    end

    return self
end

function SealOfRighteousnessModule:enable()
    Module.enable(self)
    self.sorTracker:subscribe()
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_COMMAND)
end

function SealOfRighteousnessModule:disable()
    Module.disable(self)
    self.sorTracker:unsubscribe()
end

function SealOfRighteousnessModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_RIGHTEOUSNESS)
    CastSpellByName(ABILITY_SEAL_OF_RIGHTEOUSNESS)
end

--- @param context PaladinModuleRunContext
function SealOfRighteousnessModule:getPriority(context)
    if self.enabled and context.mana > context.sorCost and self.sorTracker:ShouldCast() then
        return 80;
    end
    return -1;
end
