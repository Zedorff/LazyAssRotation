--- @class CurseOfAgonyTracker : WarlockDotTracker
CurseOfAgonyTracker = setmetatable({}, { __index = WarlockDotTracker })
CurseOfAgonyTracker.__index = CurseOfAgonyTracker

--- @type CurseOfAgonyTracker | nil
local sharedInstance = nil

--- With Malediction, another curse (e.g. CoR) can apply alongside CoA; those casts must still refresh this tracker.
--- @return Ability
local function buildRankedAbility()
    if Helpers:PointsInTalent("Malediction") > 0 then
        local ids = Collection.shallowCopy(Abilities.CoA.ids)
        ids = Collection.combine(ids, Abilities.CoR.ids)
        ids = Collection.combine(ids, Abilities.CoE.ids)
        ids = Collection.combine(ids, Abilities.CoW.ids)
        ids = Collection.combine(ids, Abilities.CoS.ids)
        return { name = Abilities.CoA.name, ids = ids }
    end
    return Abilities.CoA
end

--- @return CurseOfAgonyTracker
function CurseOfAgonyTracker.GetInstance()
    local rankedAbility = buildRankedAbility()
    if sharedInstance then
        sharedInstance.rankedAbility = rankedAbility
        return sharedInstance
    end

    --- @class CurseOfAgonyTracker
    local self = WarlockDotTracker.new(rankedAbility)
    setmetatable(self, CurseOfAgonyTracker)

    sharedInstance = self

    return sharedInstance
end
