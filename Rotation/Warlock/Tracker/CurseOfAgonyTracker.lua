--- @class CurseOfAgonyTracker : WarlockDotTracker
CurseOfAgonyTracker = setmetatable({}, { __index = WarlockDotTracker })
CurseOfAgonyTracker.__index = CurseOfAgonyTracker

--- @param allowAgonyWithOtherCurses boolean
--- @return CurseOfAgonyTracker
function CurseOfAgonyTracker.new(allowAgonyWithOtherCurses)
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
    return self
end
