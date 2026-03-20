--- @alias CleaveTrackers { autoAttackTracker: AutoAttackTracker }
--- @class CleaveBase : Module
--- @field trackers CleaveTrackers
--- @diagnostic disable: duplicate-set-field
CleaveBase = setmetatable({}, { __index = Module })
CleaveBase.__index = CleaveBase

--- @return CleaveBase
function CleaveBase.new()
    --- @type CleaveTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.GetInstance()
    }
    --- @class CleaveBase
    return setmetatable(Module.new(Abilities.Cleave.name, trackers, "Interface\\Icons\\Ability_Warrior_Cleave", false),
        CleaveBase);
end

function CleaveBase:run()
    Logging:Debug("Casting "..Abilities.Cleave.name)
    CastSpellByName(Abilities.Cleave.name)
end

function CleaveBase:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.HeroicStrike.name)
end

--- @param context WarriorModuleRunContext
--- @return integer
function CleaveBase:getPriority(context)
    if self.enabled then
        return self:getSpecPriority(context)
    end
    return -1
end

--- @param context WarriorModuleRunContext
--- @return integer
function CleaveBase:getSpecPriority(context)
    return -1
end

function CleaveBase:isMultiCastAllowed()
    return true
end
