--- @class BattleShoutModule : Module
--- @field tracker BattleShoutTracker
--- @diagnostic disable: duplicate-set-field
BattleShoutModule = setmetatable({}, { __index = Module })
BattleShoutModule.__index = BattleShoutModule

function BattleShoutModule.new()
    local instance = Module.new(ABILITY_BATTLE_SHOUT)
    setmetatable(instance, BattleShoutModule)

    instance.tracker = BattleShoutTracker.new()

    if instance.enabled then
        instance.tracker:subscribe()
    end

    return instance
end

function BattleShoutModule:enable()
    Module.enable(self)
    self.tracker:subscribe()
end

function BattleShoutModule:disable()
    Module.disable(self)
    self.tracker:unsubscribe()
end

function BattleShoutModule:run()
    Logging:Debug("Casting Battle Shout")
    CastSpellByName(ABILITY_BATTLE_SHOUT)
end

--- @param context WarriorModuleRunContext
function BattleShoutModule:getPriority(context)
    if self.enabled then
        if self.tracker:isAvailable() and context.rage >= context.shoutCost then
            return 95; --- always cast when no buff on yourself
        end
    else
        return -1;
    end
end
