--- @class PriestModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field holyFireCost integer
--- @field smiteCost integer
--- @field innerFireCost integer
--- @filed vampiricCost integer
--- @field swpCost integer
--- @field mindBlastCost integer
--- @field mindFlayCost integer
PriestModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
PriestModuleRunContext.__index = PriestModuleRunContext

--- @param cache ManaCostCache
--- @return PriestModuleRunContext
function PriestModuleRunContext.new(cache)
    --- @class PriestModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, PriestModuleRunContext)

    self.mana = UnitMana("player")
    self.holyFireCost = cache:Get(Abilities.HolyFire.name)
    self.smiteCost = cache:Get(Abilities.Smite.name)
    self.innerFireCost = cache:Get(Abilities.InnerFire.name)
    self.vampiricCost = cache:Get(Abilities.VampiricEmbrace.name)
    self.swpCost = cache:Get(Abilities.ShadowWordPain.name)
    self.mindBlastCost = cache:Get(Abilities.MindBlast.name)
    self.mindFlayCost = cache:Get(Abilities.MindFlay.name)
    return self
end

--- @param cache ManaCostCache
function PriestModuleRunContext.PreheatCache(cache)
    cache:Get(Abilities.HolyFire.name)
    cache:Get(Abilities.Smite.name)
    cache:Get(Abilities.InnerFire.name)
    cache:Get(Abilities.VampiricEmbrace.name)
    cache:Get(Abilities.ShadowWordPain.name)
    cache:Get(Abilities.MindBlast.name)
    cache:Get(Abilities.MindFlay.name)
end
