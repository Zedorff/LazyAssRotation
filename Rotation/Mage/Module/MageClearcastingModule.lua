--- @alias MageClearcastingTrackers { channelingTracker: ChannelingTracker, clearcastingTracker: ClearcastingTracker }
--- @class MageClearcastingModule : Module
--- @field trackers MageClearcastingTrackers
--- @diagnostic disable: duplicate-set-field
MageClearcastingModule = setmetatable({}, { __index = Module })
MageClearcastingModule.__index = MageClearcastingModule

--- @return MageClearcastingModule
function MageClearcastingModule.new()
    --- @type MageClearcastingTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.GetInstance(),
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class MageClearcastingModule
    return setmetatable(Module.new(PASSIVE_CLEARCASTING, trackers, "Interface\\Icons\\Spell_Shadow_ManaBurn"), MageClearcastingModule)
end

function MageClearcastingModule:run()
    Logging:Debug("Casting "..ABILITY_ARCANE_MISSILES)
    CastSpellByName(ABILITY_ARCANE_MISSILES)
end

--- @param context MageModuleRunContext
function MageClearcastingModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        if self.trackers.clearcastingTracker:ShouldCast() then
            return 100;
        end
    end
    return -1;
end
