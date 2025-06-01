--- @class MageModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field arCost integer
--- @field asCost integer
--- @field amCost integer
MageModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
MageModuleRunContext.__index = MageModuleRunContext

--- @param cache ManaCostCache
--- @return MageModuleRunContext
function MageModuleRunContext.new(cache)
    --- @class MageModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, MageModuleRunContext)

    self.mana = UnitMana("player")
    self.arCost = cache:Get(ABILITY_ARCANE_RUPTURE)
    self.asCost = cache:Get(ABILITY_ARCANE_SURGE)
    self.amCost = cache:Get(ABILITY_ARCANE_MISSILES)
    return self
end

--- @param cache ManaCostCache
function MageModuleRunContext.PreheatCache(cache)
    cache:Get(ABILITY_ARCANE_RUPTURE)
    cache:Get(ABILITY_ARCANE_SURGE)
    cache:Get(ABILITY_ARCANE_MISSILES)
end
