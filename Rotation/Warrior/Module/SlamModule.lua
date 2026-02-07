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
        autoAttackTracker = AutoAttackTracker.GetInstance()
    }
    --- @class SlamModule
    return setmetatable(
        Module.new(Abilities.Slam.name, trackers, "Interface\\Icons\\Ability_Warrior_DecisiveStrike_New"), SlamModule)
end

function SlamModule:run()
    Logging:Debug("Casting " .. Abilities.Slam.name)
    CastSpellByName(Abilities.Slam.name)
end

--- @param context WarriorModuleRunContext
function SlamModule:getPriority(context)
    if not self.enabled then
        return -1
    end

    local slamReady = Helpers:SpellReady(Abilities.Slam.name)
    local slamCastTime = Helpers:CastTime(Abilities.Slam.name)
    local nextSwing = self.trackers.autoAttackTracker:GetNextSwingTime() + 1.0
    if nextSwing < slamCastTime then
        return -1
    end

    if slamReady then
        return 65
    end
    return -1
end
