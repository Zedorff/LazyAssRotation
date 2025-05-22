--- @class MortalStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
MortalStrikeModule = setmetatable({}, { __index = Module })
MortalStrikeModule.__index = MortalStrikeModule


function MortalStrikeModule.new()
    return setmetatable(Module.new(ABILITY_MORTAL_STRIKE), MortalStrikeModule)
end

function MortalStrikeModule:run()
    Logging:Debug("Casting Mortal Strike")
    CastSpellByName(ABILITY_MORTAL_STRIKE)
end

function MortalStrikeModule:getPriority()
    if self.enabled then
        local rage = UnitMana("player");
        local msCost = Helpers:RageCost(ABILITY_MORTAL_STRIKE)
        if Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= msCost then
            return 90;
        else
            return -1;
        end
    else
        return -1;
    end
end
