--- @alias LightningBoltTrackers { clearcastingTracker: ClearcastingTracker }
--- @class LightningBoltModule : Module
--- @field trackers LightningBoltTrackers
--- @diagnostic disable: duplicate-set-field
LightningBoltModule = setmetatable({}, { __index = Module })
LightningBoltModule.__index = LightningBoltModule

--- @return LightningBoltModule
function LightningBoltModule.new()
    --- @type LightningBoltTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class LightningBoltModule
    return setmetatable(Module.new(Abilities.LightningBolt.name, trackers, "Interface\\Icons\\Spell_Nature_Lightning"), LightningBoltModule)
end

function LightningBoltModule:run()
    Logging:Debug("Casting "..Abilities.LightningBolt.name)
    CastSpellByName(Abilities.LightningBolt.name)
end

--- @param context ShamanModuleRunContext
function LightningBoltModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.LightningBolt.name) then
        local cost = self.trackers.clearcastingTracker:ShouldCast() and math.floor(context.lbCost * 0.33) or context.lbCost
        if context.mana > cost then
            return 80;
        end
    end
    return -1;
end
