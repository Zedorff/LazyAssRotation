--- @alias RendTrackers { rendTracker: RendTracker }
--- @class RendModule : Module
--- @field trackers RendTrackers
--- @diagnostic disable: duplicate-set-field
RendModule = setmetatable({}, { __index = Module })
RendModule.__index = RendModule

--- @return RendModule
function RendModule.new()
    --- @type RendTrackers
    local trackers = {
        rendTracker = RendTracker.new()
    }
    --- @class RendModule
    return setmetatable(Module.new(ABILITY_REND, trackers, "Interface\\Icons\\Ability_Gouge"), RendModule)
end

function RendModule:run()
    Logging:Debug("Casting Rend")
    CastSpellByName(ABILITY_REND)
end

--- @param context WarriorModuleRunContext
function RendModule:getPriority(context)
    if self.enabled and context.stance == 1 then
        if self.trackers.rendTracker:ShouldCast() and context.rage >= context.rendCost then
            return 55; --- prio higher than heroic
        end
    else
        return -1;
    end
end
