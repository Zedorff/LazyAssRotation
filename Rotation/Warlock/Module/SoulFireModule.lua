--- @class SoulFireModule : Module
--- @diagnostic disable: duplicate-set-field
SoulFireModule = setmetatable({}, { __index = Module })
SoulFireModule.__index = SoulFireModule

--- @return ImmolateModule
function SoulFireModule.new()
    --- @class ImmolateModule
    return setmetatable(Module.new(ABILITY_SOUL_FIRE, nil, "Interface\\Icons\\Spell_Fire_Fireball02"), SoulFireModule)
end

function SoulFireModule:run()
    Logging:Debug("Casting "..ABILITY_SOUL_FIRE)
    CastSpellByName(ABILITY_SOUL_FIRE)
end

--- @param context WarlockModuleRunContext
function SoulFireModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_SOUL_FIRE) and context.mana > context.sfCost then
        return 90;
    end
    return -1;
end
