--- @class ActionBarSlotTracker : Tracker
ActionBarSlotTracker = setmetatable({}, { __index = Tracker })
ActionBarSlotTracker.__index = ActionBarSlotTracker

local NUM_ACTIONBAR_SLOTS = 120 -- adjust if needed for your version

--- @type ActionBarSlotTracker | nil
local sharedInstance = nil

--- @return ActionBarSlotTracker
function ActionBarSlotTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end
    --- @class ActionBarSlotTracker
    local self = Tracker.new()
    setmetatable(self, ActionBarSlotTracker)
    self.slotCache = {}

    sharedInstance = self

    return sharedInstance
end

function ActionBarSlotTracker:onEvent(event, arg1)
    if event == "ACTIONBAR_SLOT_CHANGED" then
        local slotId = arg1
        for spellName, cachedSlot in pairs(self.slotCache) do
            if cachedSlot == slotId then
                self.slotCache[spellName] = nil
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self.slotCache = {}
    end
end

--- @param spellName string
--- @return integer | nil
function ActionBarSlotTracker:GetActionBarSlot(spellName)
    local cached = self.slotCache[spellName]
    if cached then
        return cached
    end
    local spellTexture = nil
    local i = 1
    while true do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if not name then break end
        if name == spellName then
            spellTexture = GetSpellTexture(i, BOOKTYPE_SPELL)
            break
        end
        i = i + 1
    end
    if not spellTexture then
        return nil
    end
    for slot = 1, NUM_ACTIONBAR_SLOTS do
        local actionTexture = GetActionTexture(slot)
        if actionTexture and actionTexture == spellTexture then
            self.slotCache[spellName] = slot
            return slot
        end
    end
    return nil
end
