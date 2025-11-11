--- @alias MageClearcastingTrackers { castingTracker: CastingTracker, clearcastingTracker: ClearcastingTracker }
--- @class MageClearcastingModule : Module
--- @field trackers MageClearcastingTrackers
--- @diagnostic disable: duplicate-set-field
MageClearcastingModule = setmetatable({}, { __index = Module })
MageClearcastingModule.__index = MageClearcastingModule

--- @return MageClearcastingModule
function MageClearcastingModule.new()
    --- @type MageClearcastingTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class MageClearcastingModule
    return setmetatable(Module.new(PASSIVE_CLEARCASTING, trackers, "Interface\\Icons\\Spell_Shadow_ManaBurn"), MageClearcastingModule)
end

function MageClearcastingModule:run()
    Logging:Debug("Casting "..Abilities.ArcaneMissiles.name)
    CastSpellByName(Abilities.ArcaneMissiles.name)
end

--- @param context MageModuleRunContext
function MageClearcastingModule:getPriority(context)
    if self.enabled and self.trackers.castingTracker:ShouldCast() then
        if not Helpers:SpellAlmostReady(Abilities.ArcaneRupture.name, 1.5) and self.trackers.clearcastingTracker:ShouldCast() and context.mana <= context.amCost * 2 then
            return 90;
        end
    end
    return -1;
end
