--- @class SearingPainModule : Module
--- @diagnostic disable: duplicate-set-field
SearingPainModule = setmetatable({}, { __index = Module })
SearingPainModule.__index = SearingPainModule

--- @return ImmolateModule
function SearingPainModule.new()
    --- @class ImmolateModule
    return setmetatable(Module.new(Abilities.SearingPain.name, nil, "Interface\\Icons\\Spell_Fire_SoulBurn"), SearingPainModule)
end

function SearingPainModule:run()
    Logging:Debug("Casting "..Abilities.SearingPain.name)
    CastSpellByName(Abilities.SearingPain.name)
end

--- @param context WarlockModuleRunContext
function SearingPainModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.SearingPain.name) and context.mana > context.searingCost then
        return 50;
    end
    return -1;
end
