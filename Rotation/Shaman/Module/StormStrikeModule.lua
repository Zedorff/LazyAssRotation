--- @class StormStrikeModule : Module
--- @field clearcastingTracker ClearcastingTracker
--- @diagnostic disable: duplicate-set-field
StormStrikeModule = setmetatable({}, { __index = Module })
StormStrikeModule.__index = StormStrikeModule

--- @return StormStrikeModule
function StormStrikeModule.new()
    --- @class StormStrikeModule
    local instance = Module.new(ABILITY_STORMSTRIKE)
    setmetatable(instance, StormStrikeModule)

    instance.clearcastingTracker = ClearcastingTracker.new()

    if instance.enabled then
        instance.clearcastingTracker:subscribe()
    end

    return instance
end

function StormStrikeModule:enable()
    Module.enable(self)
    self.clearcastingTracker:subscribe()
end

function StormStrikeModule:disable()
    Module.disable(self)
    self.clearcastingTracker:unsubscribe()
end

function StormStrikeModule:run()
    Logging:Debug("Casting Storm Strike")
    CastSpellByName(ABILITY_STORMSTRIKE)
end

--- @param context ShamanModuleRunContext
function StormStrikeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_STORMSTRIKE) then
        local cost = self.clearcastingTracker:ShouldCast() and math.floor(context.ssCost * 0.33) or context.ssCost
        if context.mana > cost then
            return 80;
        end
    end
    return -1;
end
