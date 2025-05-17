-- Init

DpsRotation = nil

function MLDps_Configuration_Init()
    if not DpsRotation then
        local class = UnitClass("player")
        if (class == CLASS_WARRIOR_DPS) then
            DpsRotation = Warrior:new()
        end
    end
end

-- Main Code

function DPS()
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
        DPS();
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
    if DpsRotation then
        DpsRotation:onEvent(event)
    end

    if (event == "VARIABLES_LOADED") then
        MLDps_Configuration_Init()
    end
end
