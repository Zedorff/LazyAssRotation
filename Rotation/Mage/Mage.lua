--- @class Mage : ClassRotation
--- @field cache ManaCostCache
--- @field spec WarriorSpec
--- @diagnostic disable: duplicate-set-field
Mage = setmetatable({}, { __index = ClassRotation })
Mage.__index = Mage

--- @return Mage
function Mage.new()
    --- @class Mage
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Mage)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Arcane_Blast", "Arcane",  LARSelectedSpec == nil or LARSelectedSpec.name == "Arcane"),
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

    MageModuleRunContext.PreheatCache(self.cache)
    return self
end

function Mage:execute()
    ClassRotationPerformer:PerformRotation(MageModuleRunContext.new(self.cache))
end

function Mage:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Arcane" then
        self:EnableArcaneSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Mage:EnableArcaneSpec()
    ModuleRegistry:RegisterModule(ArcaneRuptureModule.new())
    ModuleRegistry:RegisterModule(ArcaneSurgeModule.new())
    ModuleRegistry:RegisterModule(ArcaneMissilesModule.new())
end
