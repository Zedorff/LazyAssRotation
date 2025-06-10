--- @class EventSubscriber
--- @field onEvent fun(self: table, event: string, ...)

--- @class EventBus
--- @field subscribers table
EventBus = {}
EventBus.__index = EventBus

function EventBus:new(frame)
    local obj = {
        subscribers = {}
    }

    local instance = setmetatable(obj, EventBus)

    frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
    frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
    frame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
    frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
    frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
    frame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
    frame:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
    frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
    frame:RegisterEvent("CHAT_MSG_SPELL_SELF_MISSES");
    frame:RegisterEvent("LEARNED_SPELL_IN_TAB");
    frame:RegisterEvent("PLAYER_ENTER_COMBAT");
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    frame:RegisterEvent("PLAYER_DEAD");
    frame:RegisterEvent("PLAYER_LEAVE_COMBAT");
    frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    frame:RegisterEvent("PLAYER_TARGET_CHANGED");
    frame:RegisterEvent("SPELLCAST_CHANNEL_START");
    frame:RegisterEvent("SPELLCAST_CHANNEL_STOP");
    frame:RegisterEvent("SPELLCAST_INTERRUPTED");
    frame:RegisterEvent("UNIT_ENERGY");
    frame:RegisterEvent("UNIT_INVENTORY_CHANGED");
    frame:RegisterEvent("UNIT_MANA");
    frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
    frame:RegisterEvent("VARIABLES_LOADED");
    frame:RegisterEvent("UI_ERROR_MESSAGE");
    frame:RegisterEvent("UNIT_CASTEVENT");
    frame:SetScript("OnEvent", function()
        --- @diagnostic disable-next-line: undefined-global
        -- if event == "UNIT_CASTEVENT" then
        --     local _, guid = UnitExists("player")
        --     if arg1 ~= guid then
        --         return
        --     end
        --     if arg3 ~= "CAST" then
        --         return
        --     end
            -- Logging:Log("casterGuid: "..tostring(arg1)..", targetGuid: "..tostring(arg2)..", event: "..tostring(arg3)..", spellID: "..tostring(arg4)..", castDuration: "..tostring(arg5))
        -- end
        instance:notify(event, arg1, arg2, arg3, arg4, arg5)
    end)

    return instance
end

--- @param handler EventSubscriber
function EventBus:subscribe(handler)
    self.subscribers[handler] = true
end

--- @param handler EventSubscriber
function EventBus:unsubscribe(handler)
    self.subscribers[handler] = nil
end

function EventBus:notify(event, arg1, arg2, arg3, arg4, arg5)
    for subscriber, _ in pairs(self.subscribers) do
        subscriber:onEvent(event, arg1, arg2, arg3, arg4, arg5)
    end
end
