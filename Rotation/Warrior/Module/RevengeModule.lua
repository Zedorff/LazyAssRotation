--- @alias RevengeTrackers { revengeTracker: RevengeTracker }
--- @class RevengeModule : Module
--- @field trackers RevengeTrackers
--- @diagnostic disable: duplicate-set-field
RevengeModule = setmetatable({}, { __index = Module })
RevengeModule.__index = RevengeModule

--- @return RevengeModule
function RevengeModule.new()
    --- @type RevengeTrackers
    local trackers = {
        revengeTracker = RevengeTracker.new()
    }
    --- @class RevengeModule
    return setmetatable(Module.new(Abilities.Revenge.name, trackers, "Interface\\Icons\\Ability_Warrior_Revenge"), RevengeModule)
end

function RevengeModule:run()
    Logging:Debug("Casting "..Abilities.Revenge.name)
    CastSpellByName(Abilities.Revenge.name)
end

--- @param context WarriorModuleRunContext
function RevengeModule:getPriority(context)
    if self.enabled and context.stance == 2 then
        if self.trackers.revengeTracker:ShouldCast() and Helpers:SpellReady(Abilities.Revenge.name) and context.rage >= 5 then
            return 90
        else
            return -1;
        end
    end
end
