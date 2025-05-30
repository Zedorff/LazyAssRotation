--- @class Shaman : ClassRotation
--- @field cache ManaCostCache
Shaman = setmetatable({}, { __index = ClassRotation })
Shaman.__index = Shaman

function Shaman.new()
    --- @class Shaman
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Shaman)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Nature_LightningShield", "Enhance", SelectedSpec == nil or SelectedSpec.name == "Enhance")
    }

    if not SelectedSpec then
        SelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons("TOP", specs)

    self:SelectSpec(SelectedSpec)

    ShamanModuleRunContext.PreheatCache(self.cache)
    return self
end

function Shaman:execute()
    ClassRotationPerformer:PerformRotation(ShamanModuleRunContext.new(self.cache))
end

function Shaman:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Enhance" then
        self:EnableEnhanceSpec()
    end
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

    HotSwap_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end
