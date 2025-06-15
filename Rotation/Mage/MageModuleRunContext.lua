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
    self.arCost = cache:Get(Abilities.ArcaneRupture.name)
    self.asCost = cache:Get(Abilities.ArcaneSurge.name)
    self.amCost = cache:Get(Abilities.ArcaneMissiles.name)
    return self
end

--- @param cache ManaCostCache
function MageModuleRunContext.PreheatCache(cache)
    --- Cancel Clearcasting
    if Helpers:HasBuff("player", "Spell_Shadow_ManaBurn") then
        for i = 1, 40 do
            local texture = UnitBuff("player", i)
            if texture and string.find(texture, "Spell_Shadow_ManaBurn") then
                CancelPlayerBuff(i)
                break
            end
        end
    end
    
    cache:Get(Abilities.ArcaneRupture.name)
    cache:Get(Abilities.ArcaneSurge.name)
    cache:Get(Abilities.ArcaneMissiles.name)
end
