--- @type ClassRotation | nil
local DpsRotation = nil

function Init()
    if not DpsRotation then
        DpsRotation = CreateDpsRotation()
    end
    HotSwapButton:Show()
    Settings_OnLoad()
end

function CreateDpsRotation()
    local class = UnitClass("player")
    if (class == CLASS_WARRIOR_DPS) then
        return Warrior.new();
    elseif (class == CLASS_SHAMAN_DPS) then
        return Shaman.new();
    elseif (class == CLASS_PALADIN_DPS) then
        return Paladin.new()
    elseif (class == CLASS_DRUID_DPS) then
        return Druid.new()
    elseif (class == CLASS_MAGE_DPS) then
        return Mage.new()
    end
end

-- Main Code

function PerformDps()
    if DpsRotation then
        DpsRotation:execute()
    end
end

-- Chat Handlers

function SlashCommand(msg)
    local _, _, command, options = string.find(msg, "([%w%p]+)%s*(.*)$");
    if (command) then
        command = string.lower(command);
    end
    if (command == nil or command == "") then
        PerformDps();
    elseif (command == "debug") then
        Logging:ToggleDebug()
    elseif (command == "reset") then
        LastSpellCast = GetTime();
    end
end

-- Event Handlers

function Main_OnLoad()
    if not LARModuleSettings then
        LARModuleSettings = {}
    end

    if not LARModuleSettings.modulesEnabled then
        LARModuleSettings.modulesEnabled = {}
    end

    InitComponents(this)
    InitSubscribers()

    LastSpellCast = GetTime();
    SlashCmdList["LAR"] = SlashCommand;
    SLASH_LAR1 = "/lar";
end

function InitComponents(frame)
    Core.eventBus = EventBus:new(frame)
end

function InitSubscribers()
    Core.eventBus:subscribe({
        onEvent = function (_, event, arg1)
            if (event == "SPELLCAST_FAILED") then
                -- Logging:Log("Event: "..event..", arg1: "..tostring(arg1))
            end
            if (event == "VARIABLES_LOADED") then
                Init()
            elseif event == "SPEC_CHANGED" and DpsRotation then
                DpsRotation:SelectSpec(arg1)
            end
    end})
end
