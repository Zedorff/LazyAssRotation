--- @class RendModule : Module
--- @field tracker RendTracker
--- @diagnostic disable: duplicate-set-field
RendModule = setmetatable({}, { __index = Module })
RendModule.__index = RendModule

--- @return RendModule
function RendModule.new()
    --- @class RendModule
    local instance = Module.new(ABILITY_REND)
    setmetatable(instance, RendModule)

    instance.tracker = RendTracker.new()

    if instance.enabled then
        instance.tracker:subscribe()
    end

    return instance
end

function RendModule:enable()
    Module.enable(self)
    self.tracker:subscribe()
end

function RendModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function RendModule:run()
    Logging:Debug("Casting Rend")
    CastSpellByName(ABILITY_REND)
end

--- @param context WarriorModuleRunContext
function RendModule:getPriority(context)
    if self.enabled and context.stance == 1 then
        if self.tracker:ShouldCast() and context.rage >= context.rendCost then
            return 55; --- prio higher than heroic
        end
    else
        return -1;
    end
end
