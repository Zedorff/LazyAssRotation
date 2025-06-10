--- @alias SiphonLifeTrackers { siphonLifeTracker: SiphonLifeTracker, darkHarvestTracker: DarkHarvestTracker, channelingTracker: ChannelingTracker, corruptionTracker: CorruptionTracker, coaTracker: CurseOfAgonyTracker }
--- @class SiphonLifeModule : Module
--- @field trackers SiphonLifeTrackers
--- @diagnostic disable: duplicate-set-field
SiphonLifeModule = setmetatable({}, { __index = Module })
SiphonLifeModule.__index = SiphonLifeModule

--- @param allowAgonyWithOtherCurses boolean
--- @return SiphonLifeModule
function SiphonLifeModule.new(allowAgonyWithOtherCurses)
    --- @type SiphonLifeTrackers
    local trackers = {
        siphonLifeTracker = SiphonLifeTracker.GetInstance(),
        darkHarvestTracker = DarkHarvestTracker.new(),
        channelingTracker = ChannelingTracker.GetInstance(),
        corruptionTracker = CorruptionTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    }
    --- @class SiphonLifeModule
    local self = Module.new(ABILITY_SIPHON_LIFE, trackers, "Interface\\Icons\\Spell_Shadow_Requiem")
    setmetatable(self, SiphonLifeModule)

    return self
end

function SiphonLifeModule:run()
    _ = SpellStopCasting()
    Logging:Debug("Casting " .. ABILITY_SIPHON_LIFE)
    CastSpellByName(ABILITY_SIPHON_LIFE)
end

--- @param context WarlockModuleRunContext
function SiphonLifeModule:getPriority(context)
    if not (self.enabled
        and Helpers:SpellReady(ABILITY_SIPHON_LIFE)
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana > context.siphonLifeCost)
    then
        return -1
    end

    local siphRemaining  = self.trackers.siphonLifeTracker:GetRemainingDuration()
    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    if Helpers:SpellReady(ABILITY_DARK_HARVEST)
        and agonyRemaining >= 13
        and siphRemaining  <  10
    then
        return 100
    end

    if self.trackers.siphonLifeTracker:ShouldCast() then
        return 70
    end
    return -1
end
