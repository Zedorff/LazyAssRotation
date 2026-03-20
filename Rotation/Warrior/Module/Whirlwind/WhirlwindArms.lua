--- @class WhirlwindArmsModule : WhirlwindBase
--- @diagnostic disable: duplicate-set-field
WhirlwindArmsModule = setmetatable({}, { __index = WhirlwindBase })
WhirlwindArmsModule.__index = WhirlwindArmsModule

--- @return WhirlwindArmsModule
function WhirlwindArmsModule.new()
    --- @class WhirlwindArmsModule
    return setmetatable(WhirlwindBase.new(), WhirlwindArmsModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function WhirlwindArmsModule:getSpecPriority(context)
    if Helpers:SpellReady(Abilities.Whirlwind.name) and not Helpers:SpellAlmostReady(Abilities.MortalStrike.name, 0.5) and context.rage >= context.wwCost then
        return 70
    end
    return -1
end
