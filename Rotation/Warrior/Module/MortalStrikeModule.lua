--- @class MortalStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
MortalStrikeModule = setmetatable({}, { __index = Module })
MortalStrikeModule.__index = MortalStrikeModule

--- @return MortalStrikeModule 
function MortalStrikeModule.new()
    --- @class MortalStrikeModule
    return setmetatable(Module.new(ABILITY_MORTAL_STRIKE, nil, "Interface\\Icons\\Ability_Warrior_SavageBlow"), MortalStrikeModule)
end

function MortalStrikeModule:run()
    Logging:Debug("Casting Mortal Strike")
    CastSpellByName(ABILITY_MORTAL_STRIKE)
end


--- @param context WarriorModuleRunContext
function MortalStrikeModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and context.rage >= context.msCost then
            return 80;
        else
            return -1;
        end
    else
        return -1;
    end
end
