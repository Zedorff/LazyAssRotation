--- @class Shaman : ClassRotation
--- @field cache ManaCostCache
--- @field spec ShamanSpec
Shaman = setmetatable({}, { __index = ClassRotation })
Shaman.__index = Shaman

function Shaman.new()
    --- @class Shaman
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Shaman)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Nature_LightningShield", "Enhance", LARSelectedSpec == nil or LARSelectedSpec.name == "Enhance"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Nature_Lightning", "Elem", LARSelectedSpec and LARSelectedSpec.name == "Elem")
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

    return self
end

function Shaman:execute()
    ClassRotationPerformer:PerformRotation(ShamanModuleRunContext.new(self.cache, self.spec))
end

function Shaman:Preheat()
    ShamanModuleRunContext.PreheatCache(self.cache)
end

function Shaman:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Enhance" then
        self.spec = ShamanSpec.ENHANCE
        self:EnableEnhanceSpec()
    elseif spec.name == "Elem" then
        self.spec = ShamanSpec.ELEM
        self:EnableElemSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Shaman:EnableEnhanceSpec()
    ModuleRegistry:RegisterModule(WaterShieldModule.new())
    ModuleRegistry:RegisterModule(LightningShieldModule.new())
    ModuleRegistry:RegisterModule(StormStrikeModule.new())
    ModuleRegistry:RegisterModule(LightningStrikeModule.new())
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_EARTH_SHOCK, "Interface\\Icons\\Spell_Nature_EarthShock", true))
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_FROST_SHOCK, "Interface\\Icons\\Spell_Frost_FrostShock", false))
    ModuleRegistry:RegisterModule(ShockModule.new(ABILITY_FLAME_SHOCK, "Interface\\Icons\\Spell_Fire_FlameShock", false))
    ModuleRegistry:RegisterModule(WindfuryModule.new())
    ModuleRegistry:RegisterModule(RockbiterModule.new())
end

function Shaman:EnableElemSpec()
    ModuleRegistry:RegisterModule(WaterShieldModule.new())
    ModuleRegistry:RegisterModule(LightningBoltModule.new())
    ModuleRegistry:RegisterModule(ChainLightningModule.new())
    ModuleRegistry:RegisterModule(ShamanClearcastingModule.new())
end
