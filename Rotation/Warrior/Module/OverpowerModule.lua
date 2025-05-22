--- @class OverpowerModule : Module
--- @field tracker OverpowerTracker
--- @diagnostic disable: duplicate-set-field
OverpowerModule = setmetatable({}, { __index = Module })
OverpowerModule.__index = OverpowerModule

function OverpowerModule.new()
    local instance = Module.new(ABILITY_OVERPOWER)
    setmetatable(instance, OverpowerModule)

    instance.tracker = OverpowerTracker.new()

    if instance.enabled then
        instance.tracker:subscribe()
    end

    return instance
end

function OverpowerModule:run()
    Logging:Debug("Casting Overpower")
    CastSpellByName(ABILITY_OVERPOWER)
end

function OverpowerModule:getPriority()
    local activeStance = Helpers:ActiveStance()
    if self.enabled and activeStance == 1 then
        local rage = UnitMana("player");

        if self.tracker:isAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and rage >= 5 then
            return 80
        else
            return -1;
        end
    end
end
