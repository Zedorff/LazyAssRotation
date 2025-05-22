MLDps = MLDps or {}
local global = MLDps

--- @class MLDps
--- @field eventBus EventBus

local DpsRotation = nil

function init()
    local class = UnitClass("player")
    if (class == CLASS_WARRIOR_DPS) then
        ModuleRegistry:RegisterModule(AutoAttackModule.new())
        ModuleRegistry:RegisterModule(BattleShoutModule.new())
        -- ModuleRegistry:RegisterModule(BloodthirstModule.new())
        ModuleRegistry:RegisterModule(ExecuteModule.new())
        -- ModuleRegistry:RegisterModule(HamstringModule.new())
        ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
        ModuleRegistry:RegisterModule(MortalStrikeModule.new())
        ModuleRegistry:RegisterModule(SlamModule.new())
        ModuleRegistry:RegisterModule(WhirlwindModule.new())
        ModuleRegistry:RegisterModule(RendModule.new())
    end
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
            if (event == "VARIABLES_LOADED") then
                init()
            elseif (event == "CHARACTER_POINTS_CHANGED" or event == "LEARNED_SPELL_IN_TAB") then
                DpsRotation = nil
            end
    end})
end
