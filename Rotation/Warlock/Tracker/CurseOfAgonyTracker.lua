--- @class CurseOfAgonyTracker : DotTracker
CurseOfAgonyTracker = setmetatable({}, { __index = DotTracker })
CurseOfAgonyTracker.__index = CurseOfAgonyTracker

--- @return CurseOfAgonyTracker
function CurseOfAgonyTracker.new()
    --- @class CurseOfAgonyTracker
    local self = DotTracker.new(ABILITY_COA, 24)
    setmetatable(self, CurseOfAgonyTracker)
    return self
end
