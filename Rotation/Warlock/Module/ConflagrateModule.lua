--- @alias ConflagrateTrackers { immolateTracker: ImmolateTracker }
--- @class ConflagrateModule : Module
--- @field trackers ConflagrateTrackers
--- @diagnostic disable: duplicate-set-field
ConflagrateModule = setmetatable({}, { __index = Module })
ConflagrateModule.__index = ConflagrateModule

--- @return ConflagrateModule
function ConflagrateModule.new()
    --- @type ConflagrateTrackers
    local trackers = {
        immolateTracker = ImmolateTracker.new()
    }
    --- @class ConflagrateModule
    return setmetatable(Module.new(Abilities.Conflagrate.name, trackers, "Interface\\Icons\\Spell_Fire_Fireball"), ConflagrateModule)
end

function ConflagrateModule:run()
    Logging:Debug("Casting "..Abilities.Conflagrate.name)
    CastSpellByName(Abilities.Conflagrate.name)
end

--- @param context WarlockModuleRunContext
function ConflagrateModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled and Helpers:SpellAlmostReady(Abilities.Conflagrate.name, 0.3) and self.trackers.immolateTracker:GetRemainingOnTarget() > 0 and context.mana > context.conflagrateCost then
        return 85;
    end
    return -1;
end
