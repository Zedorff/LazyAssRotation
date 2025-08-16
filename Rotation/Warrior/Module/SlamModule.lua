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
    if self.enabled then
        local slamCastTime = Helpers:CastTime(Abilities.Slam.name)
        local nextSwing = self.trackers.autoAttackTracker:GetNextSwingTime() + 0.2 -- Add a small buffer to account for latency

        if (nextSwing < slamCastTime) then
            return -1;
        end

        local msCD      = Helpers:SpellNotReadyFor(Abilities.MortalStrike.name)
        local wwCD      = Helpers:SpellNotReadyFor(Abilities.Whirlwind.name)

        local awaitTime = 2
        local msReady   = msCD <= awaitTime and ModuleRegistry:IsModuleEnabled(Abilities.MortalStrike.name)
        local wwReady   = wwCD <= awaitTime and ModuleRegistry:IsModuleEnabled(Abilities.Whirlwind.name) and context.stance == 3
        local bothSoon  = msReady and wwReady and math.abs(msCD - wwCD) < awaitTime

        local reserve   = context.slamCost
        if bothSoon then
            reserve = context.msCost + context.wwCost
        elseif msReady then
            reserve = context.msCost
        elseif wwReady then
            reserve = context.wwCost
        end


        if Helpers:SpellReady(Abilities.Slam.name) and context.rage >= reserve then
            return 65;
        end
    end
    return -1;
end
