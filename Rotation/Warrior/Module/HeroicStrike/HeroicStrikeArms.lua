--- @class HeroicStrikeArmsModule : HeroicStrikeBase
--- @diagnostic disable: duplicate-set-field
HeroicStrikeArmsModule = setmetatable({}, { __index = HeroicStrikeBase })
HeroicStrikeArmsModule.__index = HeroicStrikeArmsModule

--- @return HeroicStrikeArmsModule
function HeroicStrikeArmsModule.new()
    --- @class HeroicStrikeArmsModule
    return setmetatable(HeroicStrikeBase.new(), HeroicStrikeArmsModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function HeroicStrikeArmsModule:getSpecPriority(context)
    local msCost = ModuleRegistry:IsModuleEnabled(Abilities.MortalStrike.name) and context.msCost or 0
    local bsCost = ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name) and context.bsCost or 0
    local wwCost = ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name) and context.wwCost or 0
    local slamCost = ModuleRegistry:IsModuleEnabled(Abilities.Slam.name) and context.slamCost or 0
    if context.rage >= msCost + bsCost + wwCost + slamCost + context.hsCost then
        return 75
    end
    return -1
end
