--- @alias RakeTrackers { rakeTracker: RakeTracker }
--- @class RakeModule : Module
--- @field trackers RakeTrackers
--- @diagnostic disable: duplicate-set-field
RakeModule = setmetatable({}, { __index = Module })
RakeModule.__index = RakeModule

--- @return RakeModule
function RakeModule.new()
    --- @type RakeTrackers
    local trackers = {
        rakeTracker = RakeTracker.new()
    }
    --- @class RakeModule
    return setmetatable(Module.new(ABILITY_RAKE, trackers, "Interface\\Icons\\Ability_Druid_Disembowel"), RakeModule)
end

function RakeModule:run()
    Logging:Debug("Casting "..ABILITY_RAKE)
    CastSpellByName(ABILITY_RAKE)
end

--- @param context DruidModuleRunContext
function RakeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_RAKE) then
        if self.trackers.rakeTracker:ShouldCast() then
            return 95;
        end
    end
    return -1;
end
