--- @class WarlockModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field searingCost integer
--- @field sfCost integer
--- @field conflagrateCost integer
--- @field immolateCost integer
--- @field corCost integer
--- @field cosCost integer
--- @field coeCost integer
--- @field coaCost integer
--- @field cowCost integer
--- @field corruptionCost integer
--- @field siphonLifeCost integer
--- @field darkHarvestCost integer
--- @field drainSoulCost integer
--- @field sbCost integer
WarlockModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
WarlockModuleRunContext.__index = WarlockModuleRunContext

--- @param cache ManaCostCache
--- @return WarlockModuleRunContext
function WarlockModuleRunContext.new(cache)
    --- @class WarlockModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, WarlockModuleRunContext)

    self.mana = UnitMana("player")
    self.searingCost = cache:Get(Abilities.SearingPain.name)
    self.conflagrateCost = cache:Get(Abilities.Conflagrate.name)
    self.immolateCost = cache:Get(Abilities.Immolate.name)
    self.sfCost = cache:Get(Abilities.SoulFire.name)
    self.corCost = cache:Get(Abilities.CoR.name)
    self.cosCost = cache:Get(Abilities.CoS.name)
    self.coeCost = cache:Get(Abilities.CoE.name)
    self.coaCost = cache:Get(Abilities.CoA.name)
    self.cowCost = cache:Get(Abilities.CoW.name)
    self.corruptionCost = cache:Get(Abilities.Corruption.name)
    self.siphonLifeCost = cache:Get(Abilities.SiphonLife.name)
    self.darkHarvestCost = cache:Get(Abilities.DarkHarvest.name)
    self.drainSoulCost = cache:Get(Abilities.DrainSoul.name)
    self.sbCost = cache:Get(Abilities.ShadowBolt.name)
    return self
end

--- @param cache ManaCostCache
function WarlockModuleRunContext.PreheatCache(cache)
    cache:Get(Abilities.SearingPain.name)
    cache:Get(Abilities.Conflagrate.name)
    cache:Get(Abilities.Immolate.name)
    cache:Get(Abilities.SoulFire.name)
    cache:Get(Abilities.CoE.name)
    cache:Get(Abilities.CoW.name)
    cache:Get(Abilities.CoR.name)
    cache:Get(Abilities.CoS.name)
    cache:Get(Abilities.CoA.name)
    cache:Get(Abilities.Corruption.name)
    cache:Get(Abilities.SiphonLife.name)
    cache:Get(Abilities.DarkHarvest.name)
    cache:Get(Abilities.DrainSoul.name)
    cache:Get(Abilities.ShadowBolt.name)
end
