--- @alias InsectSwarmTrackers { eclipseTracker: EclipseTracker, solsticeTracker: SolsticeTracker, insectSwarmTracker: InsectSwarmTracker }
--- @class InsectSwarmModule : Module
--- @field trackers InsectSwarmTrackers
--- @diagnostic disable: duplicate-set-field
InsectSwarmModule = setmetatable({}, { __index = Module })
InsectSwarmModule.__index = InsectSwarmModule

--- @return InsectSwarmModule
function InsectSwarmModule.new()
    --- @type InsectSwarmTrackers
    local trackers = {
        eclipseTracker = EclipseTracker.GetInstance(),
        solsticeTracker = SolsticeTracker.GetInstance(),
        insectSwarmTracker = InsectSwarmTracker.new()
    }
    --- @class InsectSwarmModule
    return setmetatable(Module.new(Abilities.InsectSwarm.name, trackers, "Interface\\Icons\\Spell_Nature_InsectSwarm"),
        InsectSwarmModule)
end

function InsectSwarmModule:run()
    Logging:Debug("Casting " .. Abilities.InsectSwarm.name)
    CastSpellByName(Abilities.InsectSwarm.name)
end

--- @param context DruidModuleRunContext
function InsectSwarmModule:getPriority(context)
    if not self.enabled or not Helpers:SpellReady(Abilities.InsectSwarm.name) then
        return -1;
    end

    if self.trackers.eclipseTracker:GetEclipseType() == EclipseType.NATURE
        and (self.trackers.eclipseTracker:GetEclipseRemainingTime() <= 1.7
            and self.trackers.insectSwarmTracker:GetRemainingDuration() <= 3.5) then
        return 100;
    end

    if self.trackers.insectSwarmTracker:ShouldCast() then
        return 60;
    end

    return -1;
end
