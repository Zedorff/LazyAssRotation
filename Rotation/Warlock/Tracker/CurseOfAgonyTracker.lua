--- @class CurseOfAgonyTracker : WarlockDotTracker
CurseOfAgonyTracker = setmetatable({}, { __index = WarlockDotTracker })
CurseOfAgonyTracker.__index = CurseOfAgonyTracker

--- @type CurseOfAgonyTracker | nil
local sharedInstance = nil

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfAgonyTracker
function CurseOfAgonyTracker.GetInstance(allowAgonyWithOtherCurses)
    -- if sharedInstance then
        -- return sharedInstance
    -- end

    local curses = {}
    if allowAgonyWithOtherCurses then
        table.insert(curses, ABILITY_COE)
        table.insert(curses, ABILITY_COA)
        table.insert(curses, ABILITY_COS)
        table.insert(curses, ABILITY_COW)
        table.insert(curses, ABILITY_COR)
    end

    local joined = table.concat(curses, ", ")

    --- @class CurseOfAgonyTracker
    local self = WarlockDotTracker.new(joined, ABILITY_COA)
    setmetatable(self, CurseOfAgonyTracker)

    sharedInstance = self

    return sharedInstance
end
