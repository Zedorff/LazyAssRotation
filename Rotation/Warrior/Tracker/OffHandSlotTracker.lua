--- @class OffHandSlotTracker : Tracker
--- @field shieldEquipped boolean
OffHandSlotTracker = setmetatable({}, { __index = Tracker })
OffHandSlotTracker.__index = OffHandSlotTracker

--- @type OffHandSlotTracker | nil
local sharedInstance = nil

--- @return OffHandSlotTracker
function OffHandSlotTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end
    --- @class OffHandSlotTracker
    local self = Tracker.new()
    setmetatable(self, OffHandSlotTracker)
    self.shieldEquipped = Helpers:isShieldEquipped()

    sharedInstance = self

    return sharedInstance
end

function OffHandSlotTracker:onEvent(event, arg1)
    if event == "UNIT_INVENTORY_CHANGED" then
        self.shieldEquipped = Helpers:isShieldEquipped()
    end
end

function OffHandSlotTracker:isShieldEquipped()
    return self.shieldEquipped
end

