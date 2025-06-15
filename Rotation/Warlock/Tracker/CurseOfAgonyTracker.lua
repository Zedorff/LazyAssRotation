--- @class CurseOfAgonyTracker : WarlockDotTracker
CurseOfAgonyTracker = setmetatable({}, { __index = WarlockDotTracker })
CurseOfAgonyTracker.__index = CurseOfAgonyTracker

--- @type CurseOfAgonyTracker | nil
local sharedInstance = nil

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfAgonyTracker
function CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    if sharedInstance then
        return sharedInstance
    end

    local rankedAbility = Abilities.CoA

    if allowAgonyWithOtherCurses then
        local ids = Collection.shallowCopy(Abilities.CoA.ids)
        Collection.combine(ids, Abilities.CoR.ids)
        Collection.combine(ids, Abilities.CoE.ids)
        Collection.combine(ids, Abilities.CoW.ids)
        Collection.combine(ids, Abilities.CoS.ids)
        rankedAbility = { name = Abilities.CoA.name, ids = ids }
    end

    --- @class CurseOfAgonyTracker
    local self = WarlockDotTracker.new(rankedAbility)
    setmetatable(self, CurseOfAgonyTracker)

    sharedInstance = self

    return sharedInstance
end
