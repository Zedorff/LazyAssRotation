--- @class ExcorcismModule : Module
--- @diagnostic disable: duplicate-set-field
ExcorcismModule = setmetatable({}, { __index = Module })
ExcorcismModule.__index = ExcorcismModule

--- @return ExcorcismModule
function ExcorcismModule.new()
    --- @class ExcorcismModule
    return setmetatable(Module.new(ABILITY_EXORCISM), ExcorcismModule)
end

function ExcorcismModule:run()
    Logging:Debug("Casting "..ABILITY_EXORCISM)
    CastSpellByName(ABILITY_EXORCISM)
end

--- @param context PaladinModuleRunContext
function ExcorcismModule:getPriority(context)
    if self.enabled and context.mana > context.exorcismCost and Helpers:SpellReady(ABILITY_EXORCISM) then
        return 20;
    end
    return -1;
end
