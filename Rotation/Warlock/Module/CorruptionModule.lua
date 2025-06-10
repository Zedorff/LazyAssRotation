--- @alias CorruptionTrackers { corruptionTracker: CorruptionTracker, channelingTracker: ChannelingTracker, coaTracker: CurseOfAgonyTracker }
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
        channelingTracker = ChannelingTracker.GetInstance(),
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
        and Helpers:SpellReady(ABILITY_SIPHON_LIFE) --- GCD check, corruption can't be used for this
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana > context.corruptionCost)
    then
        return -1
    end

    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    if Helpers:SpellAlmostReady(ABILITY_DARK_HARVEST, 2)
        and agonyRemaining >= 13
        and corrRemaining  <  10
    then
        return 100
    end

    if self.trackers.corruptionTracker:ShouldCast() or self.trackers.corruptionTracker:GetRemainingDuration() <= 3 then
        return 80
    end
    return -1
end
