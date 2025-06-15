--- @alias SealOfWisdomTargeTrackers { sowTargetTracker: SealOfWisdomTargetTracker, sowSelfTracker: SealOfWisdomSelfTracker }
--- @class SealOfWisdomTargetModule : Module
--- @field trackers SealOfWisdomTargeTrackers
--- @diagnostic disable: duplicate-set-field
SealOfWisdomTargetModule = setmetatable({}, { __index = Module })
SealOfWisdomTargetModule.__index = SealOfWisdomTargetModule

--- @return SealOfWisdomTargetModule
function SealOfWisdomTargetModule.new()
    --- @type SealOfWisdomTargeTrackers
    local trackers = {
        sowTargetTracker = SealOfWisdomTargetTracker.new(),
        sowSelfTracker = SealOfWisdomSelfTracker.new()
    }
    --- @class SealOfWisdomTargetModule
    local self = Module.new(Abilities.SealWisdom.name, trackers, "Interface\\Icons\\Spell_Holy_RighteousnessAura")
    setmetatable(self, SealOfWisdomTargetModule)

    if self.enabled then
        ModuleRegistry:DisableModule(Abilities.SealCrusader.name)
    end

    return self
end

function SealOfWisdomTargetModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.SealCrusader.name)
end

function SealOfWisdomTargetModule:run()
    Logging:Debug("Casting "..Abilities.SealWisdom.name)
    CastSpellByName(Abilities.SealWisdom.name)
end

--- @param context PaladinModuleRunContext
function SealOfWisdomTargetModule:getPriority(context)
    if self.enabled and context.mana > context.sowCost and self.trackers.sowTargetTracker:ShouldCast() and self.trackers.sowSelfTracker:ShouldCast() then
        return 85;
    end
    return -1;
end
