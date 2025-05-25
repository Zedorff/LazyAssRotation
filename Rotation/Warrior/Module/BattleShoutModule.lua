--- @alias BattleShoutTrackers { battleShoutTracker: BattleShoutTracker }
--- @class BattleShoutModule : Module
--- @field trackers BattleShoutTrackers
--- @diagnostic disable: duplicate-set-field
BattleShoutModule = setmetatable({}, { __index = Module })
BattleShoutModule.__index = BattleShoutModule

--- @return BattleShoutModule
function BattleShoutModule.new()
    --- @type BattleShoutTrackers
    local trackers = {
        battleShoutTracker = BattleShoutTracker.new()
    }
    --- @class BattleShoutModule
    return setmetatable(Module.new(ABILITY_BATTLE_SHOUT, trackers), BattleShoutModule)
end

function BattleShoutModule:run()
    Logging:Debug("Casting Battle Shout")
    CastSpellByName(ABILITY_BATTLE_SHOUT)
end

--- @param context WarriorModuleRunContext
function BattleShoutModule:getPriority(context)
    if self.enabled then
        if self.trackers.battleShoutTracker:ShouldCast() and context.rage >= context.shoutCost then
            return 95; --- always cast when no buff on yourself
        end
    else
        return -1;
    end
end
