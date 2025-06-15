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
    self.msCost = cache:Get(Abilities.MortalStrike.name)
    self.bsCost = cache:Get(Abilities.Bloodthirst.name)
    self.wwCost = cache:Get(Abilities.Whirlwind.name)
    self.shoutCost = cache:Get(Abilities.BattleShout.name)
    self.hsCost = cache:Get(Abilities.HeroicStrike.name)
    self.hamstringCost = cache:Get(Abilities.Hamstring.name)
    self.slamCost = cache:Get(Abilities.Slam.name)
    self.rendCost = cache:Get(Abilities.Rend.name)
    self.stance = Helpers:ActiveStance()
    self.spec = spec
    self.shieldSlamCost = cache:Get(Abilities.ShieldSlam.name)

    return self
end

--- @param cache RageCostCache
function WarriorModuleRunContext.PreheatCache(cache)
    cache:Get(Abilities.MortalStrike.name)
    cache:Get(Abilities.Bloodthirst.name)
    cache:Get(Abilities.Whirlwind.name)
    cache:Get(Abilities.BattleShout.name)
    cache:Get(Abilities.HeroicStrike.name)
    cache:Get(Abilities.Hamstring.name)
    cache:Get(Abilities.Slam.name)
    cache:Get(Abilities.Rend.name)
    cache:Get(Abilities.ShieldSlam.name)
end
