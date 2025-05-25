--- @alias SealOfCommandTrackers { socTracker: SealOfCommandTracker }
--- @class SealOfCommandModule : Module
--- @field trackers SealOfCommandTrackers
--- @diagnostic disable: duplicate-set-field
SealOfCommandModule = setmetatable({}, { __index = Module })
SealOfCommandModule.__index = SealOfCommandModule

--- @return SealOfCommandModule
function SealOfCommandModule.new()
    --- @type SealOfCommandTrackers
    local trackers = {
        socTracker = SealOfCommandTracker.new()
    }
    --- @class SealOfCommandModule 
    return setmetatable(Module.new(ABILITY_SEAL_OF_COMMAND, trackers), SealOfCommandModule)
end

function SealOfCommandModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_SEAL_OF_RIGHTEOUSNESS)
end

function SealOfCommandModule:run()
    Logging:Debug("Casting "..ABILITY_SEAL_OF_COMMAND)
    CastSpellByName(ABILITY_SEAL_OF_COMMAND)
end

--- @param context PaladinModuleRunContext
function SealOfCommandModule:getPriority(context)
    if self.enabled and context.mana > context.socCost and self.trackers.socTracker:ShouldCast() then
        return 80;
    end
    return -1;
end
