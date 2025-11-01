--- @alias ArcaneMissilesTrackers { channelingTracker: ChannelingTracker }
--- @class ArcaneMissilesModule : Module
--- @field trackers ArcaneMissilesTrackers
--- @diagnostic disable: duplicate-set-field
ArcaneMissilesModule = setmetatable({}, { __index = Module })
ArcaneMissilesModule.__index = ArcaneMissilesModule

--- @return ArcaneMissilesModule
function ArcaneMissilesModule.new()
    --- @type ArcaneMissilesTrackers
    local trackers = {
        channelingTracker = ChannelingTracker.GetInstance()
    }
    --- @class ArcaneMissilesModule
    return setmetatable(Module.new(Abilities.ArcaneMissiles.name, trackers, "Interface\\Icons\\Spell_Nature_StarFall"), ArcaneMissilesModule)
end

function ArcaneMissilesModule:run()
    Logging:Debug("Casting "..Abilities.ArcaneMissiles.name)
    CastSpellByName(Abilities.ArcaneMissiles.name)
end

--- @param context MageModuleRunContext
function ArcaneMissilesModule:getPriority(context)
    if self.enabled and self.trackers.channelingTracker:ShouldCast() then
        if not Helpers:SpellAlmostReady(Abilities.ArcaneRupture.name, 1.5) and context.mana >= context.amCost then
            return 70;
        end
    else
        return -1;
    end
end
