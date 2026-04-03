--- @class SunderArmorArmsModule : SunderArmorBase
--- @diagnostic disable: duplicate-set-field
SunderArmorArmsModule = setmetatable({}, { __index = SunderArmorBase })
SunderArmorArmsModule.__index = SunderArmorArmsModule

--- @return SunderArmorArmsModule
function SunderArmorArmsModule.new()
    --- @class SunderArmorArmsModule
    return setmetatable(SunderArmorBase.new(), SunderArmorArmsModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function SunderArmorArmsModule:getSpecPriority(context)
    if context.stance ~= 2 then
        if Helpers:SpellReady(Abilities.SunderArmor.name) and context.rage >= 75 then
            return 10
        else
            return -1
        end
    end
    return -1
end
