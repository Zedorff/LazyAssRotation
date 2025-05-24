--- @class ConsecrationModule : Module
--- @diagnostic disable: duplicate-set-field
ConsecrationModule = setmetatable({}, { __index = Module })
ConsecrationModule.__index = ConsecrationModule

--- @return ConsecrationModule
function ConsecrationModule.new()
    --- @class ConsecrationModule
    return setmetatable(Module.new(ABILITY_CONSECRATION), ConsecrationModule)
end

function ConsecrationModule:run()
    Logging:Debug("Casting "..ABILITY_CONSECRATION)
    CastSpellByName(ABILITY_CONSECRATION)
end

--- @param context PaladinModuleRunContext
function ConsecrationModule:getPriority(context)
    if self.enabled and context.remainingManaPercents > 40 and Helpers:SpellReady(ABILITY_CONSECRATION) then
        return 40;
    end
    return -1;
end
