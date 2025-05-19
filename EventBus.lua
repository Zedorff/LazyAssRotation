MLDps = MLDps or {}

EventBus = {}
EventBus.__index = EventBus

--- @class EventBus
--- @field subscribers table

function EventBus:new(frame)
    local obj = {
        subscribers = {}
    }

    local instance = setmetatable(obj, EventBus)

    frame:RegisterEvent("VARIABLES_LOADED")
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
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");

    frame:SetScript( "OnEvent", function()
        instance:notify(event, arg1, arg2, arg3, arg4, arg5)
    end )

    return instance
end

--- @param handler function
function EventBus:subscribe(handler)
    table.insert(self.subscribers, handler)
end

function EventBus:notify(event, arg1, arg2, arg3, arg4, arg5)
    for _, subscriber in ipairs( self.subscribers ) do
        subscriber(event, arg1, arg2, arg3, arg4, arg5 )
    end
end