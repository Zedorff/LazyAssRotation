--- @class RepentanceModule : Module
--- @diagnostic disable: duplicate-set-field
RepentanceModule = setmetatable({}, { __index = Module })
RepentanceModule.__index = RepentanceModule

--- @return RepentanceModule
function RepentanceModule.new()
    --- @class RepentanceModule
    return setmetatable(Module.new(Abilities.Repentance.name, nil, "Interface\\Icons\\Spell_Holy_PrayerOfHealing"), RepentanceModule)
end

function RepentanceModule:run()
    Logging:Debug("Casting "..Abilities.Repentance.name)
    CastSpellByName(Abilities.Repentance.name)
end

--- @param context PaladinModuleRunContext
function RepentanceModule:getPriority(context)
    if self.enabled and context.mana > context.repentanceCost and Helpers:SpellReady(Abilities.Repentance.name) then
        return 100;
    end
    return -1;
end
