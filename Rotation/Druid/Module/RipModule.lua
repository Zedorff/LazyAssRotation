--- @alias RipTrackers { ripTracker: RipTracker }
--- @class RipModule : Module
--- @field trackers RipTrackers
--- @diagnostic disable: duplicate-set-field
RipModule = setmetatable({}, { __index = Module })
RipModule.__index = RipModule

--- @return RipModule
function RipModule.new()
    --- @type RipTrackers
    local trackers = {
        ripTracker = RipTracker.new()
    }
    --- @class RipModule
    return setmetatable(Module.new(Abilities.Rip.name, trackers, "Interface\\Icons\\Ability_GhoulFrenzy"), RipModule)
end

function RipModule:run()
    Logging:Debug("Casting "..Abilities.Rip.name)
    CastSpellByName(Abilities.Rip.name)
end

--- @param context DruidModuleRunContext
function RipModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Rip.name) then
        if self.trackers.ripTracker:ShouldCast() and context.cp >= 1 then
            return 94;
        end
    end
    return -1;
end
