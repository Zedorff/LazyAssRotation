--- @class SunderArmorProtModule : SunderArmorBase
--- @diagnostic disable: duplicate-set-field
SunderArmorProtModule = setmetatable({}, { __index = SunderArmorBase })
SunderArmorProtModule.__index = SunderArmorProtModule

--- @return SunderArmorProtModule
function SunderArmorProtModule.new()
    --- @class SunderArmorProtModule
    return setmetatable(SunderArmorBase.new(), SunderArmorProtModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function SunderArmorProtModule:getSpecPriority(context)
    if Helpers:SpellReady(Abilities.SunderArmor.name) and context.rage >= 80 then
        return 50
    end
    return -1
end
