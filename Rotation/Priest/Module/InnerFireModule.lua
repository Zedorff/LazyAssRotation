--- @alias InnerFireTrackers { innerFireTracker: InnerFireTracker }
--- @class InnerFireModule : Module
--- @field trackers InnerFireTrackers
--- @diagnostic disable: duplicate-set-field
InnerFireModule = setmetatable({}, { __index = Module })
InnerFireModule.__index = InnerFireModule

--- @return InnerFireModule
function InnerFireModule.new()
    --- @type InnerFireTrackers
    local trackers = {
        innerFireTracker = InnerFireTracker.new()
    }
    --- @class InnerFireModule
    return setmetatable(Module.new(Abilities.InnerFire.name, trackers, "Interface\\Icons\\Spell_Holy_InnerFire"), InnerFireModule)
end

function InnerFireModule:run()
    Logging:Debug("Casting "..Abilities.InnerFire.name)
    CastSpellByName(Abilities.InnerFire.name)
end

--- @param context PriestModuleRunContext
function InnerFireModule:getPriority(context)
    local hasMana = context.mana > context.innerFireCost
    if not self.enabled or not hasMana then
        return -1;
    end

    if self.trackers.innerFireTracker:ShouldCast() and Helpers:SpellReady(Abilities.InnerFire.name) then
        return 95;
    end

    return -1;
end
