--- @class RepentanceModule : Module
--- @diagnostic disable: duplicate-set-field
RepentanceModule = setmetatable({}, { __index = Module })
RepentanceModule.__index = RepentanceModule

--- @return RepentanceModule
function RepentanceModule.new()
    --- @class RepentanceModule
    return setmetatable(Module.new(ABILITY_REPENTANCE), RepentanceModule)
end

function RepentanceModule:run()
    Logging:Debug("Casting "..ABILITY_REPENTANCE)
    CastSpellByName(ABILITY_REPENTANCE)
end

--- @param context PaladinModuleRunContext
function RepentanceModule:getPriority(context)
    if self.enabled and context.mana > context.repentanceCost and Helpers:SpellReady(ABILITY_REPENTANCE) then
        return 100;
    end
    return -1;
end
