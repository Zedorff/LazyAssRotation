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
    return setmetatable(Module.new(Abilities.SealCommand.name, trackers, "Interface\\Icons\\Ability_Warrior_InnerRage"), SealOfCommandModule)
end

function SealOfCommandModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.SealRighteousness.name)
end

function SealOfCommandModule:run()
    Logging:Debug("Casting "..Abilities.SealCommand.name)
    CastSpellByName(Abilities.SealCommand.name)
end

--- @param context PaladinModuleRunContext
function SealOfCommandModule:getPriority(context)
    local sowEnabled = ModuleRegistry:IsModuleEnabled(Abilities.SealWisdom.name)
    local socrEnabled = ModuleRegistry:IsModuleEnabled(Abilities.SealCrusader.name)

    if self.trackers.socTracker:ShouldCast() and context.mana > context.socCost then
        if not sowEnabled and not socrEnabled then
            return 80
        end

        if (sowEnabled and not self.trackers.sowTargetTracker:ShouldCast())
            or (socrEnabled and not self.trackers.socrTargetTracker:ShouldCast()) then
            return 80
        end
    end

    return -1;
end
