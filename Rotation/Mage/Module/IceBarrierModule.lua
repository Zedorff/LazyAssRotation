--- @alias IceBarrierTrackers { iceBarrierTracker: IceBarrierTracker }
--- @class IceBarrierModule : Module
--- @field trackers IceBarrierTrackers
--- @diagnostic disable: duplicate-set-field
IceBarrierModule = setmetatable({}, { __index = Module })
IceBarrierModule.__index = IceBarrierModule

--- @return IceBarrierModule
function IceBarrierModule.new()
    --- @type IceBarrierTrackers
    local trackers = {
        iceBarrierTracker = IceBarrierTracker.new()
    }
    --- @class IceBarrierModule
    return setmetatable(Module.new(Abilities.IceBarrier.name, trackers, "Interface\\Icons\\Spell_Ice_Lament"), IceBarrierModule)
end

function IceBarrierModule:run()
    Logging:Debug("Casting "..Abilities.IceBarrier.name)
    CastSpellByName(Abilities.IceBarrier.name)
end

--- @param context MageModuleRunContext
function IceBarrierModule:getPriority(context)
    local hasMana = context.mana >= context.iceBarrierCost
    if not self.enabled or not hasMana then
        return -1
    end

    if self.trackers.iceBarrierTracker:ShouldCast() and Helpers:SpellReady(Abilities.IceBarrier.name) then
        return 95
    end

    return -1
end
