--- @class HolyStrikeModule : Module
--- @diagnostic disable: duplicate-set-field
HolyStrikeModule = setmetatable({}, { __index = Module })
HolyStrikeModule.__index = HolyStrikeModule

--- @return HolyStrikeModule
function HolyStrikeModule.new()
    --- @class HolyStrikeModule
    return setmetatable(Module.new(ABILITY_HOLY_STRIKE), HolyStrikeModule)
end

function HolyStrikeModule:run()
    Logging:Debug("Casting "..ABILITY_HOLY_STRIKE)
    CastSpellByName(ABILITY_HOLY_STRIKE)
end

--- @param context PaladinModuleRunContext
function HolyStrikeModule:getPriority(context)
    if self.enabled and context.mana > context.holyStrikeCost and Helpers:SpellReady(ABILITY_HOLY_STRIKE) then
        return 50;
    end
    return -1;
end
