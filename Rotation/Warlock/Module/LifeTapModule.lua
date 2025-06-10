--- @alias LifeTapTrackers { channelingTracker: ChannelingTracker }
--- @class LifeTapModule : Module
--- @field trackers LifeTapTrackers
--- @diagnostic disable: duplicate-set-field
LifeTapModule = setmetatable({}, { __index = Module })
LifeTapModule.__index = LifeTapModule

--- @return ImmolateModule
function LifeTapModule.new()
    --- @type LifeTapTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.new()
    }
    --- @class ImmolateModule
    return setmetatable(Module.new(ABILITY_LIFE_TAP, trackers, "Interface\\Icons\\Spell_Shadow_BurningSpirit"), LifeTapModule)
end

function LifeTapModule:run()
    Logging:Debug("Casting "..ABILITY_LIFE_TAP)
    CastSpellByName(ABILITY_LIFE_TAP)
end

--- @param context WarlockModuleRunContext
function LifeTapModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_LIFE_TAP) and self.trackers.channelingTracker:ShouldCast() and context.mana <= 600 then
        return 10;
    end
    return -1;
end
