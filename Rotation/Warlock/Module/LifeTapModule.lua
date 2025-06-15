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
        channelingTracker = ChannelingTracker.GetInstance()
    }
    --- @class ImmolateModule
    return setmetatable(Module.new(Abilities.LifeTap.name, trackers, "Interface\\Icons\\Spell_Shadow_BurningSpirit"), LifeTapModule)
end

function LifeTapModule:run()
    Logging:Debug("Casting "..Abilities.LifeTap.name)
    CastSpellByName(Abilities.LifeTap.name)
end

--- @param context WarlockModuleRunContext
function LifeTapModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.LifeTap.name) and self.trackers.channelingTracker:ShouldCast() and context.mana <= 600 then
        return 10;
    end
    return -1;
end
