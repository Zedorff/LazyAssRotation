--- @class WindfuryModule : Module
--- @field tracker WindfuryTracker
--- @diagnostic disable: duplicate-set-field
WindfuryModule = setmetatable({}, { __index = Module })
WindfuryModule.__index = WindfuryModule

--- @return WindfuryModule
function WindfuryModule.new()
    --- @class WindfuryModule
    local instance = Module.new(ABILITY_WINDFURY)
    setmetatable(instance, WindfuryModule)

    instance.tracker = WindfuryTracker.new()

    if instance.enabled then
        ModuleRegistry:DisableModule(ABILITY_ROCKBITER)
        instance.tracker:subscribe()
    end

    return instance
end

function WindfuryModule:enable()
    ModuleRegistry:DisableModule(ABILITY_ROCKBITER)
    Module.enable(self)
    self.tracker:subscribe()
end

function WindfuryModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function WindfuryModule:run()
    Logging:Debug("Casting Windfury Weapon")
    CastSpellByName(ABILITY_WINDFURY)
end

--- @param context ShamanModuleRunContext
function WindfuryModule:getPriority(context)
    if self.enabled then
        if self.tracker:isAvailable() then
            return 100;
        end
    end
    return -1;
end
