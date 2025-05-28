--- @class Druid : ClassRotation
--- @field cache EnergyCostCache
--- @field manaCache ManaCostCache
--- @diagnostic disable: duplicate-set-field
Druid = setmetatable({}, { __index = ClassRotation })
Druid.__index = Druid

--- @return Druid
function Druid.new()
    --- @class Druid
    local self = ClassRotation.new(EnergyCostCache.new())
    setmetatable(self, Druid)
    self.manaCache = ManaCostCache.new()
    ModuleRegistry:RegisterModule(ClawModule.new())
    ModuleRegistry:RegisterModule(FerociousBiteModule.new())
    ModuleRegistry:RegisterModule(PowerShiftingModule.new())
    ModuleRegistry:RegisterModule(RipModule.new())
    ModuleRegistry:RegisterModule(RakeModule.new())
    ModuleRegistry:RegisterModule(ShredModule.new())
    ModuleRegistry:RegisterModule(TigerFuryModule.new())

    DruidModuleRunContext.PreheatCache(self.cache, self.manaCache)
    return self
end

function Druid:execute()
    ClassRotationPerformer:PerformRotation(DruidModuleRunContext.new(self.cache, self.manaCache))
end
