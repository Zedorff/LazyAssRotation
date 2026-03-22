--- @class Warlock : ClassRotation
--- @field cache ManaCostCache
--- @field spec WarlockSpec
--- @diagnostic disable: duplicate-set-field
Warlock = setmetatable({}, { __index = ClassRotation })
Warlock.__index = Warlock

--- @return Warlock
function Warlock.new()
    --- @class Warlock
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Warlock)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Fire_Immolation", "Fire",
            LARSelectedSpec == nil or LARSelectedSpec.name == "Fire"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Shadow_AbominationExplosion", "Affliction",
            LARSelectedSpec and LARSelectedSpec.name == "Affliction"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Shadow_ShadowBolt", "SM",
            LARSelectedSpec and LARSelectedSpec.name == "SM"),
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

    return self
end

function Warlock:execute()
    ClassRotationPerformer:PerformRotation(WarlockModuleRunContext.new(self.cache, self.spec))
end

function Warlock:Preheat()
    WarlockModuleRunContext.PreheatCache(self.cache)
end

function Warlock:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Fire" then
        self.spec = WarlockSpec.FIRE
        self:EnableFireSpec()
    elseif spec.name == "Affliction" then
        self.spec = WarlockSpec.AFFLICTION
        self:EnableAflySpec()
    elseif spec.name == "SM" then
        self.spec = WarlockSpec.SMRUIN
        self:EnableSMSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Warlock:EnableFireSpec()
    ModuleRegistry:RegisterModule(CurseOfRecklessnessModule.new())
    ModuleRegistry:RegisterModule(CurseOfTheElementsModule.new())
    ModuleRegistry:RegisterModule(CurseOfShadowModule.new())
    ModuleRegistry:RegisterModule(CurseOfWeaknessModule.new())
    ModuleRegistry:RegisterModule(CurseOfAgonyModule.new())
    ModuleRegistry:RegisterModule(SoulFireModule.new())
    ModuleRegistry:RegisterModule(ImmolateModule.new())
    ModuleRegistry:RegisterModule(ConflagrateModule.new())
    ModuleRegistry:RegisterModule(SearingPainModule.new())
    ModuleRegistry:RegisterModule(LifeTapModule.new())
end

function Warlock:EnableAflySpec()
    ModuleRegistry:RegisterModule(CurseOfRecklessnessModule.new())
    ModuleRegistry:RegisterModule(CurseOfTheElementsModule.new())
    ModuleRegistry:RegisterModule(CurseOfShadowModule.new())
    ModuleRegistry:RegisterModule(CurseOfWeaknessModule.new())
    ModuleRegistry:RegisterModule(CurseOfAgonyModule.new())
    ModuleRegistry:RegisterModule(CorruptionModule.new())
    ModuleRegistry:RegisterModule(SiphonLifeModule.new())
    ModuleRegistry:RegisterModule(DarkHarvestModule.new())
    ModuleRegistry:RegisterModule(DrainSoulModule.new())
    ModuleRegistry:RegisterModule(NightfallModule.new())
    ModuleRegistry:RegisterModule(LifeTapModule.new())
end

function Warlock:EnableSMSpec()
    ModuleRegistry:RegisterModule(CurseOfRecklessnessModule.new())
    ModuleRegistry:RegisterModule(CurseOfTheElementsModule.new())
    ModuleRegistry:RegisterModule(CurseOfShadowModule.new())
    ModuleRegistry:RegisterModule(CurseOfWeaknessModule.new())
    ModuleRegistry:RegisterModule(CurseOfAgonyModule.new())
    ModuleRegistry:RegisterModule(CorruptionModule.new())
    ModuleRegistry:RegisterModule(SiphonLifeModule.new())
    ModuleRegistry:RegisterModule(ShadowBoltModule.new())
    ModuleRegistry:RegisterModule(LifeTapModule.new())
end
