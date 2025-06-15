--- @alias StormStrikeTrackers { clearcastingTracker: ClearcastingTracker }
--- @class StormStrikeModule : Module
--- @field trackers StormStrikeTrackers
--- @diagnostic disable: duplicate-set-field
StormStrikeModule = setmetatable({}, { __index = Module })
StormStrikeModule.__index = StormStrikeModule

--- @return StormStrikeModule
function StormStrikeModule.new()
    --- @type StormStrikeTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class StormStrikeModule
    return setmetatable(Module.new(Abilities.Stormstrike.name, trackers, "Interface\\Icons\\Ability_Shaman_Stormstrike"), StormStrikeModule)
end

function StormStrikeModule:run()
    Logging:Debug("Casting "..Abilities.Stormstrike.name)
    CastSpellByName(Abilities.Stormstrike.name)
end

--- @param context ShamanModuleRunContext
function StormStrikeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Stormstrike.name) then
        local cost = self.trackers.clearcastingTracker:ShouldCast() and math.floor(context.ssCost * 0.33) or context.ssCost
        if context.mana > cost then
            return 80;
        end
    end
    return -1;
end
