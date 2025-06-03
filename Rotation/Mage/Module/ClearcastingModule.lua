--- @alias ClearcastingTrackers { channelingTracker: ChannelingTracker, clearcastingTracker: ClearcastingTracker }
--- @class ClearcastingModule : Module
--- @field trackers ClearcastingTrackers
--- @diagnostic disable: duplicate-set-field
ClearcastingModule = setmetatable({}, { __index = Module })
ClearcastingModule.__index = ClearcastingModule

--- @return ClearcastingModule
function ClearcastingModule.new()
    --- @type ArcaneMissilesTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.new(),
        clearcastingTracker = ClearcastingTracker.new()
    }
    --- @class ClearcastingModule
    return setmetatable(Module.new(PASSIVE_CLEARCASTING, trackers, "Interface\\Icons\\Spell_Shadow_ManaBurn"), ClearcastingModule)
end

function ClearcastingModule:run()
    Logging:Debug("Casting "..ABILITY_ARCANE_MISSILES)
    CastSpellByName(ABILITY_ARCANE_MISSILES)
end

--- @param context MageModuleRunContext
function ClearcastingModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        if self.trackers.clearcastingTracker:ShouldCast() then
            return 100;
        end
    end
    return -1;
end
