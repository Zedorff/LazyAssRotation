--- @alias HeroicStrikeTrackers { autoAttackTracker: AutoAttackTracker, actionSlotTracker: ActionBarSlotTracker }
--- @class HeroicStrikeBase : Module
--- @field trackers HeroicStrikeTrackers
--- @diagnostic disable: duplicate-set-field
HeroicStrikeBase = setmetatable({}, { __index = Module })
HeroicStrikeBase.__index = HeroicStrikeBase

--- @return HeroicStrikeBase
function HeroicStrikeBase.new()
    --- @type HeroicStrikeTrackers
    local trackers = {
        autoAttackTracker = AutoAttackTracker.GetInstance(),
        actionSlotTracker = ActionBarSlotTracker.GetInstance()
    }
    --- @class HeroicStrikeBase
    return setmetatable(Module.new(Abilities.HeroicStrike.name, trackers, "Interface\\Icons\\Ability_Rogue_Ambush"),
        HeroicStrikeBase);
end

function HeroicStrikeBase:run()
    Logging:Debug("Casting "..Abilities.HeroicStrike.name)
    CastSpellByName(Abilities.HeroicStrike.name)
end

function HeroicStrikeBase:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.Cleave.name)
end

--- @param context WarriorModuleRunContext
--- @return integer
function HeroicStrikeBase:getPriority(context)
    local hsSlot = self.trackers.actionSlotTracker:GetActionBarSlot(Abilities.HeroicStrike.name)
    if self.enabled and hsSlot ~= nil and not IsCurrentAction(hsSlot) then
        return self:getSpecPriority(context)
    end
    return -1
end

--- @param context WarriorModuleRunContext
--- @return integer
function HeroicStrikeBase:getSpecPriority(context)
    return -1
end
