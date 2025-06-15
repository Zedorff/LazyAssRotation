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
    local self = setmetatable(Module.new(Abilities.Windfury.name, trackers, "Interface\\Icons\\Spell_Nature_Cyclone"), WindfuryModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.Rockbiter.name)
    end

    return self
end

function WindfuryModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.Rockbiter.name)
end

function WindfuryModule:run()
    Logging:Debug("Casting "..Abilities.Windfury.name)
    CastSpellByName(Abilities.Windfury.name)
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
