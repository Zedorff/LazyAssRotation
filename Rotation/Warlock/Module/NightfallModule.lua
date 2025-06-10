--- @alias NightfallTrackers { nightfallTracker: NightfallTracker, channelingTracker: ChannelingTracker }
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
        channelingTracker = ChannelingTracker.GetInstance()
    }
    --- @class NightfallModule
    return setmetatable(Module.new(PASSIVE_NIGHTFALL, trackers, "Interface\\Icons\\Spell_Shadow_Twilight"), NightfallModule)
end

function NightfallModule:run()
    Logging:Debug("Casting "..ABILITY_SHADOW_BOLT)
    CastSpellByName(ABILITY_SHADOW_BOLT)
end

--- @param context WarlockModuleRunContext
function NightfallModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_SHADOW_BOLT) then
        if self.trackers.nightfallTracker:ShouldCast() and self.trackers.channelingTracker:ShouldCast() and context.mana > context.sbCost then
            return 90
        end
    end
    return -1;
end
