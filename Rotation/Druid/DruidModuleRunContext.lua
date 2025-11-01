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
--- @field reshiftCost integer
--- @field maulCost integer
--- @field swipeCost integer
--- @field savageBiteCost integer
--- @field moonfireCost integer
--- @field starfireCost integer
--- @field swarmCost integer
--- @field wrathCost integer
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
    self.shredCost = energyCache:Get(Abilities.Shred.name)
    self.clawCost = energyCache:Get(Abilities.Claw.name)
    self.rakeCost = energyCache:Get(Abilities.Rake.name)
    self.ripCost = energyCache:Get(Abilities.Rip.name)
    self.tigerFuryCost = energyCache:Get(Abilities.TigersFury.name)
    self.ferociousBiteCost = energyCache:Get(Abilities.FerociousBite.name)
    self.reshiftCost = manaCache:Get(Abilities.Reshift.name)
    self.maulCost = rageCache:Get(Abilities.Maul.name)
    self.swipeCost = rageCache:Get(Abilities.Swipe.name)
    self.savageBiteCost = rageCache:Get(Abilities.SavageBite.name)
    self.moonfireCost = manaCache:Get(Abilities.Moonfire.name)
    self.starfireCost = manaCache:Get(Abilities.Starfire.name)
    self.wrathCost = manaCache:Get(Abilities.Wrath.name)
    self.swarmCost = manaCache:Get(Abilities.InsectSwarm.name)
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
    energyCache:Get(Abilities.Claw.name)
    energyCache:Get(Abilities.Rake.name)
    energyCache:Get(Abilities.Rip.name)
    energyCache:Get(Abilities.TigersFury.name)
    energyCache:Get(Abilities.FerociousBite.name)
    energyCache:Get(Abilities.Shred.name)
    manaCache:Get(Abilities.Reshift.name)
    rageCache:Get(Abilities.Swipe.name)
    rageCache:Get(Abilities.Maul.name)
    rageCache:Get(Abilities.SavageBite.name)
    manaCache:Get(Abilities.InsectSwarm.name)
    manaCache:Get(Abilities.Moonfire.name)
    manaCache:Get(Abilities.Wrath.name)
    manaCache:Get(Abilities.Starfire.name)
end
