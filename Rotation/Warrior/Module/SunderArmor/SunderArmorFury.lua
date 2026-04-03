--- @class SunderArmorFuryModule : SunderArmorBase
--- @diagnostic disable: duplicate-set-field
SunderArmorFuryModule = setmetatable({}, { __index = SunderArmorBase })
SunderArmorFuryModule.__index = SunderArmorFuryModule

--- @return SunderArmorFuryModule
function SunderArmorFuryModule.new()
    --- @class SunderArmorFuryModule
    return setmetatable(SunderArmorBase.new(), SunderArmorFuryModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function SunderArmorFuryModule:getSpecPriority(context)
    if context.stance ~= 2 then
        if Helpers:SpellReady(Abilities.SunderArmor.name) and context.rage >= 75 then
            return 10
        else
            return -1
        end
    end
    return -1
end
