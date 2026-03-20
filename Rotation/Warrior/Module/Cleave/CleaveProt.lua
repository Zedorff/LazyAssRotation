--- @class CleaveProtModule : CleaveBase
--- @diagnostic disable: duplicate-set-field
CleaveProtModule = setmetatable({}, { __index = CleaveBase })
CleaveProtModule.__index = CleaveProtModule

--- @return CleaveProtModule
function CleaveProtModule.new()
    --- @class CleaveProtModule
    return setmetatable(CleaveBase.new(), CleaveProtModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function CleaveProtModule:getSpecPriority(context)
    if self.trackers.autoAttackTracker:GetNextSwingTime() > 0.7 then
        return -1
    end

    local ssAlmostReady = Helpers:SpellAlmostReady(Abilities.ShieldSlam.name, 1.5)
    local canAffordSSAndCleave = context.rage >= context.shieldSlamCost + context.cleaveCost
    local rageThreshold = context.rage >= 45

    if (not ssAlmostReady and canAffordSSAndCleave) or rageThreshold then
        return 70
    end

    return -1
end
