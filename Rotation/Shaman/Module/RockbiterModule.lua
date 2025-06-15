--- @alias RockbiterTrackers { rockbiterTracker: RockbiterTracker }
--- @class RockbiterModule : Module
--- @field trackers RockbiterTrackers
--- @diagnostic disable: duplicate-set-field
RockbiterModule = setmetatable({}, { __index = Module })
RockbiterModule.__index = RockbiterModule

--- @return RockbiterModule
function RockbiterModule.new()
    --- @type RockbiterTrackers
    local trackers = {
        rockbiterTracker = RockbiterTracker.new()
    }
    --- @class RockbiterModule
    local self = setmetatable(Module.new(Abilities.Rockbiter.name, trackers, "Interface\\Icons\\Spell_Nature_RockBiter", false), RockbiterModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.Windfury.name)
    end

    return self
end

function RockbiterModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.Windfury.name)
end

function RockbiterModule:run()
    Logging:Debug("Casting "..Abilities.Rockbiter.name)
    CastSpellByName(Abilities.Rockbiter.name)
end

--- @param context ShamanModuleRunContext
function RockbiterModule:getPriority(context)
    if self.enabled then
        if self.trackers.rockbiterTracker:ShouldCast() then
            return 100;
        end
    end
    return -1;
end
