--- @class ExcorcismModule : Module
--- @diagnostic disable: duplicate-set-field
ExcorcismModule = setmetatable({}, { __index = Module })
ExcorcismModule.__index = ExcorcismModule

--- @return ExcorcismModule
function ExcorcismModule.new()
    --- @class ExcorcismModule
    return setmetatable(Module.new(Abilities.Exorcism.name, nil, "Interface\\Icons\\Spell_Holy_Excorcism"), ExcorcismModule)
end

function ExcorcismModule:run()
    Logging:Debug("Casting "..Abilities.Exorcism.name)
    CastSpellByName(ABILITY_Abilities.Exorcism.nameEXORCISM)
end

--- @param context PaladinModuleRunContext
function ExcorcismModule:getPriority(context)
    local targetCreatureType = UnitCreatureType("target")
    if self.enabled and context.mana > context.exorcismCost and Helpers:SpellReady(Abilities.Exorcism.name) and (targetCreatureType == "Undead" or targetCreatureType == "Demon") then
        return 20;
    end
    return -1;
end
