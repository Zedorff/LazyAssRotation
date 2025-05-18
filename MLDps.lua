-- Init

DpsRotation = nil
local trackers = {}

function MLDps_Configuration_Init()
    if not DpsRotation then
        local class = UnitClass("player")
        if (class == CLASS_WARRIOR_DPS) then
            local aaTracker = AutoAttackTracker:new()
            local opTracker = OverpowerTracker:new()
            DpsRotation = Warrior:new({
                autoAttackTracker = aaTracker,
                overpowerTracker = opTracker
            })
            table.insert(trackers, aaTracker)
            table.insert(trackers, opTracker)
        end
    end
end

-- Main Code

function PerformDps()
    if DpsRotation then
        DpsRotation:execute()
    end
end

-- Chat Handlers

function MLDps_SlashCommand(msg)
    local _, _, command, options = string.find(msg, "([%w%p]+)%s*(.*)$");
    if (command) then
        command = string.lower(command);
    end
    if (command == nil or command == "") then
        PerformDps();
    elseif (command == "debug") then
        Logging:toggleDebug()
    end
end

-- Event Handlers

function MLDps_OnLoad()
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_ENTER_COMBAT");
    this:RegisterEvent("PLAYER_LEAVE_COMBAT");
    this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
    this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
    this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
    this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
    this:RegisterEvent("PLAYER_TARGET_CHANGED");
    this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
    this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
    this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
    this:RegisterEvent("CHAT_MSG_SPELL_SELF_MISSES");

    MLDpsLastSpellCast = GetTime();
    SlashCmdList["MLDPS"] = MLDps_SlashCommand;
    SLASH_MLDPS1 = "/mldps";
end

function MLDps_OnEvent(event)
    if (event == "VARIABLES_LOADED") then
        MLDps_Configuration_Init()
    end
    for _, tracker in ipairs(trackers) do
        if type(tracker.onEvent) == "function" then
            tracker:onEvent(event)
        else
            error("Tracker does not implement :onEvent()")
        end
    end
end
