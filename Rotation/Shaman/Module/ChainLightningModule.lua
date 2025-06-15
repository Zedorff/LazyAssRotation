--- @alias ChainLightningTrackers { clearcastingTracker: ClearcastingTracker }
--- @class ChainLightningModule : Module
--- @field trackers ChainLightningTrackers
--- @diagnostic disable: duplicate-set-field
ChainLightningModule = setmetatable({}, { __index = Module })
ChainLightningModule.__index = ChainLightningModule

--- @return ChainLightningModule
function ChainLightningModule.new()
    --- @type ChainLightningTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class ChainLightningModule
    return setmetatable(Module.new(Abilities.ChainLightning.name, trackers, "Interface\\Icons\\Spell_Nature_ChainLightning"), ChainLightningModule)
end

function ChainLightningModule:run()
    Logging:Debug("Casting "..Abilities.ChainLightning.name)
    CastSpellByName(Abilities.ChainLightning.name)
end

--- @param context ShamanModuleRunContext
function ChainLightningModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.ChainLightning.name) then
        local cost = self.trackers.clearcastingTracker:ShouldCast() and math.floor(context.clCost * 0.33) or context.clCost
        if context.mana > cost then
            if ModuleRegistry:IsModuleEnabled(PASSIVE_CLEARCASTING) then
                return 70
            else
                return 90
            end
        end
    end
    return -1;
end
