--- @class MortalStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
MortalStrikeModule = setmetatable({}, { __index = Module })
MortalStrikeModule.__index = MortalStrikeModule

--- @return MortalStrikeModule 
function MortalStrikeModule.new()
    --- @class MortalStrikeModule
    return setmetatable(Module.new(Abilities.MortalStrike.name, nil, "Interface\\Icons\\Ability_Warrior_SavageBlow"), MortalStrikeModule)
end

function MortalStrikeModule:run()
    Logging:Debug("Casting "..Abilities.MortalStrike.name)
    CastSpellByName(Abilities.MortalStrike.name)
end


--- @param context WarriorModuleRunContext
function MortalStrikeModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(Abilities.MortalStrike.name) and context.rage >= context.msCost then
            return 80;
        else
            return -1;
        end
    else
        return -1;
    end
end
