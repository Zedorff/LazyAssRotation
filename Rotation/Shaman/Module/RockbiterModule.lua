--- @class RockbiterModule : Module
--- @field tracker RockbiterTracker
--- @diagnostic disable: duplicate-set-field
RockbiterModule = setmetatable({}, { __index = Module })
RockbiterModule.__index = RockbiterModule

--- @return RockbiterModule
function RockbiterModule.new()
    --- @class RockbiterModule
    local instance = Module.new(ABILITY_ROCKBITER, false)
    setmetatable(instance, RockbiterModule)

    instance.tracker = RockbiterTracker.new()

    if instance.enabled then
        ModuleRegistry:DisableModule(ABILITY_WINDFURY)
        instance.tracker:subscribe()
    end

    return instance
end

function RockbiterModule:enable()
    ModuleRegistry:DisableModule(ABILITY_WINDFURY)
    Module.enable(self)
    self.tracker:subscribe()
end

function RockbiterModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function RockbiterModule:run()
    Logging:Debug("Casting Rockbiter Weapon")
    CastSpellByName(ABILITY_ROCKBITER)
end

--- @param context ShamanModuleRunContext
function RockbiterModule:getPriority(context)
    if self.enabled then
        if self.tracker:isAvailable() then
            return 100;
        end
    end
    return -1;
end
