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
WarriorModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
WarriorModuleRunContext.__index = WarriorModuleRunContext

--- @param cache RageCostCache
--- @param spec WarriorSpec
function WarriorModuleRunContext.new(cache, spec)
    local context = {
        rage = UnitMana("player"),
        msCost = cache:Get(ABILITY_MORTAL_STRIKE),
        bsCost = cache:Get(ABILITY_BLOODTHIRST),
        wwCost = cache:Get(ABILITY_WHIRLWIND),
        shoutCost = cache:Get(ABILITY_BATTLE_SHOUT),
        hsCost = cache:Get(ABILITY_HEROIC_STRIKE),
        hamstringCost = cache:Get(ABILITY_HAMSTRING),
        slamCost = cache:Get(ABILITY_SLAM),
        rendCost = cache:Get(ABILITY_REND),
        stance = Helpers:ActiveStance(),
        spec = spec
    }
    return setmetatable(context, WarriorModuleRunContext)
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
end