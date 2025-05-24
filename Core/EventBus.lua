MLDps = MLDps or {}

EventBus = {}
EventBus.__index = EventBus

--- @class EventBus
--- @field subscribers table

--- @class EventSubscriber
--- @field onEvent fun(self: table, event: string, ...)

function EventBus:new(frame)
    Logging:Log("Create EventBus")
    local obj = {
        subscribers = {}
    }

    local instance = setmetatable(obj, EventBus)

    frame:RegisterEvent("VARIABLES_LOADED");
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    frame:RegisterEvent("PLAYER_ENTER_COMBAT");
    frame:RegisterEvent("PLAYER_LEAVE_COMBAT");
    frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
    frame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
    frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
    frame:RegisterEvent("PLAYER_TARGET_CHANGED");
    frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
    frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_MISSES");
    frame:RegisterEvent("CHARACTER_POINTS_CHANGED");
    frame:RegisterEvent("LEARNED_SPELL_IN_TAB");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
    frame:RegisterEvent("UNIT_INVENTORY_CHANGED");
    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
    
    frame:SetScript( "OnEvent", function()
        --- @diagnostic disable-next-line: undefined-global
        instance:notify(event, arg1, arg2, arg3, arg4, arg5)
    end )

    return instance
end

function EventBus:subscribe(handler)
    self.subscribers[handler] = true
end

function EventBus:unsubscribe(handler)
    self.subscribers[handler] = nil
end

function EventBus:notify(event, arg1, arg2, arg3, arg4, arg5)
    for subscriber, _ in pairs(self.subscribers) do
        subscriber:onEvent(event, arg1, arg2, arg3, arg4, arg5)
    end
end
