--- @alias CorruptionTrackers { corruptionTracker: CorruptionTracker, darkHarvestTracker: DarkHarvestTracker, channelingTracker: ChannelingTracker, siphonLifeTracker: SiphonLifeTracker, coaTracker: CurseOfAgonyTracker }
--- @class CorruptionModule : Module
--- @field trackers CorruptionTrackers
--- @diagnostic disable: duplicate-set-field
CorruptionModule = setmetatable({}, { __index = Module })
CorruptionModule.__index = CorruptionModule

--- @param allowAgonyWithOtherCurses boolean
--- @return CorruptionModule
function CorruptionModule.new(allowAgonyWithOtherCurses)
    --- @type CorruptionTrackers
    local trackers = {
        corruptionTracker = CorruptionTracker.GetInstance(),
        darkHarvestTracker = DarkHarvestTracker.new(),
        channelingTracker = ChannelingTracker.GetInstance(),
        siphonLifeTracker = SiphonLifeTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    }
    --- @class CorruptionModule
    local self = Module.new(ABILITY_CORRUPTION, trackers, "Interface\\Icons\\Spell_Shadow_AbominationExplosion")
    setmetatable(self, CorruptionModule)

    return self
end

function CorruptionModule:run()
    Logging:Debug("Casting " .. ABILITY_CORRUPTION)
    _ = SpellStopCasting()
    CastSpellByName(ABILITY_CORRUPTION)
end

--- @param context WarlockModuleRunContext
function CorruptionModule:getPriority(context)
    if not (self.enabled
        and Helpers:SpellReady(ABILITY_CORRUPTION)
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana > context.corruptionCost)
    then
        return -1
    end

    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local siphRemaining  = self.trackers.siphonLifeTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    if Helpers:SpellReady(ABILITY_DARK_HARVEST)
        and agonyRemaining >= 13
        and corrRemaining  <  10
    then
        return 100
    end

    if self.trackers.corruptionTracker:ShouldCast() then
        return 80
    end
    return -1
end
