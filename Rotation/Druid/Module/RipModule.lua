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
    return setmetatable(Module.new(ABILITY_RIP, trackers), RipModule)
end

function RipModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(MODULE_POWERSHIFTING)
    ModuleRegistry:EnableModule(ABILITY_RAKE)
    ModuleRegistry:EnableModule(ABILITY_CLAW)
    ModuleRegistry:EnableModule(ABILITY_TIGER_FURY)
end

function RipModule:run()
    Logging:Debug("Casting "..ABILITY_RIP)
    CastSpellByName(ABILITY_RIP)
end

--- @param context DruidModuleRunContext
function RipModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_RIP) then
        if self.trackers.ripTracker:ShouldCast() and context.cp >= 1 then
            return 94;
        end
    end
    return -1;
end
