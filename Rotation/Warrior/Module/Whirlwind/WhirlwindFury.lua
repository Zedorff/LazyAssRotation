--- @class WhirlwindFuryModule : WhirlwindBase
--- @diagnostic disable: duplicate-set-field
WhirlwindFuryModule = setmetatable({}, { __index = WhirlwindBase })
WhirlwindFuryModule.__index = WhirlwindFuryModule

--- @return WhirlwindFuryModule
function WhirlwindFuryModule.new()
    --- @class WhirlwindFuryModule
    return setmetatable(WhirlwindBase.new(), WhirlwindFuryModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function WhirlwindFuryModule:getSpecPriority(context)
    if Helpers:SpellReady(Abilities.Whirlwind.name) and not Helpers:SpellAlmostReady(Abilities.Bloodthirst.name, 0.5) and context.rage >= context.wwCost then
        if not Helpers:IsInMeleeRange("player", "target") then
            return -1
        end
        return 70
    end
    return -1
end
