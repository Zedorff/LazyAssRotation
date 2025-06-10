--- @alias DarkHarvestTrackers { channelingTracker: ChannelingTracker, siphonLifeTracker: SiphonLifeTracker, coaTracker: CurseOfAgonyTracker, corruptionTracker: CorruptionTracker }
--- @class DarkHarvestModule : Module
--- @field trackers DarkHarvestTrackers
--- @diagnostic disable: duplicate-set-field
DarkHarvestModule = setmetatable({}, { __index = Module })
DarkHarvestModule.__index = DarkHarvestModule

--- @return DarkHarvestModule
function DarkHarvestModule.new()
    --- @type DarkHarvestTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.new(),
        coaTracker = CurseOfAgonyTracker.new(true),
        corruptionTracker = CorruptionTracker.new(),
        siphonLifeTracker = SiphonLifeTracker.new()
    }
    --- @class DarkHarvestModule
    return setmetatable(Module.new(ABILITY_DARK_HARVEST, trackers, "Interface\\Icons\\Spell_Shadow_SoulLeech"), DarkHarvestModule)
end

function DarkHarvestModule:run()
    Logging:Debug("Casting "..ABILITY_DARK_HARVEST)
    CastSpellByName(ABILITY_DARK_HARVEST)
end

--- @param context WarlockModuleRunContext
function DarkHarvestModule:getPriority(context)
    if not (self.enabled
        and Helpers:SpellReady(ABILITY_DARK_HARVEST)
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana >= context.darkHarvestCost)
    then
        return -1
    end

    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local siphRemaining  = self.trackers.siphonLifeTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    if corrRemaining >= 10 and siphRemaining >= 10 and agonyRemaining >= 10 then
        return 50
    end
    return -1
end
