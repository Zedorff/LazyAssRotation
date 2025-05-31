--- @class Druid : ClassRotation
--- @field cache EnergyCostCache
--- @field manaCache ManaCostCache
--- @field rageCache RageCostCache
--- @field spec DruidSpec
--- @diagnostic disable: duplicate-set-field
Druid = setmetatable({}, { __index = ClassRotation })
Druid.__index = Druid

--- @return Druid
function Druid.new()
    --- @class Druid
    local self = ClassRotation.new(EnergyCostCache.new())
    setmetatable(self, Druid)
    self.manaCache = ManaCostCache.new()
    self.rageCache = RageCostCache.new()

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Ability_Druid_CatForm", "Powershifting", LARSelectedSpec == nil or LARSelectedSpec.name == "Powershifting"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Druid_Disembowel", "Bleeds", LARSelectedSpec and LARSelectedSpec.name == "Bleeds"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Racial_BearForm", "Bear", LARSelectedSpec and LARSelectedSpec.name == "Bear")
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    self:SelectSpec(LARSelectedSpec)

    HotSwap_CreateSpecButtons(specs)

    DruidModuleRunContext.PreheatCache(self.cache, self.manaCache, self.rageCache)

    return self
end

function Druid:execute()
    ClassRotationPerformer:PerformRotation(DruidModuleRunContext.new(self.cache, self.manaCache, self.rageCache, self.spec))
end

function Druid:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Powershifting" then
        self.spec = DruidSpec.POWERSHIFTING
        self:EnablePowershiftingSpec()
    elseif spec.name == "Bleeds" then
        self.spec = DruidSpec.BLEED
        self:EnableBleedSpec()
    elseif spec.name == "Bear" then
        self.spec = DruidSpec.BEAR
        self:EnabledBearSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Druid:EnableBleedSpec()
    ModuleRegistry:RegisterModule(ClawModule.new())
    ModuleRegistry:RegisterModule(RipModule.new())
    ModuleRegistry:RegisterModule(RakeModule.new())
    ModuleRegistry:RegisterModule(ShredModule.new())
    ModuleRegistry:RegisterModule(FerociousBiteModule.new())
    ModuleRegistry:RegisterModule(TigerFuryModule.new())
end

function Druid:EnablePowershiftingSpec()
    ModuleRegistry:RegisterModule(ShredModule.new())
    ModuleRegistry:RegisterModule(FerociousBiteModule.new())
    ModuleRegistry:RegisterModule(PowerShiftingModule.new())
    ModuleRegistry:RegisterModule(TigerFuryModule.new())
end

function Druid:EnabledBearSpec()
    ModuleRegistry:RegisterModule(MaulModule.new())
    ModuleRegistry:RegisterModule(SavageBiteModule.new())
    ModuleRegistry:RegisterModule(SwipeModule.new())
end
