--- @class FuryWarrior : ClassRotation
--- @diagnostic disable: duplicate-set-field
FuryWarrior = setmetatable({}, { __index = ClassRotation })
FuryWarrior.__index = FuryWarrior

--- @return FuryWarrior
function FuryWarrior:new()
    Logging:Log("Using Fury Warrior rotation")
    return setmetatable({}, self)
end

function FuryWarrior:execute()
    local rage = UnitMana("player");
    local hsCost = Helpers:RageCost(ABILITY_HEROIC_STRIKE)
    local executeCost = Helpers:RageCost(ABILITY_EXECUTE)
    local bsCost = Helpers:RageCost(ABILITY_BLOODTHIRST)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    local shoutCost = Helpers:RageCost(ABILITY_BATTLE_SHOUT)

    if not CheckInteractDistance("target", 3) then
        if not Helpers:HasBuff("player", "Ability_Warrior_BattleShout") and rage >= shoutCost then
            Logging:Debug("Casting Battle Shout")
            CastSpellByName(ABILITY_BATTLE_SHOUT)
        end
        return
    end

    if Helpers:ShouldUseExecute() then
        if rage >= executeCost + hsCost and Helpers:SpellReady(ABILITY_HEROIC_STRIKE) then 
            Logging:Debug("Casting Heroic Strike")
            CastSpellByName(ABILITY_HEROIC_STRIKE)
        end
        Logging:Debug("Casting Execute")
        CastSpellByName(ABILITY_EXECUTE)
    elseif not Helpers:HasBuff("player", "Ability_Warrior_BattleShout") and rage >= shoutCost then
        Logging:Debug("Casting Battle Shout")
        CastSpellByName(ABILITY_BATTLE_SHOUT)
    elseif Helpers:SpellReady(ABILITY_BLOODTHIRST) and rage >= bsCost then
        Logging:Debug("Casting Bloodthirst")
        CastSpellByName(ABILITY_BLOODTHIRST)
    elseif Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_BLOODTHIRST) and rage >= wwCost then
        Logging:Debug("Casting Whirlwind")
        CastSpellByName(ABILITY_WHIRLWIND)
    elseif Helpers:SpellReady(ABILITY_HEROIC_STRIKE) and rage >= bsCost + wwCost then 
        Logging:Debug("Queuing Heroic Strike")
        CastSpellByName(ABILITY_HEROIC_STRIKE)
    elseif Helpers:SpellReady(ABILITY_HAMSTRING) and rage >= 80 then
        Logging:Debug("Casting Hamstring")
        CastSpellByName(ABILITY_HAMSTRING)
    end
end
