--- @alias OverpowertTrackers { overpowerTracker: OverpowerTracker }
--- @class OverpowerModule : Module
--- @field trackers OverpowertTrackers
--- @diagnostic disable: duplicate-set-field
OverpowerModule = setmetatable({}, { __index = Module })
OverpowerModule.__index = OverpowerModule

--- @return OverpowerModule
function OverpowerModule.new()
    --- @type OverpowertTrackers
    local trackers = {
        overpowerTracker = OverpowerTracker.new()
    }
    --- @class OverpowerModule
    return setmetatable(Module.new(ABILITY_OVERPOWER, trackers), OverpowerModule)
end

function OverpowerModule:run()
    Logging:Debug("Casting Overpower")
    CastSpellByName(ABILITY_OVERPOWER)
end

--- @param context WarriorModuleRunContext
function OverpowerModule:getPriority(context)
    if self.enabled and context.stance == 1 then
        if self.trackers.overpowerTracker:ShouldCast() and Helpers:SpellReady(ABILITY_OVERPOWER) and context.rage >= 5 then
            return 90
        else
            return -1;
        end
    end
end
