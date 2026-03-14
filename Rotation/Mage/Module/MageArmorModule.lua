--- @alias MageArmorTrackers { mageArmorTracker: MageArmorTracker }
--- @class MageArmorModule : Module
--- @field trackers MageArmorTrackers
--- @diagnostic disable: duplicate-set-field
MageArmorModule = setmetatable({}, { __index = Module })
MageArmorModule.__index = MageArmorModule

--- @return MageArmorModule
function MageArmorModule.new()
    --- @type MageArmorTrackers
    local trackers = {
        mageArmorTracker = MageArmorTracker.new()
    }
    --- @class MageArmorModule
    return setmetatable(Module.new(Abilities.MageArmor.name, trackers, "Interface\\Icons\\Spell_MageArmor"), MageArmorModule)
end

function MageArmorModule:run()
    Logging:Debug("Casting "..Abilities.MageArmor.name)
    CastSpellByName(Abilities.MageArmor.name)
end

--- @param context MageModuleRunContext
function MageArmorModule:getPriority(context)
    local hasMana = context.mana >= context.mageArmorCost
    if not self.enabled or not hasMana then
        return -1
    end

    if self.trackers.mageArmorTracker:ShouldCast() and Helpers:SpellReady(Abilities.MageArmor.name) then
        return 100
    end

    return -1
end
