--- @alias RankedAbility { name: string, ids: integer[] }

Abilities = {}

-- Warrior Abilities

--- @type RankedAbility
Abilities.BattleShout = { name = ABILITY_BATTLE_SHOUT, ids = {} }

--- @type RankedAbility
Abilities.Slam = { name = ABILITY_SLAM, ids = {} }

--- @type RankedAbility
Abilities.MortalStrike = { name = ABILITY_MORTAL_STRIKE, ids = {} }

--- @type RankedAbility
Abilities.HeroicStrike = { name = ABILITY_HEROIC_STRIKE, ids = {} }

--- @type RankedAbility
Abilities.Rend = { name = ABILITY_REND, ids = { 11574, 11573, 11572, 6548, 6547, 6546, 772 } }

--- @type RankedAbility
Abilities.Overpower = { name = ABILITY_OVERPOWER, ids = {} }

--- @type RankedAbility
Abilities.Whirlwind = { name = ABILITY_WHIRLWIND, ids = {} }

--- @type RankedAbility
Abilities.Execute = { name = ABILITY_EXECUTE, ids = {} }

--- @type RankedAbility
Abilities.Bloodthirst = { name = ABILITY_BLOODTHIRST, ids = {} }

--- @type RankedAbility
Abilities.Hamstring = { name = ABILITY_HAMSTRING, ids = {} }

--- @type RankedAbility
Abilities.Revenge = { name = ABILITY_REVENGE, ids = {} }

--- @type RankedAbility
Abilities.ShieldSlam = { name = ABILITY_SHIELD_SLAM, ids = {} }

--- @type RankedAbility
Abilities.SunderArmor = { name = ABILITY_SUNDER_ARMOR, ids = {} }

--- @type RankedAbility
Abilities.ShieldBlock = { name = ABILITY_SHIELD_BLOCK, ids = {} }

--- @type RankedAbility
Abilities.Pummel = { name = ABILITY_PUMMEL, ids = {} }

-- Shaman Abilities

--- @type RankedAbility
Abilities.LightningShield = { name = ABILITY_LIGHTNING_SHIELD, ids = {} }

--- @type RankedAbility
Abilities.WaterShield = { name = ABILITY_WATER_SHIELD, ids = {} }

--- @type RankedAbility
Abilities.Stormstrike = { name = ABILITY_STORMSTRIKE, ids = {} }

--- @type RankedAbility
Abilities.LightningStrike = { name = ABILITY_LIGHTNING_STRIKE, ids = {} }

--- @type RankedAbility
Abilities.EarthShock = { name = ABILITY_EARTH_SHOCK, ids = {} }

--- @type RankedAbility
Abilities.FlameShock = { name = ABILITY_FLAME_SHOCK, ids = {} }

--- @type RankedAbility
Abilities.FrostShock = { name = ABILITY_FROST_SHOCK, ids = {} }

--- @type RankedAbility
Abilities.Windfury = { name = ABILITY_WINDFURY, ids = {} }

--- @type RankedAbility
Abilities.Rockbiter = { name = ABILITY_ROCKBITER, ids = {} }

--- @type RankedAbility
Abilities.LightningBolt = { name = ABILITY_LIGHTNING_BOLT, ids = {} }

--- @type RankedAbility
Abilities.ChainLightning = { name = ABILITY_CHAIN_LIGHTNING, ids = {} }

-- Paladin Abilities

--- @type RankedAbility
Abilities.Consecration = { name = ABILITY_CONSECRATION, ids = {} }

--- @type RankedAbility
Abilities.CrusaderStrike = { name = ABILITY_CRUSADER_STRIKE, ids = {} }

--- @type RankedAbility
Abilities.Exorcism = { name = ABILITY_EXORCISM, ids = {} }

--- @type RankedAbility
Abilities.HolyStrike = { name = ABILITY_HOLY_STRIKE, ids = {} }

--- @type RankedAbility
Abilities.Judgement = { name = ABILITY_JUDGEMENT, ids = {} }

--- @type RankedAbility
Abilities.Repentance = { name = ABILITY_REPENTANCE, ids = {} }

--- @type RankedAbility
Abilities.SealCommand = { name = ABILITY_SEAL_COMMAND, ids = {} }

--- @type RankedAbility
Abilities.SealCrusader = { name = ABILITY_SEAL_CRUSADER, ids = {} }

--- @type RankedAbility
Abilities.SealRighteousness = { name = ABILITY_SEAL_RIGHTEOUSNESS, ids = {} }

--- @type RankedAbility
Abilities.SealWisdom = { name = ABILITY_SEAL_WISDOM, ids = {} }

--- @type RankedAbility
Abilities.HolyShield = { name = ABILITY_HOLY_SHIELD, ids = {} }

--- @type RankedAbility
Abilities.RighteousFury = { name = ABILITY_RIGHTEOUS_FURY, ids = {} }

