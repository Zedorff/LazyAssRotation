--- @alias SealOfRighteousnessTrackers { sorTracker: SealOfRighteousnessTracker, sowTargetTracker: SealOfWisdomTargetTracker, socrTargetTracker: SealOfCrusaderTargetTracker }
--- @class SealOfRighteousnessModule : Module
--- @field trackers SealOfRighteousnessTrackers
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessModule = setmetatable({}, { __index = Module })
SealOfRighteousnessModule.__index = SealOfRighteousnessModule

--- @return SealOfRighteousnessModule
function SealOfRighteousnessModule.new()
    --- @type SealOfRighteousnessTrackers
    local trackers = {
        sorTracker = SealOfRighteousnessTracker.new(),
        sowTargetTracker = SealOfWisdomTargetTracker.new(),
        socrTargetTracker = SealOfCrusaderTargetTracker.new()
    }
    --- @class SealOfRighteousnessModule
    local self = Module.new(Abilities.SealRighteousness.name, trackers, "Interface\\Icons\\Ability_ThunderBolt")
    setmetatable(self, SealOfRighteousnessModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.SealCommand.name)
    end

    return self
end

function SealOfRighteousnessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.SealCommand.name)
end

function SealOfRighteousnessModule:run()
    Logging:Debug("Casting " .. Abilities.SealRighteousness.name)
    CastSpellByName(Abilities.SealRighteousness.name)
end

--- @param context PaladinModuleRunContext
function SealOfRighteousnessModule:getPriority(context)
    if not self.enabled or context.mana < context.sorCost then
        return -1;
    end

    if context.spec == PaladinSpec.RETRI then
        return self:GetRetriSealOfRighteousnessPriority(context)
    elseif context.spec == PaladinSpec.PROT then
        return self:GetProtSealOfRighteousnessPriority(context)
    end

    return -1;
end

--- @param context PaladinModuleRunContext
function SealOfRighteousnessModule:GetRetriSealOfRighteousnessPriority(context)
    local sowEnabled = ModuleRegistry:IsModuleEnabled(Abilities.SealWisdom.name)
    local socrEnabled = ModuleRegistry:IsModuleEnabled(Abilities.SealCrusader.name)

    if self.trackers.sorTracker:ShouldCast() and context.mana > context.sorCost then
        if not sowEnabled and not socrEnabled then
            return 80
        end

        if (sowEnabled and not self.trackers.sowTargetTracker:ShouldCast())
            or (socrEnabled and not self.trackers.socrTargetTracker:ShouldCast()) then
            return 80
        end
    end

    return -1
end

--- @param context PaladinModuleRunContext
function SealOfRighteousnessModule:GetProtSealOfRighteousnessPriority(context)
    local sowEnabled = ModuleRegistry:IsModuleEnabled(Abilities.SealWisdom.name)
    if context.mana > context.sorCost then
        if sowEnabled and not self.trackers.sowTargetTracker:ShouldCast() and self.trackers.sorTracker:ShouldCast() then
            return 80;
        elseif not sowEnabled and self.trackers.sorTracker:ShouldCast() then
            return 80;
        end
    end
    return -1;
end
