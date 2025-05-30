--- @alias ShockTrackers { stormStrikeTracker: StormStrikeTracker, clearcastingTracker: ClearcastingTracker }

--- @enum ShockType
ShockType = {
    EARTH = ABILITY_EARTH_SHOCK,
    FLAME = ABILITY_FLAME_SHOCK,
    FROST = ABILITY_FROST_SHOCK
}

--- @class ShockModule : Module
--- @field trackers ShockTrackers
--- @field spellName string
--- @diagnostic disable: duplicate-set-field
ShockModule = setmetatable({}, { __index = Module })
ShockModule.__index = ShockModule

--- @param shockType ShockType
--- @param iconPath string
--- @param enabledByDefault boolean | nil
--- @return ShockModule
function ShockModule.new(shockType, iconPath, enabledByDefault)
    --- @type ShockTrackers
    local trackers = {
        stormStrikeTracker = StormStrikeTracker.new(),
        clearcastingTracker = ClearcastingTracker.new()
    }
    --- @class ShockModule
    local self = setmetatable(Module.new(shockType, trackers, iconPath, enabledByDefault), ShockModule)

    self.spellName = shockType

    if self.enabled then
        self:DisableRestShockModules()
    end

    return self
end

function ShockModule:enable()
    Module.enable(self)
    self:DisableRestShockModules()
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

        if self.trackers.clearcastingTracker:ShouldCast() and context.mana >= math.floor(cost * 0.33) then
            return 90;
        elseif self.trackers.stormStrikeTracker:ShouldCast() and context.mana >= cost then
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