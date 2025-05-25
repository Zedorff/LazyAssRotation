--- @alias SealOfCommandTrackers { socTracker: SealOfCommandTracker, sowTargetTracker: SealOfWisdomTargetTracker, socrTargetTracker: SealOfCrusaderTargetTracker }
--- @class SealOfCommandModule : Module
--- @field trackers SealOfCommandTrackers
--- @diagnostic disable: duplicate-set-field
SealOfCommandModule = setmetatable({}, { __index = Module })
SealOfCommandModule.__index = SealOfCommandModule

--- @return SealOfCommandModule
function SealOfCommandModule.new()
    --- @type SealOfCommandTrackers
    local trackers = {
        socTracker = SealOfCommandTracker.new(),
        sowTargetTracker = SealOfWisdomTargetTracker.new(),
        socrTargetTracker = SealOfCrusaderTargetTracker.new()
    }
    --- @class SealOfCommandModule 
    return setmetatable(Module.new(ABILITY_SEAL_COMMAND, trackers), SealOfCommandModule)
end

function SealOfCommandModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_RIGHTEOUSNESS)
end

function SealOfCommandModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_COMMAND)
    CastSpellByName(ABILITY_SEAL_COMMAND)
end

--- @param context PaladinModuleRunContext
function SealOfCommandModule:getPriority(context)
    local sowEnabled = ModuleRegistry:IsModuleEnabled(ABILITY_SEAL_WISDOM)
    local socrEnabled = ModuleRegistry:IsModuleEnabled(ABILITY_SEAL_CRUSADER)
    if self.enabled
        and context.mana > context.sorCost 
        and self.trackers.socTracker:ShouldCast()
        and ((sowEnabled and not self.trackers.sowTargetTracker:ShouldCast()) or (socrEnabled and not self.trackers.socrTargetTracker:ShouldCast())) then
        return 80;
    end
    return -1;
end
