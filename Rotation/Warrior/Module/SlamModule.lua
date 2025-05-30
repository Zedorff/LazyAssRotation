--- @alias SlamTrackers { autoAttackTracker: AutoAttackTracker }
--- @class SlamModule : Module
--- @field trackers SlamTrackers
--- @diagnostic disable: duplicate-set-field
SlamModule = setmetatable({}, { __index = Module })
SlamModule.__index = SlamModule

--- @return SlamModule
function SlamModule.new()
    --- @type SlamTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.new()
    }
    --- @class SlamModule
    return setmetatable(Module.new(ABILITY_SLAM, trackers, "Interface\\Icons\\Ability_Warrior_DecisiveStrike_New"), SlamModule)
end

function SlamModule:run()
    Logging:Debug("Casting Slam")
    CastSpellByName(ABILITY_SLAM)
end

--- @param context WarriorModuleRunContext
function SlamModule:getPriority(context)
    if self.enabled then
        local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
        local nextSwing = self.trackers.autoAttackTracker:GetNextSwingTime()
        if (nextSwing > slamCastTime) and Helpers:SpellReady(ABILITY_SLAM) and context.rage >= context.slamCost then
            return 100;
        else
            return -1;
        end
    else
        return -1;
    end
end
