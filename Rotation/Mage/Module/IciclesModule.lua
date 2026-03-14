--- @alias IciclesTrackers { flashFreezeTracker: FlashFreezeTracker, castingTracker: CastingTracker }
--- @class IciclesModule : Module
--- @field trackers IciclesTrackers
--- @diagnostic disable: duplicate-set-field
IciclesModule = setmetatable({}, { __index = Module })
IciclesModule.__index = IciclesModule

--- @return IciclesModule
function IciclesModule.new()
    --- @type IciclesTrackers
    local trackers = {
        flashFreezeTracker = FlashFreezeTracker.new(),
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class IciclesModule
    return setmetatable(Module.new(Abilities.Icicles.name, trackers, "Interface\\Icons\\Spell_Frost_FrostBlast"), IciclesModule)
end

function IciclesModule:run()
    Logging:Debug("Casting "..Abilities.Icicles.name)
    CastSpellByName(Abilities.Icicles.name)
end

--- @param context MageModuleRunContext
function IciclesModule:getPriority(context)
    if not self.enabled or not self.trackers.castingTracker:ShouldCast() then
        return -1
    end

    local hasMana = context.mana >= context.iciclesCost
    if not hasMana then
        return -1
    end

    if self.trackers.flashFreezeTracker:ShouldCast() and Helpers:SpellReady(Abilities.Icicles.name) then
        return 100
    end

    if Helpers:SpellReady(Abilities.Icicles.name) then
        return 90
    end

    return -1
end
