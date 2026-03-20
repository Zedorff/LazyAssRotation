--- @class HeroicStrikeProtModule : HeroicStrikeBase
--- @diagnostic disable: duplicate-set-field
HeroicStrikeProtModule = setmetatable({}, { __index = HeroicStrikeBase })
HeroicStrikeProtModule.__index = HeroicStrikeProtModule

--- @return HeroicStrikeProtModule
function HeroicStrikeProtModule.new()
    --- @class HeroicStrikeProtModule
    return setmetatable(HeroicStrikeBase.new(), HeroicStrikeProtModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function HeroicStrikeProtModule:getSpecPriority(context)
    -- if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.7 then
    --     return -1
    -- end

    local btAlmostReady = Helpers:SpellAlmostReady(Abilities.Bloodthirst.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name)
    local ssAlmostReady = Helpers:SpellAlmostReady(Abilities.ShieldSlam.name, 1.5) and ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name)

    local mainCost = ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name) and context.shieldSlamCost or context.bsCost

    local btCD = Helpers:SpellNotReadyFor(Abilities.Bloodthirst.name)
    local ssCD = Helpers:SpellNotReadyFor(Abilities.ShieldSlam.name)
    local mhSpeed = self.trackers.autoAttackTracker:GetMainHandAttackSpeed()
    local skipHSReserve = (ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name) and (btCD > mhSpeed))
        or (ModuleRegistry:IsModuleEnabled(Abilities.ShieldSlam.name) and (ssCD > mhSpeed))
    local requiredRage = (skipHSReserve and mainCost) or (mainCost + context.hsCost)
    local canAffordMainAndHS = context.rage >= requiredRage
    local rageThreshold = context.rage >= 45

    if (not (ssAlmostReady or btAlmostReady) and canAffordMainAndHS) or rageThreshold then
        return 70
    end

    return -1
end
