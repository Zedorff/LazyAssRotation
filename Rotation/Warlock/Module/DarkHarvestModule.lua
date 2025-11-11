--- @alias DarkHarvestTrackers { castingTracker: CastingTracker, siphonLifeTracker: SiphonLifeTracker, coaTracker: CurseOfAgonyTracker, corruptionTracker: CorruptionTracker }
--- @class DarkHarvestModule : Module
--- @field trackers DarkHarvestTrackers
--- @diagnostic disable: duplicate-set-field
DarkHarvestModule = setmetatable({}, { __index = Module })
DarkHarvestModule.__index = DarkHarvestModule

--- @param allowAgonyWithOtherCurses boolean
--- @return DarkHarvestModule
function DarkHarvestModule.new(allowAgonyWithOtherCurses)
    --- @type DarkHarvestTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses),
        corruptionTracker = CorruptionTracker.GetInstance(),
        siphonLifeTracker = SiphonLifeTracker.GetInstance(),
    }
    --- @class DarkHarvestModule
    return setmetatable(Module.new(Abilities.DarkHarvest.name, trackers, "Interface\\Icons\\Spell_Shadow_SoulLeech"), DarkHarvestModule)
end

function DarkHarvestModule:run()
    if Helpers:SpellReady(Abilities.DarkHarvest.name) then
        Logging:Debug("Casting "..Abilities.DarkHarvest.name)
        CastSpellByName(Abilities.DarkHarvest.name)
    end
end

--- @param context WarlockModuleRunContext
function DarkHarvestModule:getPriority(context)
    if not (self.enabled
        and Helpers:SpellReady(Abilities.SiphonLife.name) --- just GCD check
        and self.trackers.castingTracker:ShouldCast()
        and context.mana >= context.darkHarvestCost)
    then
        return -1
    end

    local corrRemaining  = ModuleRegistry:IsModuleEnabled(Abilities.Corruption.name) and self.trackers.corruptionTracker:GetRemainingDuration() or 100
    local siphRemaining  = ModuleRegistry:IsModuleEnabled(Abilities.SiphonLife.name) and self.trackers.siphonLifeTracker:GetRemainingDuration() or 100
    local agonyRemaining = ModuleRegistry:IsModuleEnabled(Abilities.CoA.name) and self.trackers.coaTracker:GetRemainingDuration() or 100

    if Helpers:SpellAlmostReady(Abilities.DarkHarvest.name, 2) and corrRemaining >= 8 and siphRemaining >= 8 and agonyRemaining >= 8 then
        return 50
    end
    return -1
end
