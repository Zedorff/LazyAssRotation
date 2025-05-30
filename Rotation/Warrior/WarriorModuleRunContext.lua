--- @class WarriorModuleRunContext : ModuleRunContext
--- @field rage integer
--- @field msCost integer
--- @field bsCost integer
--- @field wwCost integer
--- @field shoutCost integer
--- @field hsCost integer
--- @field hamstringCost integer
--- @field slamCost integer
--- @field rendCost integer
--- @field stance integer
--- @field spec WarriorSpec
--- @field shieldSlamCost integer
WarriorModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
WarriorModuleRunContext.__index = WarriorModuleRunContext

--- @param cache RageCostCache
--- @param spec WarriorSpec
--- @return WarriorModuleRunContext
function WarriorModuleRunContext.new(cache, spec)
    --- @class WarriorModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, WarriorModuleRunContext)

    self.rage = UnitMana("player")
    self.msCost = cache:Get(ABILITY_MORTAL_STRIKE)
    self.bsCost = cache:Get(ABILITY_BLOODTHIRST)
    self.wwCost = cache:Get(ABILITY_WHIRLWIND)
    self.shoutCost = cache:Get(ABILITY_BATTLE_SHOUT)
    self.hsCost = cache:Get(ABILITY_HEROIC_STRIKE)
    self.hamstringCost = cache:Get(ABILITY_HAMSTRING)
    self.slamCost = cache:Get(ABILITY_SLAM)
    self.rendCost = cache:Get(ABILITY_REND)
    self.stance = Helpers:ActiveStance()
    self.spec = spec
    self.shieldSlamCost = cache:Get(ABILITY_SHIELD_SLAM)

    return self
end

--- @param cache RageCostCache
function WarriorModuleRunContext.PreheatCache(cache)
    cache:Get(ABILITY_MORTAL_STRIKE)
    cache:Get(ABILITY_BLOODTHIRST)
    cache:Get(ABILITY_WHIRLWIND)
    cache:Get(ABILITY_BATTLE_SHOUT)
    cache:Get(ABILITY_HEROIC_STRIKE)
    cache:Get(ABILITY_HAMSTRING)
    cache:Get(ABILITY_SLAM)
    cache:Get(ABILITY_REND)
    cache:Get(ABILITY_SHIELD_SLAM)
end
