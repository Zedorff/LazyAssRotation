--- @alias ShadowformTrackers { shadowformTracker: ShadowformTracker }
--- @class ShadowformModule : Module
--- @field trackers ShadowformTrackers
--- @diagnostic disable: duplicate-set-field
ShadowformModule = setmetatable({}, { __index = Module })
ShadowformModule.__index = ShadowformModule

--- @return ShadowformModule
function ShadowformModule.new()
    --- @type ShadowformTrackers
    local trackers = {
        shadowformTracker = ShadowformTracker.new()
    }
    --- @class ShadowformModule
    return setmetatable(Module.new(Abilities.Shadowform.name, trackers, "Interface\\Icons\\Spell_Shadow_Shadowform"), ShadowformModule)
end

function ShadowformModule:run()
    Logging:Debug("Casting "..Abilities.Shadowform.name)
    CastSpellByName(Abilities.Shadowform.name)
end

--- @param context PriestModuleRunContext
function ShadowformModule:getPriority(context)
    if not self.enabled then
        return -1;
    end

    if self.trackers.shadowformTracker:ShouldCast() and Helpers:SpellReady(Abilities.Shadowform.name) then
        return 100;
    end

    return -1;
end
