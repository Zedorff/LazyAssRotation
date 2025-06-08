--- @class ShamanModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field remainingManaPercents number
--- @field ssCost integer
--- @field lsCost integer
--- @field earthCost integer
--- @field frostCost integer
--- @field flameCost integer
--- @field lbCost integer
--- @field clCost integer
--- @field spec ShamanSpec
ShamanModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
ShamanModuleRunContext.__index = ShamanModuleRunContext

--- @param cache ManaCostCache
--- @param spec ShamanSpec
--- @return ShamanModuleRunContext
function ShamanModuleRunContext.new(cache, spec)
    --- @class ShamanModuleRunContext
    local self = ModuleRunContext.new()
    setmetatable(self, ShamanModuleRunContext)

    local mana = UnitMana("player")
    local maxMana = UnitManaMax("player")

    self.mana = mana
    self.remainingManaPercents = (mana / maxMana) * 100
    self.ssCost = cache:Get(ABILITY_STORMSTRIKE)
    self.lsCost = cache:Get(ABILITY_LIGHTNING_STRIKE)
    self.earthCost = cache:Get(ABILITY_EARTH_SHOCK)
    self.frostCost = cache:Get(ABILITY_FROST_SHOCK)
    self.flameCost = cache:Get(ABILITY_FLAME_SHOCK)
    self.lbCost = cache:Get(ABILITY_LIGHTNING_BOLT)
    self.clCost = cache:Get(ABILITY_CHAIN_LIGHTNING)
    self.spec = spec

    return self
end

--- @param cache ManaCostCache
function ShamanModuleRunContext.PreheatCache(cache)
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

    cache:Get(ABILITY_LIGHTNING_STRIKE)
    cache:Get(ABILITY_STORMSTRIKE)
    cache:Get(ABILITY_EARTH_SHOCK)
    cache:Get(ABILITY_FLAME_SHOCK)
    cache:Get(ABILITY_FROST_SHOCK)
    cache:Get(ABILITY_CHAIN_LIGHTNING)
    cache:Get(ABILITY_LIGHTNING_BOLT)
end
