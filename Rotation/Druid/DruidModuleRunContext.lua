--- @class DruidModuleRunContext : ModuleRunContext
--- @field energy integer
--- @field cp integer
--- @field shredCost integer
--- @field clawCost integer
--- @field rakeCost integer
--- @field ripCost integer
--- @field tigerFuryCost integer
--- @field ferociousBiteCost integer
--- @field catFormCost integer
DruidModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
DruidModuleRunContext.__index = DruidModuleRunContext

--- @param energyCache EnergyCostCache
--- @param manaCache ManaCostCache
--- @return DruidModuleRunContext
function DruidModuleRunContext.new(energyCache, manaCache)
    --- @class DruidModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, DruidModuleRunContext)

    local powerType = UnitPowerType("player")
    local mana = UnitMana("player")
    local energy = 0
    if powerType == 3 then
        energy = mana
    end

    self.energy = energy
    self.cp = GetComboPoints("player", "target")
    self.shredCost = energyCache:Get(ABILITY_SHRED)
    self.clawCost = energyCache:Get(ABILITY_CLAW)
    self.rakeCost = energyCache:Get(ABILITY_RAKE)
    self.ripCost = energyCache:Get(ABILITY_RIP)
    self.tigerFuryCost = energyCache:Get(ABILITY_TIGER_FURY)
    self.ferociousBiteCost = energyCache:Get(ABILITY_FEROCIOUS_BITE)
    self.catFormCost = manaCache:Get(ABILITY_CAT_FORM)
    return self
end

--- @param energyCache EnergyCostCache
--- @param manaCache ManaCostCache
function DruidModuleRunContext.PreheatCache(energyCache, manaCache)
    energyCache:Get(ABILITY_CLAW)
    energyCache:Get(ABILITY_RAKE)
    energyCache:Get(ABILITY_RIP)
    energyCache:Get(ABILITY_TIGER_FURY)
    energyCache:Get(ABILITY_FEROCIOUS_BITE)
    energyCache:Get(ABILITY_SHRED)
    manaCache:Get(ABILITY_CAT_FORM)
end