-- Druid Abilities

--- @type RankedAbility
Abilities.TigersFury = { name = ABILITY_TIGER_FURY, ids = {} }

--- @type RankedAbility
Abilities.Shred = { name = ABILITY_SHRED, ids = {} }

--- @type RankedAbility
Abilities.Rip = { name = ABILITY_RIP, ids = { 9896, 9894, 9752, 9493, 9492, 1079 } }

--- @type RankedAbility
Abilities.Rake = { name = ABILITY_RAKE, ids = { 9904, 1824, 1823, 1822 } }

--- @type RankedAbility
Abilities.Claw = { name = ABILITY_CLAW, ids = {} }

--- @type RankedAbility
Abilities.FerociousBite = { name = ABILITY_FEROCIOUS_BITE, ids = {} }

--- @type RankedAbility
Abilities.CatForm = { name = ABILITY_CAT_FORM, ids = {} }

--- @type RankedAbility
Abilities.Maul = { name = ABILITY_MAUL, ids = {} }

--- @type RankedAbility
Abilities.Swipe = { name = ABILITY_SWIPE, ids = {} }

--- @type RankedAbility
Abilities.SavageBite = { name = ABILITY_SAVAGE_BITE, ids = {} }

--- @type RankedAbility
Abilities.InsectSwarm = { name = ABILITY_INSECT_SWARM, ids = { 24977, 24976, 24975, 24974, 5570 } }

--- @type RankedAbility
Abilities.Moonfire = { name = ABILITY_MOONFIRE, ids = { 9835, 9834, 9833, 8929, 8928, 8927, 8926, 8925, 8924, 8921 } }

--- @type RankedAbility
Abilities.Starfire = { name = ABILITY_STARFIRE, ids = { 25298, 9876, 9875, 8951, 8950, 8949, 2912 } }

--- @type RankedAbility
Abilities.Wrath = { name = ABILITY_WRATH, ids = { 9912, 8905, 6780, 5180, 5179, 5178, 5177, 5176 } }

-- Mage Abilities

--- @type RankedAbility
Abilities.ArcaneSurge = { name = ABILITY_ARCANE_SURGE, ids = {} }

--- @type RankedAbility
Abilities.ArcaneRupture = { name = ABILITY_ARCANE_RUPTURE, ids = {} }

--- @type RankedAbility
Abilities.ArcaneMissiles = { name = ABILITY_ARCANE_MISSILES, ids = {} }

--- @type RankedAbility
Abilities.ArcanePower = { name = ABILITY_ARCANE_POWER, ids = {} }

-- Warlock Abilities

--- @type RankedAbility
Abilities.SearingPain = { name = ABILITY_SEARING_PAIN, ids = {} }

--- @type RankedAbility
Abilities.Immolate = { name = ABILITY_IMMOLATE, ids = { 25309, 11668, 11667, 11665, 2941, 1094, 707, 348 } }

--- @type RankedAbility
Abilities.Conflagrate = { name = ABILITY_CONFLAGRATE, ids = { 18932, 18931, 18930, 17962 } }

--- @type RankedAbility
Abilities.SoulFire = { name = ABILITY_SOUL_FIRE, ids = {} }

--- @type RankedAbility
Abilities.LifeTap = { name = ABILITY_LIFE_TAP, ids = {} }

--- @type RankedAbility
Abilities.CoA = { name = ABILITY_COA, ids = { 11713, 11712, 11711, 6217, 1014, 980 } }

--- @type RankedAbility
Abilities.CoR = { name = ABILITY_COR, ids = { 11717, 7659, 7658, 704 } }

--- @type RankedAbility
Abilities.CoE = { name = ABILITY_COE, ids = { 11722, 11721, 1490 } }

--- @type RankedAbility
Abilities.CoS = { name = ABILITY_COS, ids = { 17937, 17862 } }

--- @type RankedAbility
Abilities.CoW = { name = ABILITY_COW, ids = { 702 } }

--- @type RankedAbility
Abilities.DarkHarvest = { name = ABILITY_DARK_HARVEST, ids = { 52550 } }

--- @type RankedAbility
Abilities.Corruption = { name = ABILITY_CORRUPTION, ids = { 25311, 11672, 11671, 7648, 6223, 6222, 172 } }

--- @type RankedAbility
Abilities.SiphonLife = { name = ABILITY_SIPHON_LIFE, ids = { 18881 } }

--- @type RankedAbility
Abilities.DrainSoul = { name = ABILITY_DRAIN_SOUL, ids = {} }

--- @type RankedAbility
Abilities.ShadowBolt = { name = ABILITY_SHADOW_BOLT, ids = {} }


-- Helpers

--- @param ability RankedAbility
--- @param spellId integer
--- @return boolean
function IsMatchingRank(ability, spellId)
    for _, id in ipairs(ability.ids) do
        if id == spellId then return true end
    end
    return false
end