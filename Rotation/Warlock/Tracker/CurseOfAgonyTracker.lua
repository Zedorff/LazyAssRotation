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

    local curses = {}
    if allowAgonyWithOtherCurses then
        table.insert(curses, 11722) --- CoE
        table.insert(curses, 11713) --- CoA
        table.insert(curses, 17937) --- CoS
        table.insert(curses, 702) --- CoW
        table.insert(curses, 11717) --- CoR
    end

    local joined = table.concat(curses, ", ")

    --- @class CurseOfAgonyTracker
    local self = WarlockDotTracker.new(joined, ABILITY_COA)
    setmetatable(self, CurseOfAgonyTracker)

    sharedInstance = self

    return sharedInstance
end
