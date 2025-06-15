--- @class PaladinModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field consecCost integer
--- @field crusaderCost integer
--- @field exorcismCost integer
--- @field holyStrikeCost integer
--- @field judjementCost integer
--- @field repentanceCost integer
--- @field socCost integer
--- @field socrCost integer
--- @field sorCost integer
--- @field sowCost integer
--- @field holyShieldCost integer
--- @field spec PaladinSpec
PaladinModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
PaladinModuleRunContext.__index = PaladinModuleRunContext

--- @param cache ManaCostCache
--- @param spec PaladinSpec
--- @return PaladinModuleRunContext
function PaladinModuleRunContext.new(cache, spec)
    --- @class PaladinModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, PaladinModuleRunContext)
    local mana = UnitMana("player")
    local maxMana = UnitManaMax("player")

    self.mana = mana
    self.remainingManaPercents = (mana / maxMana) * 100
    self.consecCost = cache:Get(Abilities.Consecration.name)
    self.crusaderCost = cache:Get(Abilities.CrusaderStrike.name)
    self.exorcismCost = cache:Get(Abilities.Exorcism.name)
    self.holyStrikeCost = cache:Get(Abilities.HolyStrike.name)
    self.judjementCost = cache:Get(Abilities.Judgement.name)
    self.repentanceCost = cache:Get(Abilities.Repentance.name)
    self.socCost = cache:Get(Abilities.SealCommand.name)
    self.socrCost = cache:Get(Abilities.SealCrusader.name)
    self.sorCost = cache:Get(Abilities.SealRighteousness.name)
    self.sowCost = cache:Get(Abilities.SealWisdom.name)
    self.holyShieldCost = cache:Get(Abilities.HolyShield.name)
    self.spec = spec
    return self
end

--- @param cache ManaCostCache
function PaladinModuleRunContext.PreheatCache(cache)
    cache:Get(Abilities.Consecration.name)
    cache:Get(Abilities.CrusaderStrike.name)
    cache:Get(Abilities.Exorcism.name)
    cache:Get(Abilities.HolyStrike.name)
    cache:Get(Abilities.Judgement.name)
    cache:Get(Abilities.Repentance.name)
    cache:Get(Abilities.SealCommand.name)
    cache:Get(Abilities.SealCrusader.name)
    cache:Get(Abilities.SealRighteousness.name)
    cache:Get(Abilities.SealWisdom.name)
    cache:Get(Abilities.HolyShield.name)
end