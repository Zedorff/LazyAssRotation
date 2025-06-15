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
    self.ssCost = cache:Get(Abilities.Stormstrike.name)
    self.lsCost = cache:Get(Abilities.LightningStrike.name)
    self.earthCost = cache:Get(Abilities.EarthShock.name)
    self.frostCost = cache:Get(Abilities.FrostShock.name)
    self.flameCost = cache:Get(Abilities.FlameShock.name)
    self.lbCost = cache:Get(Abilities.LightningBolt.name)
    self.clCost = cache:Get(Abilities.ChainLightning.name)
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

    cache:Get(Abilities.LightningStrike.name)
    cache:Get(Abilities.Stormstrike.name)
    cache:Get(Abilities.EarthShock.name)
    cache:Get(Abilities.FlameShock.name)
    cache:Get(Abilities.FrostShock.name)
    cache:Get(Abilities.ChainLightning.name)
    cache:Get(Abilities.LightningBolt.name)
end
