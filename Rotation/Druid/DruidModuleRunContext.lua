--- @class DruidModuleRunContext : ModuleRunContext
--- @field energy integer
--- @field mana integer
--- @field rage integer
--- @field cp integer
--- @field shredCost integer
--- @field clawCost integer
--- @field rakeCost integer
--- @field ripCost integer
--- @field tigerFuryCost integer
--- @field ferociousBiteCost integer
--- @field catFormCost integer
--- @field maulCost integer
--- @field swipeCost integer
--- @field savageBiteCost integer
--- @field spec DruidSpec
DruidModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
DruidModuleRunContext.__index = DruidModuleRunContext

--- @param energyCache EnergyCostCache
--- @param manaCache ManaCostCache
--- @param rageCache RageCostCache
--- @param spec DruidSpec
--- @return DruidModuleRunContext
function DruidModuleRunContext.new(energyCache, manaCache, rageCache, spec)
    --- @class DruidModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, DruidModuleRunContext)

    local powerType = UnitPowerType("player")
    local unitMana = UnitMana("player")
    local mana = 0
    local energy = 0
    local rage = 0
    if powerType == 3 then
        energy = unitMana
    elseif powerType == 1 then
        rage = unitMana
    elseif powerType == 0 then
        mana = unitMana
    end

    self.energy = energy
    self.mana = mana
    self.rage = rage
    self.cp = GetComboPoints("player", "target")
    self.shredCost = energyCache:Get(ABILITY_SHRED)
    self.clawCost = energyCache:Get(ABILITY_CLAW)
    self.rakeCost = energyCache:Get(ABILITY_RAKE)
    self.ripCost = energyCache:Get(ABILITY_RIP)
    self.tigerFuryCost = energyCache:Get(ABILITY_TIGER_FURY)
    self.ferociousBiteCost = energyCache:Get(ABILITY_FEROCIOUS_BITE)
    self.catFormCost = manaCache:Get(ABILITY_CAT_FORM)
    self.maulCost = rageCache:Get(ABILITY_MAUL)
    self.swipeCost = rageCache:Get(ABILITY_SWIPE)
    self.savageBiteCost = rageCache:Get(ABILITY_SAVAGE_BITE)
    self.spec = spec
    return self
end

--- @param energyCache EnergyCostCache
--- @param manaCache ManaCostCache
--- @param rageCache RageCostCache
function DruidModuleRunContext.PreheatCache(energyCache, manaCache, rageCache)
    --- Cancel Clearcasting
    if Helpers:HasBuff("player", "Spell_Nature_Clearcasting") then
        for i = 1, 40 do
            local texture = UnitBuff("player", i)
            if texture and string.find(texture, "Spell_Nature_Lightning") then
                CancelPlayerBuff(i)
                break
            end
        end
    end
    energyCache:Get(ABILITY_CLAW)
    energyCache:Get(ABILITY_RAKE)
    energyCache:Get(ABILITY_RIP)
    energyCache:Get(ABILITY_TIGER_FURY)
    energyCache:Get(ABILITY_FEROCIOUS_BITE)
    energyCache:Get(ABILITY_SHRED)
    manaCache:Get(ABILITY_CAT_FORM)
    rageCache:Get(ABILITY_SWIPE)
    rageCache:Get(ABILITY_MAUL)
    rageCache:Get(ABILITY_SAVAGE_BITE)
end
