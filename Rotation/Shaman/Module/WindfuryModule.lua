--- @alias WindfuryTrackers { wfTracker: WindfuryTracker }
--- @class WindfuryModule : Module
--- @field trackers WindfuryTrackers
--- @diagnostic disable: duplicate-set-field
WindfuryModule = setmetatable({}, { __index = Module })
WindfuryModule.__index = WindfuryModule

--- @return WindfuryModule
function WindfuryModule.new()
    --- @type WindfuryTrackers
    local trackers = {
        wfTracker = WindfuryTracker.new()
    }
    --- @class WindfuryModule
    local self = setmetatable(Module.new(ABILITY_WINDFURY, trackers, "Interface\\Icons\\Spell_Nature_Cyclone"), WindfuryModule)

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_ROCKBITER)
    end

    return self
end

function WindfuryModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_ROCKBITER)
end

function WindfuryModule:run()
    Logging:Debug("Casting Windfury Weapon")
    CastSpellByName(ABILITY_WINDFURY)
end

--- @param context ShamanModuleRunContext
function WindfuryModule:getPriority(context)
    if self.enabled then
        if self.trackers.wfTracker:ShouldCast() then
            return 100;
        end
    end
    return -1;
end
