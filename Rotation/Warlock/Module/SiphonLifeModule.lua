--- @alias SiphonLifeTrackers { siphonLifeTracker: SiphonLifeTracker, darkHarvestTracker: DarkHarvestTracker, channelingTracker: ChannelingTracker, corruptionTracker: CorruptionTracker, coaTracker: CurseOfAgonyTracker }
--- @class SiphonLifeModule : Module
--- @field trackers SiphonLifeTrackers
--- @diagnostic disable: duplicate-set-field
SiphonLifeModule = setmetatable({}, { __index = Module })
SiphonLifeModule.__index = SiphonLifeModule

--- @return SiphonLifeModule
function SiphonLifeModule.new()
    --- @type SiphonLifeTrackers
    local trackers = {
        siphonLifeTracker = SiphonLifeTracker.new(),
        darkHarvestTracker = DarkHarvestTracker.new(),
        channelingTracker = ChannelingTracker.new(),
        corruptionTracker = CorruptionTracker.new(),
        coaTracker = CurseOfAgonyTracker.new(true)
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
        and Helpers:SpellReady(ABILITY_SIPHON_LIFE)   -- NB: check correct constant
        and self.trackers.channelingTracker:ShouldCast()
        and context.mana > context.siphonLifeCost)
    then
        return -1
    end

    local siphRemaining  = self.trackers.siphonLifeTracker:GetRemainingDuration()
    local corrRemaining  = self.trackers.corruptionTracker:GetRemainingDuration()
    local agonyRemaining = self.trackers.coaTracker:GetRemainingDuration()

    -- (4) Renew Siphon Life before Dark Harvest if Agony ≥ 13 s and dots will meet the 10 s rule
    if Helpers:SpellReady(ABILITY_DARK_HARVEST)
        and agonyRemaining >= 13
        and corrRemaining  >= 10          -- satisfy rule 1 for CORRUPTION
        and siphRemaining  <  10
    then
        return 100
    end

    -- Standard cast if expired
    if self.trackers.siphonLifeTracker:ShouldCast() then
        return 70
    end
    return -1
end
