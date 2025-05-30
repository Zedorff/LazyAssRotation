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

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Ability_Druid_CatForm", "Powershifting",
            MLDpsSelectedSpec == nil or MLDpsSelectedSpec.name == "Powershifting"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Druid_Disembowel", "Bleeds",
            MLDpsSelectedSpec and MLDpsSelectedSpec.name == "Bleeds")
    }

    if not MLDpsSelectedSpec then
        MLDpsSelectedSpec = specs[1]
    end

    self:SelectSpec(MLDpsSelectedSpec)

    MLDps_CreateSpecButtons("TOP", specs)

    DruidModuleRunContext.PreheatCache(self.cache, self.manaCache)

    return self
end

function Druid:execute()
    ClassRotationPerformer:PerformRotation(DruidModuleRunContext.new(self.cache, self.manaCache))
end

function Druid:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Powershifting" then
        self:EnablePowershiftingSpec()
    elseif spec.name == "Bleeds" then
        self:EnableBleedSpec()
    end
end

function Druid:EnableBleedSpec()
    ModuleRegistry:RegisterModule(ClawModule.new())
    ModuleRegistry:RegisterModule(RipModule.new())
    ModuleRegistry:RegisterModule(RakeModule.new())
    ModuleRegistry:RegisterModule(ShredModule.new())
    ModuleRegistry:RegisterModule(FerociousBiteModule.new())
    ModuleRegistry:RegisterModule(TigerFuryModule.new())

    MLDps_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end

function Druid:EnablePowershiftingSpec()
    ModuleRegistry:RegisterModule(ShredModule.new())
    ModuleRegistry:RegisterModule(FerociousBiteModule.new())
    ModuleRegistry:RegisterModule(PowerShiftingModule.new())
    ModuleRegistry:RegisterModule(TigerFuryModule.new())

    MLDps_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end
