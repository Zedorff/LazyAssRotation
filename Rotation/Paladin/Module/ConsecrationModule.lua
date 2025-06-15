--- @class ConsecrationModule : Module
--- @diagnostic disable: duplicate-set-field
ConsecrationModule = setmetatable({}, { __index = Module })
ConsecrationModule.__index = ConsecrationModule

--- @return ConsecrationModule
function ConsecrationModule.new()
    --- @class ConsecrationModule
    return setmetatable(Module.new(Abilities.Consecration.name, nil, "Interface\\Icons\\Spell_Holy_InnerFire"), ConsecrationModule)
end

function ConsecrationModule:run()
    Logging:Debug("Casting "..Abilities.Consecration.name)
    CastSpellByName(Abilities.Consecration.name)
end

--- @param context PaladinModuleRunContext
function ConsecrationModule:getPriority(context)
    if self.enabled and context.remainingManaPercents > 50 and Helpers:SpellReady(Abilities.Consecration.name) then
        return 40;
    end
    return -1;
end
