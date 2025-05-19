MLDps = MLDps or {}
local global = MLDps

--- @class MLDps
--- @field trackers table
--- @field eventBus EventBus

local DpsRotation = nil

function init()
    
end

function CreateDpsRotation()
    local class = UnitClass("player")
    if (class == CLASS_WARRIOR_DPS) then
        return Warrior:new();
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

function ResetRotation()
    global.trackers = {}
    DpsRotation = nil
    MLDps:StoptHookingSpellCasts()
end

-- Event Handlers

function MLDps_OnLoad()
    InitComponents(this)
    InitSubscribers()

    MLDpsLastSpellCast = GetTime();
    SlashCmdList["MLDPS"] = MLDps_SlashCommand;
    SLASH_MLDPS1 = "/mldps";
end

function InitComponents(frame)
    global.trackers = {}
    global.eventBus = EventBus:new(frame)
end

function InitSubscribers()
    global.eventBus:subscribe(function (event, arg1)
        if (event == "VARIABLES_LOADED") then
            init()
        elseif (event == "CHARACTER_POINTS_CHANGED" or event == "LEARNED_SPELL_IN_TAB") then
            DpsRotation = nil
        end
        for _, tracker in ipairs(global.trackers) do
            if type(tracker.onEvent) == "function" then
                tracker:onEvent(event, arg1)
            else
                error("Tracker does not implement :onEvent()")
            end
        end
    end)
end
