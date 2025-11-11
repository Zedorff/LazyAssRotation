--- @alias CorruptionTrackers { corruptionTracker: CorruptionTracker, castingTracker: CastingTracker, coaTracker: CurseOfAgonyTracker }
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
        castingTracker = CastingTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    }
    --- @class CorruptionModule
    local self = Module.new(Abilities.Corruption.name, trackers, "Interface\\Icons\\Spell_Shadow_AbominationExplosion")
    setmetatable(self, CorruptionModule)

    return self
end

function CorruptionModule:run()
    Logging:Debug("Casting " .. Abilities.Corruption.name)
    _ = SpellStopCasting()
    CastSpellByName(Abilities.Corruption.name)
end

--- @param context WarlockModuleRunContext
function CorruptionModule:getPriority(context)
    if self.enabled then
        if context.spec == WarlockSpec.AFFLICTION then
            return self:GetAfflictionPriority(context)
        elseif context.spec == WarlockSpec.SMRUIN then
            return self:GetSmRuin(context)
        end
    end
    return -1;
end

--- @param context WarlockModuleRunContext
--- @return number
function CorruptionModule:GetAfflictionPriority(context)
    if not (self.enabled
        and Helpers:SpellReady(Abilities.SiphonLife.name) --- GCD check, corruption can't be used for this
        and self.trackers.castingTracker:ShouldCast()
        and context.mana > context.corruptionCost)
    then
        return -1
    end

    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    if Helpers:SpellAlmostReady(Abilities.DarkHarvest.name, 2)
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

--- @param context WarlockModuleRunContext
--- @return number
function CorruptionModule:GetSmRuin(context)
    if self.enabled
        and Helpers:SpellReady(Abilities.Corruption.name)
        and self.trackers.castingTracker:ShouldCast()
        and context.mana > context.corruptionCost
        and self.trackers.corruptionTracker:ShouldCast()
    then
        return 80;
    end
    return -1;
end
