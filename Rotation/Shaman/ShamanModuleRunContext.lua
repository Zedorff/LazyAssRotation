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
function ShamanModuleRunContext.new(cache)
    local mana = UnitMana("player")
    local maxMana = UnitManaMax("player")
    local context = {
        mana = mana,
        remainingManaPercents = (mana / maxMana) * 100,
        ssCost = cache:Get(ABILITY_STORMSTRIKE),
        lsCost = cache:Get(ABILITY_LIGHTNING_STRIKE),
        earthCost = cache:Get(ABILITY_EARTH_SHOCK),
        frostCost = cache:Get(ABILITY_FROST_SHOCK),
        flameCost = cache:Get(ABILITY_FLAME_SHOCK)
    }
    return setmetatable(context, ShamanModuleRunContext)
end

--- @param cache ManaCostCache
function ShamanModuleRunContext.PreheatCache(cache)
    --- Cancel Clearcasting
    if Helpers:HasBuff("player", "Spell_Nature_Lightning") then
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
