--- @enum ShockType
ShockType = {
    EARTH = ABILITY_EARTH_SHOCK,
    FLAME = ABILITY_FLAME_SHOCK,
    FROST = ABILITY_FROST_SHOCK
}

--- @class ShockModule : Module
--- @field stormStrikeTracker StormStrikeTracker
--- @field clearcastingTracker ClearcastingTracker
--- @field spellName string
--- @diagnostic disable: duplicate-set-field
ShockModule = setmetatable({}, { __index = Module })
ShockModule.__index = ShockModule

--- @param shockType ShockType
--- @param enabledByDefault boolean | nil
--- @return ShockModule
function ShockModule.new(shockType, enabledByDefault)
    --- @class ShockModule
    local instance = Module.new(shockType, enabledByDefault)
    setmetatable(instance, ShockModule)

    instance.stormStrikeTracker = StormStrikeTracker.new()
    instance.clearcastingTracker = ClearcastingTracker.new()
    instance.spellName = shockType

    if instance.enabled then
        instance.stormStrikeTracker:subscribe()
        instance.clearcastingTracker:subscribe()
        instance:DisableRestShockModules()
    end

    return instance
end

function ShockModule:enable()
    Module.enable(self)
    self.stormStrikeTracker:subscribe()
    self.clearcastingTracker:subscribe()
    self:DisableRestShockModules()
end

function ShockModule:disable()
    Module.disable(self)
    self.stormStrikeTracker:unsubscribe()
    self.clearcastingTracker:unsubscribe()
end

function ShockModule:run()
    Logging:Debug("Casting "..self.spellName)
    CastSpellByName(self.spellName)
end

--- @param context ShamanModuleRunContext
function ShockModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(self.spellName) then
        local cost = 1000; --- just to be sure if wrong spellName is passed rotation would not break
        if self.spellName == ShockType.EARTH then
            cost = context.earthCost
        elseif self.spellName == ShockType.FROST then
            cost = context.frostCost
        elseif self.spellName == ShockType.FLAME then
            cost = context.flameCost
        end

        if self.clearcastingTracker:isAvailable() and context.mana >= math.floor(cost * 0.33) then
            return 90;
        elseif self.stormStrikeTracker:isAvailable() and context.mana >= cost then
            return 90;
        elseif context.mana >= cost then
            return 75;
        end
    end
    return -1;
end

function ShockModule:DisableRestShockModules()
    if self.spellName == ShockType.EARTH then
        ModuleRegistry:DisableModule(ShockType.FLAME)
        ModuleRegistry:DisableModule(ShockType.FROST)
    elseif self.spellName == ShockType.FROST then
        ModuleRegistry:DisableModule(ShockType.EARTH)
        ModuleRegistry:DisableModule(ShockType.FLAME)
    elseif self.spellName == ShockType.FLAME then
        ModuleRegistry:DisableModule(ShockType.EARTH)
        ModuleRegistry:DisableModule(ShockType.FROST)
    end
end