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
PaladinModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
PaladinModuleRunContext.__index = PaladinModuleRunContext

--- @param cache ManaCostCache
--- @return PaladinModuleRunContext
function PaladinModuleRunContext.new(cache)
    --- @class PaladinModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, PaladinModuleRunContext)
    local mana = UnitMana("player")
    local maxMana = UnitManaMax("player")

    self.mana = mana
    self.remainingManaPercents = (mana / maxMana) * 100
    self.consecCost = cache:Get(ABILITY_CONSECRATION)
    self.crusaderCost = cache:Get(ABILITY_CRUSADER_STRIKE)
    self.exorcismCost = cache:Get(ABILITY_EXORCISM)
    self.holyStrikeCost = cache:Get(ABILITY_HOLY_STRIKE)
    self.judjementCost = cache:Get(ABILITY_JUDGEMENT)
    self.repentanceCost = cache:Get(ABILITY_REPENTANCE)
    self.socCost = cache:Get(ABILITY_SEAL_OF_COMMAND)
    self.socrCost = cache:Get(ABILITY_SEAL_OF_CRUSADER)
    self.sorCost = cache:Get(ABILITY_SEAL_OF_RIGHTEOUSNESS)
    self.sowCost = cache:Get(ABILITY_SEAL_OF_WISDOM)
    return self
end

--- @param cache ManaCostCache
function PaladinModuleRunContext.PreheatCache(cache)
    cache:Get(ABILITY_CONSECRATION)
    cache:Get(ABILITY_CRUSADER_STRIKE)
    cache:Get(ABILITY_EXORCISM)
    cache:Get(ABILITY_HOLY_STRIKE)
    cache:Get(ABILITY_JUDGEMENT)
    cache:Get(ABILITY_REPENTANCE)
    cache:Get(ABILITY_SEAL_OF_COMMAND)
    cache:Get(ABILITY_SEAL_OF_CRUSADER)
    cache:Get(ABILITY_SEAL_OF_RIGHTEOUSNESS)
    cache:Get(ABILITY_SEAL_OF_WISDOM)
end