--- @class AutoAttackModule : Module
--- @field tracker AutoAttackTracker
--- @diagnostic disable: duplicate-set-field
AutoAttackModule = setmetatable({}, { __index = Module })
AutoAttackModule.__index = AutoAttackModule

--- @return AutoAttackModule
function AutoAttackModule.new()
    --- @class AutoAttackModule
    local instance = Module.new("AutoAttack")
    setmetatable(instance, AutoAttackModule)

    instance.tracker = AutoAttackTracker.new()

    if instance.enabled then
        instance.tracker:subscribe()
    end

    return instance
end

function AutoAttackModule:enable()
    Module.enable(self)
    self.tracker:subscribe()
end

function AutoAttackModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function AutoAttackModule:GetNextSwingTime()
    return self.tracker:GetWhenAvailable()
end

function AutoAttackModule:run() end

function AutoAttackModule:getPriority(context)
    return -1;
end
