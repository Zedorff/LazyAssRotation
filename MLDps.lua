MLDps = MLDps or {}
local global = MLDps

--- @class MLDps
--- @field eventBus EventBus

--- @type ClassRotation | nil
local DpsRotation = nil

function Init()
    if not DpsRotation then
        DpsRotation = CreateDpsRotation()
    end
end

function CreateDpsRotation()
    local class = UnitClass("player")
    if (class == CLASS_WARRIOR_DPS) then
        return Warrior.new();
    elseif (class == CLASS_SHAMAN_DPS) then
        return Shaman.new();
    elseif (class == CLASS_PALADIN_DPS) then
        return Paladin.new()
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
        Logging:ToggleDebug()
    elseif (command == "reset") then
        MLDpsLastSpellCast = GetTime();
    end
end

function ResetRotation()
    if DpsRotation then
        DpsRotation:clear()
    end
    DpsRotation = nil
    MLDps:StoptHookingSpellCasts()
end

-- Event Handlers

function MLDps_OnLoad()
    if not MLDpsModuleSettings then
        MLDpsModuleSettings = {}
    end

    if not MLDpsModuleSettings.modulesEnabled then
        MLDpsModuleSettings.modulesEnabled = {}
    end

    InitComponents(this)
    InitSubscribers()

    MLDpsLastSpellCast = GetTime();
    SlashCmdList["MLDPS"] = MLDps_SlashCommand;
    SLASH_MLDPS1 = "/mldps";
end

function InitComponents(frame)
    global.eventBus = EventBus:new(frame)
end

function InitSubscribers()
    global.eventBus:subscribe({
        onEvent = function (_, event, arg1)
            if (event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_AURA_GONE_OTHER") then
                -- Logging:Log("Event: "..event..", arg1: "..tostring(arg1))
            end
            if (event == "VARIABLES_LOADED") then
                Init()
            elseif (event == "CHARACTER_POINTS_CHANGED" or event == "LEARNED_SPELL_IN_TAB") then
                ModuleRegistry:ClearRegistry()
                ResetRotation()
            end
    end})
end
