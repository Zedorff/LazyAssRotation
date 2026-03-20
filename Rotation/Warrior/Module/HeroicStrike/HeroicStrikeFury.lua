--- @class HeroicStrikeFuryModule : HeroicStrikeBase
--- @diagnostic disable: duplicate-set-field
HeroicStrikeFuryModule = setmetatable({}, { __index = HeroicStrikeBase })
HeroicStrikeFuryModule.__index = HeroicStrikeFuryModule

--- @return HeroicStrikeFuryModule
function HeroicStrikeFuryModule.new()
    --- @class HeroicStrikeFuryModule
    return setmetatable(HeroicStrikeBase.new(), HeroicStrikeFuryModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function HeroicStrikeFuryModule:getSpecPriority(context)
    if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.6 then
        return -1
    end

    local btCD      = Helpers:SpellNotReadyFor(Abilities.Bloodthirst.name)
    local wwCD      = Helpers:SpellNotReadyFor(Abilities.Whirlwind.name)
    local GCD = 1.5
    local btReady   = btCD <= GCD and ModuleRegistry:IsModuleEnabled(Abilities.Bloodthirst.name)
    local wwReady   = wwCD <= GCD and ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name)
    local bothSoon  = btReady and wwReady and math.abs(btCD - wwCD) < GCD

    local reserve   = 0
    if bothSoon then
        reserve = context.bsCost + context.wwCost
    elseif btReady then
        reserve = context.bsCost
    elseif wwReady then
        reserve = context.wwCost
    end

    if context.rage >= (reserve + context.hsCost) then
        return 65
    end

    return -1
end
