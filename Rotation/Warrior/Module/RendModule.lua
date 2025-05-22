--- @class RendModule : Module
--- @field tracker RendTracker
--- @diagnostic disable: duplicate-set-field
RendModule = setmetatable({}, { __index = Module })
RendModule.__index = RendModule


function RendModule.new()
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

function RendModule:getPriority()
    local activeStance = Helpers:ActiveStance()
    if self.enabled and activeStance == 1 then
        local rage = UnitMana("player");
        local rendCost = Helpers:RageCost(ABILITY_REND)
        if self.tracker:isAvailable() and rage >= rendCost then
            return 55; --- prio higher than heroic
        end
    else
        return -1;
    end
end
