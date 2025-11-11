--- @alias DrainSoulTrackers { castingTracker: CastingTracker, coaTracker: CurseOfAgonyTracker }
--- @class DrainSoulModule : Module
--- @field trackers DrainSoulTrackers
--- @diagnostic disable: duplicate-set-field
DrainSoulModule = setmetatable({}, { __index = Module })
DrainSoulModule.__index = DrainSoulModule

--- @param allowAgonyWithOtherCurses boolean
--- @return DrainSoulModule
function DrainSoulModule.new(allowAgonyWithOtherCurses)
    --- @type DrainSoulTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    }
    --- @class DrainSoulModule
    return setmetatable(Module.new(Abilities.DrainSoul.name, trackers, "Interface\\Icons\\Spell_Shadow_Haunting"), DrainSoulModule)
end

function DrainSoulModule:run()
    Logging:Debug("Casting "..Abilities.DrainSoul.name)
    CastSpellByName(Abilities.DrainSoul.name)
end

--- @param context WarlockModuleRunContext
function DrainSoulModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.DrainSoul.name) and self.trackers.castingTracker:ShouldCast() then
        local skipBecauseOfCoe = Helpers:SpellAlmostReady(Abilities.DarkHarvest.name, 3) and self.trackers.coaTracker:GetRemainingDuration() <= 3 and ModuleRegistry:IsModuleEnabled(Abilities.CoE.name)
        if not skipBecauseOfCoe and context.mana >= context.drainSoulCost then
            return 30;
        end
    else
        return -1;
    end
end
