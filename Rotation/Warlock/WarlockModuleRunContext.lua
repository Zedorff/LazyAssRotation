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
    self.searingCost = cache:Get(ABILITY_SEARING_PAIN)
    self.conflagrateCost = cache:Get(ABILITY_CONFLAGRATE)
    self.immolateCost = cache:Get(ABILITY_IMMOLATE)
    self.sfCost = cache:Get(ABILITY_SOUL_FIRE)
    self.corCost = cache:Get(ABILITY_COR)
    self.cosCost = cache:Get(ABILITY_COS)
    self.coeCost = cache:Get(ABILITY_COE)
    self.coaCost = cache:Get(ABILITY_COA)
    self.cowCost = cache:Get(ABILITY_COW)
    self.corruptionCost = cache:Get(ABILITY_CORRUPTION)
    self.siphonLifeCost = cache:Get(ABILITY_SIPHON_LIFE)
    self.darkHarvestCost = cache:Get(ABILITY_DARK_HARVEST)
    self.drainSoulCost = cache:Get(ABILITY_DRAIN_SOUL)
    self.sbCost = cache:Get(ABILITY_SHADOW_BOLT)
    return self
end

--- @param cache ManaCostCache
function WarlockModuleRunContext.PreheatCache(cache)
    cache:Get(ABILITY_SEARING_PAIN)
    cache:Get(ABILITY_CONFLAGRATE)
    cache:Get(ABILITY_IMMOLATE)
    cache:Get(ABILITY_SOUL_FIRE)
    cache:Get(ABILITY_COE)
    cache:Get(ABILITY_COW)
    cache:Get(ABILITY_COR)
    cache:Get(ABILITY_COS)
    cache:Get(ABILITY_COA)
    cache:Get(ABILITY_CORRUPTION)
    cache:Get(ABILITY_SIPHON_LIFE)
    cache:Get(ABILITY_DARK_HARVEST)
    cache:Get(ABILITY_DRAIN_SOUL)
    cache:Get(ABILITY_SHADOW_BOLT)
end
