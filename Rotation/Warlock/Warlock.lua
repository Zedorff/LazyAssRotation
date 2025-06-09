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
        SpecButtonInfo.new("Interface\\Icons\\Spell_Fire_Immolation", "Fire",  LARSelectedSpec == nil or LARSelectedSpec.name == "Fire"),
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

    WarlockModuleRunContext.PreheatCache(self.cache)
    return self
end

function Warlock:execute()
    ClassRotationPerformer:PerformRotation(WarlockModuleRunContext.new(self.cache))
end

function Warlock:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Fire" then
        self:EnableFireSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Warlock:EnableFireSpec()
    ModuleRegistry:RegisterModule(CurseOfRecklessnessModule.new(Helpers:PointsInTalent("Malediction") > 0))
    ModuleRegistry:RegisterModule(CurseOfTheElementsModule.new(Helpers:PointsInTalent("Malediction") > 0))
    ModuleRegistry:RegisterModule(CurseOfShadowModule.new(Helpers:PointsInTalent("Malediction") > 0))
    ModuleRegistry:RegisterModule(CurseOfWeaknessModule.new(Helpers:PointsInTalent("Malediction") > 0))
    ModuleRegistry:RegisterModule(CurseOfAgonyModule.new(Helpers:PointsInTalent("Malediction") > 0))
    ModuleRegistry:RegisterModule(SoulFireModule.new())
    ModuleRegistry:RegisterModule(ImmolateModule.new())
    ModuleRegistry:RegisterModule(ConflagrateModule.new())
    ModuleRegistry:RegisterModule(SearingPainModule.new())
    ModuleRegistry:RegisterModule(LifeTapModule.new())
end
