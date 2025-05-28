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
    return setmetatable(Module.new(ABILITY_RAKE, trackers), RakeModule)
end

function RakeModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(MODULE_POWERSHIFTING)
    ModuleRegistry:EnableModule(ABILITY_RIP)
    ModuleRegistry:EnableModule(ABILITY_CLAW)
    ModuleRegistry:EnableModule(ABILITY_TIGER_FURY)
end

function RakeModule:run()
    Logging:Debug("Casting "..ABILITY_RAKE)
    CastSpellByName(ABILITY_RAKE)
end

--- @param context DruidModuleRunContext
function RakeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_RAKE) then
        if self.trackers.rakeTracker:ShouldCast() and context.energy > context.rakeCost then
            return 95;
        end
    end
    return -1;
end
