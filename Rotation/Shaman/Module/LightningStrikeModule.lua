--- @class LightningStrikeModule : Module
--- @field clearcastingTracker ClearcastingTracker
--- @diagnostic disable: duplicate-set-field
LightningStrikeModule = setmetatable({}, { __index = Module })
LightningStrikeModule.__index = LightningStrikeModule

--- @return LightningStrikeModule
function LightningStrikeModule.new()
    --- @class LightningStrikeModule
    local instance = Module.new(ABILITY_LIGHTNING_STRIKE)
    setmetatable(instance, LightningStrikeModule)
    
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

function LightningStrikeModule:run()
    Logging:Debug("Casting Lightning Strike")
    CastSpellByName(ABILITY_LIGHTNING_STRIKE)
end

--- @param context ShamanModuleRunContext
function LightningStrikeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_LIGHTNING_STRIKE) then
        local cost = self.clearcastingTracker:ShouldCast() and math.floor(context.lsCost * 0.33) or context.lsCost
        if context.remainingManaPercents < 10 then
            return 95;
        elseif context.mana > cost then
            return 50;
        end
    end
    return -1;
end
