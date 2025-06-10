--- @alias ShamanClearcastingTrackers { clearcastingTracker: ClearcastingTracker }
--- @class ShamanClearcastingModule : Module
--- @field trackers ShamanClearcastingTrackers
--- @diagnostic disable: duplicate-set-field
ShamanClearcastingModule = setmetatable({}, { __index = Module })
ShamanClearcastingModule.__index = ShamanClearcastingModule

--- @return ShamanClearcastingModule
function ShamanClearcastingModule.new()
    --- @type ShamanClearcastingTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class ShamanClearcastingModule
    return setmetatable(Module.new(PASSIVE_CLEARCASTING, trackers, "Interface\\Icons\\Spell_Shadow_ManaBurn"), ShamanClearcastingModule)
end

function ShamanClearcastingModule:run()
    Logging:Debug("Casting clearcast"..ABILITY_CHAIN_LIGHTNING)
    CastSpellByName(ABILITY_CHAIN_LIGHTNING)
end

--- @param context ShamanModuleRunContext
function ShamanClearcastingModule:getPriority(context)
    if self.enabled and self.trackers.clearcastingTracker:ShouldCast() and Helpers:SpellReady(ABILITY_CHAIN_LIGHTNING) then
        local cost = math.floor(context.clCost * 0.33)
        if context.mana > cost then
            return 100;
        end
    end
    return -1;
end
