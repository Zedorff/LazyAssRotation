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
    return setmetatable(Module.new(Abilities.Slam.name, trackers, "Interface\\Icons\\Ability_Warrior_DecisiveStrike_New"), SlamModule)
end

function SlamModule:run()
    Logging:Debug("Casting "..Abilities.Slam.name)
    CastSpellByName(Abilities.Slam.name)
end

--- @param context WarriorModuleRunContext
function SlamModule:getPriority(context)
    if self.enabled then
        local slamCastTime = Helpers:CastTime(Abilities.Slam.name)
        local nextSwing = self.trackers.autoAttackTracker:GetNextSwingTime()
        if (nextSwing > slamCastTime) and Helpers:SpellReady(Abilities.Slam.name) and context.rage >= context.slamCost then
            return 100;
        else
            return -1;
        end
    else
        return -1;
    end
end
