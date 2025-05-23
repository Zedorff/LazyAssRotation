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

--- @param context WarriorModuleRunContext
function OverpowerModule:getPriority(context)
    if self.enabled and context.stance == 1 then
        if self.tracker:isAvailable() and Helpers:SpellReady(ABILITY_OVERPOWER) and context.rage >= 5 then
            return 80
        else
            return -1;
        end
    end
end
