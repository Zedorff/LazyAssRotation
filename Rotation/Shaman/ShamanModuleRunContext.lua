--- @class ShamanModuleRunContext : ModuleRunContext
--- @field mana integer
--- @field remainingManaPercents number
--- @field ssCost integer
--- @field lsCost integer
--- @field earthCost integer
--- @field frostCost integer
--- @field flameCost integer
ShamanModuleRunContext = setmetatable({}, { __index = ModuleRunContext })
ShamanModuleRunContext.__index = ShamanModuleRunContext

--- @param cache ManaCostCache
--- @return ShamanModuleRunContext
function ShamanModuleRunContext.new(cache)
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

    return self
end

--- @param cache ManaCostCache
function ShamanModuleRunContext.PreheatCache(cache)
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

    cache:Get(ABILITY_LIGHTNING_STRIKE)
    cache:Get(ABILITY_STORMSTRIKE)
    cache:Get(ABILITY_EARTH_SHOCK)
    cache:Get(ABILITY_FLAME_SHOCK)
    cache:Get(ABILITY_FROST_SHOCK)
end
