--- @alias DrainSoulTrackers { channelingTracker: ChannelingTracker, coaTracker: CurseOfAgonyTracker }
--- @class DrainSoulModule : Module
--- @field trackers DrainSoulTrackers
--- @diagnostic disable: duplicate-set-field
DrainSoulModule = setmetatable({}, { __index = Module })
DrainSoulModule.__index = DrainSoulModule

--- @return DrainSoulModule
function DrainSoulModule.new()
    --- @type DrainSoulTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.GetInstance(),
        coaTracker = CurseOfAgonyTracker.GetInstance(true)
    }
    --- @class DrainSoulModule
    return setmetatable(Module.new(ABILITY_DRAIN_SOUL, trackers, "Interface\\Icons\\Spell_Shadow_Haunting"), DrainSoulModule)
end

function DrainSoulModule:run()
    Logging:Debug("Casting "..ABILITY_DRAIN_SOUL)
    CastSpellByName(ABILITY_DRAIN_SOUL)
end

--- @param context WarlockModuleRunContext
function DrainSoulModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_DRAIN_SOUL) and self.trackers.channelingTracker:ShouldCast() then
        local skipBecauseOfCoe = Helpers:SpellAlmostReady(ABILITY_DARK_HARVEST, 3) and self.trackers.coaTracker:GetRemainingDuration() <= 3 and ModuleRegistry:IsModuleEnabled(ABILITY_COE)
        if not skipBecauseOfCoe and context.mana >= context.drainSoulCost then
            return 30;
        end
    else
        return -1;
    end
end
