--- @alias NightfallTrackers { nightfallTracker: NightfallTracker, castingTracker: CastingTracker }
--- @class NightfallModule : Module
--- @field trackers NightfallTrackers
--- @diagnostic disable: duplicate-set-field
NightfallModule = setmetatable({}, { __index = Module })
NightfallModule.__index = NightfallModule

--- @return NightfallModule
function NightfallModule.new()
    --- @type NightfallTrackers
    local trackers = {
        nightfallTracker = NightfallTracker.new(),
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class NightfallModule
    return setmetatable(Module.new(PASSIVE_NIGHTFALL, trackers, "Interface\\Icons\\Spell_Shadow_Twilight"), NightfallModule)
end

function NightfallModule:run()
    Logging:Debug("Casting "..Abilities.ShadowBolt.name)
    CastSpellByName(Abilities.ShadowBolt.name)
end

--- @param context WarlockModuleRunContext
function NightfallModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.ShadowBolt.name) then
        if self.trackers.nightfallTracker:ShouldCast() and self.trackers.castingTracker:ShouldCast() and context.mana > context.sbCost then
            return 40
        end
    end
    return -1;
end
