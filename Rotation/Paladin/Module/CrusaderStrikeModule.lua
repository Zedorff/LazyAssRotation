--- @alias CrusaderStrikeTrackers { zealTracker: CrusaderStrikeTracker }
--- @class CrusaderStrikeModule : Module
--- @field trackers CrusaderStrikeTrackers
--- @diagnostic disable: duplicate-set-field
CrusaderStrikeModule = setmetatable({}, { __index = Module })
CrusaderStrikeModule.__index = CrusaderStrikeModule

--- @return CrusaderStrikeModule
function CrusaderStrikeModule.new()
    --- @type CrusaderStrikeTrackers
    local trackers = {
        zealTracker = CrusaderStrikeTracker.new()
    }
    --- @class CrusaderStrikeModule
    return setmetatable(Module.new(Abilities.CrusaderStrike.name, trackers, "Interface\\Icons\\Spell_Holy_CrusaderStrike"), CrusaderStrikeModule)
end

function CrusaderStrikeModule:run()
    Logging:Debug("Casting " .. Abilities.CrusaderStrike.name)
    CastSpellByName(Abilities.CrusaderStrike.name)
end

--- @param context PaladinModuleRunContext
function CrusaderStrikeModule:getPriority(context)
    if not self.enabled or context.mana < context.crusaderCost or not Helpers:SpellReady(Abilities.CrusaderStrike.name) then
        return -1
    end

    local sor = ModuleRegistry:IsModuleEnabled(Abilities.SealRighteousness.name)
    local soc = ModuleRegistry:IsModuleEnabled(Abilities.SealCommand.name)
    local shouldCast = self.trackers.zealTracker:ShouldCast()

    if sor then
        return shouldCast and 75 or 50
    elseif soc then
        return shouldCast and 70 or 50
    end

    return -1
end
