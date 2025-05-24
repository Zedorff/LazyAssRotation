--- @class Shaman : ClassRotation
--- @field cache ManaCostCache
Shaman = setmetatable({}, { __index = ClassRotation })
Shaman.__index = Shaman

function Shaman.new()
    --- @class Shaman
    local instance = ClassRotation.new(ManaCostCache.new())
    setmetatable(instance, Shaman)

    ModuleRegistry:RegisterModule(WaterShieldModule.new())
    ModuleRegistry:RegisterModule(LightningShieldModule.new())
    ModuleRegistry:RegisterModule(StormStrikeModule.new())
    ModuleRegistry:RegisterModule(LightningStrikeModule.new())
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_EARTH_SHOCK, true))
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_FROST_SHOCK, false))
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_FLAME_SHOCK, false))
    ModuleRegistry:RegisterModule(WindfuryModule.new())
    ModuleRegistry:RegisterModule(RockbiterModule.new())

    ShamanModuleRunContext.PreheatCache(instance.cache)
    return instance
end

function Shaman:execute()
    ClassRotationPerformer:PerformRotation(ShamanModuleRunContext.new(self.cache))
end