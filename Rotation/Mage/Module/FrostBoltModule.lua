--- @alias FrostBoltTrackers { castingTracker: CastingTracker }
--- @class FrostBoltModule : Module
--- @field trackers FrostBoltTrackers
--- @diagnostic disable: duplicate-set-field
FrostBoltModule = setmetatable({}, { __index = Module })
FrostBoltModule.__index = FrostBoltModule

--- @return FrostBoltModule
function FrostBoltModule.new()
    --- @type FrostBoltTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class FrostBoltModule
    return setmetatable(Module.new(Abilities.FrostBolt.name, trackers, "Interface\\Icons\\Spell_Frost_FrostBolt02"), FrostBoltModule)
end

function FrostBoltModule:run()
    Logging:Debug("Casting "..Abilities.FrostBolt.name)
    CastSpellByName(Abilities.FrostBolt.name)
end

--- @param context MageModuleRunContext
function FrostBoltModule:getPriority(context)
    if not self.enabled or not self.trackers.castingTracker:ShouldCast() then
        return -1
    end

    local hasMana = context.mana >= context.frostBoltCost
    if hasMana then
        return 50
    end

    return -1
end
