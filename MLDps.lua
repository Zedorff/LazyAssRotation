-- Init

DpsRotation = nil
local trackers = {}

function MLDps_Configuration_Init()
    
end

function CreateDpsRotation()
    if trackers then
        trackers = {}
    end
    local class = UnitClass("player")
    if (class == CLASS_WARRIOR_DPS) then
        local aaTracker = AutoAttackTracker:new()
        local opTracker = OverpowerTracker:new()
        local rotation = Warrior:new({
            autoAttackTracker = aaTracker,
            overpowerTracker = opTracker
        })
        table.insert(trackers, aaTracker)
        table.insert(trackers, opTracker)
        return rotation;
    end
end

-- Main Code

function PerformDps()
    if not DpsRotation then
        DpsRotation = CreateDpsRotation()
    end
    DpsRotation:execute() 
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
        Logging:ToggleDebug()
    elseif (command == "reset") then
        MLDpsLastSpellCast = GetTime();
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
    this:RegisterEvent("CHARACTER_POINTS_CHANGED");
    this:RegisterEvent("LEARNED_SPELL_IN_TAB");

    MLDpsLastSpellCast = GetTime();
    SlashCmdList["MLDPS"] = MLDps_SlashCommand;
    SLASH_MLDPS1 = "/mldps";
end

function MLDps_OnEvent(event)
    if (event == "VARIABLES_LOADED") then
        MLDps_Configuration_Init()
    elseif (event == "CHARACTER_POINTS_CHANGED" or event == "LEARNED_SPELL_IN_TAB") then
        DpsRotation = nil
    end
    for _, tracker in ipairs(trackers) do
        if type(tracker.onEvent) == "function" then
            tracker:onEvent(event)
        else
            error("Tracker does not implement :onEvent()")
        end
    end
end
