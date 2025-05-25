--- @alias SealOfRighteousnessTrackers { sorTracker: SealOfRighteousnessTracker }
--- @class SealOfRighteousnessModule : Module
--- @field trackers SealOfRighteousnessTrackers
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessModule = setmetatable({}, { __index = Module })
SealOfRighteousnessModule.__index = SealOfRighteousnessModule

--- @return SealOfRighteousnessModule
function SealOfRighteousnessModule.new()
    --- @type SealOfRighteousnessTrackers
    local trackers = {
        sorTracker = SealOfRighteousnessTracker.new()
    }
    --- @class SealOfRighteousnessModule
    local self = Module.new(ABILITY_SEAL_OF_RIGHTEOUSNESS, trackers)
    setmetatable(self, SealOfRighteousnessModule)

    if self.enabled then
        ModuleRegistry:DisableModule(ABILITY_SEAL_OF_COMMAND)
    end

    return self
end

function SealOfRighteousnessModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_COMMAND)
end

function SealOfRighteousnessModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_RIGHTEOUSNESS)
    CastSpellByName(ABILITY_SEAL_OF_RIGHTEOUSNESS)
end

--- @param context PaladinModuleRunContext
function SealOfRighteousnessModule:getPriority(context)
    if self.enabled and context.mana > context.sorCost and self.trackers.sorTracker:ShouldCast() then
        return 80;
    end
    return -1;
end
