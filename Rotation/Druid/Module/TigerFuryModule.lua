--- @alias TigerFuryTrackers { tigerFuryTracker: TigerFuryTracker }
--- @class TigerFuryModule : Module
--- @field trackers TigerFuryTrackers
--- @diagnostic disable: duplicate-set-field
TigerFuryModule = setmetatable({}, { __index = Module })
TigerFuryModule.__index = TigerFuryModule

--- @return TigerFuryModule
function TigerFuryModule.new()
    --- @type TigerFuryTrackers
    local trackers = {
        tigerFuryTracker = TigerFuryTracker.new()
    }
    --- @class TigerFuryModule
    return setmetatable(Module.new(ABILITY_TIGER_FURY, trackers, "Interface\\Icons\\Ability_Mount_JungleTiger"), TigerFuryModule)
end

function TigerFuryModule:run()
    Logging:Debug("Casting "..ABILITY_TIGER_FURY)
    CastSpellByName(ABILITY_TIGER_FURY)
end

--- @param context DruidModuleRunContext
function TigerFuryModule:getPriority(context)
    if self.enabled then
        if self.trackers.tigerFuryTracker:ShouldCast() then
            return 100;
        end
    end
    return -1;
end
