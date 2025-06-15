--- @alias SealOfCrusaderTrackers { socrTargetTracker: SealOfCrusaderTargetTracker, socrSelfTracker: SealOfCrusaderSelfTracker }
--- @class SealOfCrusaderTargetModule : Module
--- @field trackers SealOfCrusaderTrackers
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderTargetModule = setmetatable({}, { __index = Module })
SealOfCrusaderTargetModule.__index = SealOfCrusaderTargetModule

--- @return SealOfCrusaderTargetModule
function SealOfCrusaderTargetModule.new()
    --- @type SealOfCrusaderTrackers
    local trackers = {
        socrTargetTracker = SealOfCrusaderTargetTracker.new(),
        socrSelfTracker = SealOfCrusaderSelfTracker.new()
    }
    --- @class SealOfCrusaderTargetModule
    local self = Module.new(Abilities.SealCrusader.name, trackers, "Interface\\Icons\\Spell_Holy_HolySmite")
    setmetatable(self, SealOfCrusaderTargetModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.SealWisdom.name)
    end

    return self
end

function SealOfCrusaderTargetModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.SealWisdom.name)
end

function SealOfCrusaderTargetModule:run()
    Logging:Debug("Casting " .. Abilities.SealCrusader.name)
    CastSpellByName(Abilities.SealCrusader.name)
end

--- @param context PaladinModuleRunContext
function SealOfCrusaderTargetModule:getPriority(context)
    if self.enabled and context.mana > context.socrCost and self.trackers.socrTargetTracker:ShouldCast() and self.trackers.socrSelfTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
