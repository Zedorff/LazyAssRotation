--- @class Mage : ClassRotation
--- @field cache ManaCostCache
--- @field spec MageSpec
--- @diagnostic disable: duplicate-set-field
Mage = setmetatable({}, { __index = ClassRotation })
Mage.__index = Mage

--- @return Mage
function Mage.new()
    --- @class Mage
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Mage)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Arcane_Blast", "Arcane", LARSelectedSpec == nil or LARSelectedSpec.name == "Arcane"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Frost_FrostBolt02", "Frost", LARSelectedSpec ~= nil and LARSelectedSpec.name == "Frost"),
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

    return self
end

function Mage:execute()
    ClassRotationPerformer:PerformRotation(MageModuleRunContext.new(self.cache))
end

function Mage:Preheat()
    MageModuleRunContext.PreheatCache(self.cache)
end

function Mage:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Arcane" then
        self.spec = MageSpec.ARCANE
        self:EnableArcaneSpec()
    elseif spec.name == "Frost" then
        self.spec = MageSpec.FROST
        self:EnableFrostSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Mage:EnableArcaneSpec()
    ModuleRegistry:RegisterGroup(1, function()
        ModuleRegistry:RegisterModule(ArcaneRuptureModule.new())
        ModuleRegistry:RegisterModule(ArcaneMissilesModule.new())
        ModuleRegistry:RegisterModule(ArcaneSurgeModule.new())
    end)
    ModuleRegistry:RegisterGroup(2, "Armor", function()
        ModuleRegistry:RegisterModule(MageArmorModule.new())
    end)
    ModuleRegistry:RegisterGroup(3, "Conserve", function()
        ModuleRegistry:RegisterModule(MageClearcastingModule.new())
    end)
end

function Mage:EnableFrostSpec()
    ModuleRegistry:RegisterGroup(1, function()
        ModuleRegistry:RegisterModule(IciclesModule.new())
        ModuleRegistry:RegisterModule(FrostBoltModule.new())
    end)
    ModuleRegistry:RegisterGroup(2, "Armor", function()
        ModuleRegistry:RegisterModule(MageArmorModule.new())
        ModuleRegistry:RegisterModule(IceBarrierModule.new())
    end)
end
