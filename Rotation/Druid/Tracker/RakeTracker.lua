--- @class RakeTracker : CooldownTracker
--- @field rakeUpUntill number
--- @diagnostic disable: duplicate-set-field
RakeTracker = setmetatable({}, { __index = CooldownTracker })
RakeTracker.__index = RakeTracker

local RAKE_DURATION = 9

local haveSavageryIdol = false
local haveRavagerCloak = false

--- @return RakeTracker
function RakeTracker.new()
    --- @class RakeTracker
    local self = CooldownTracker.new()
    setmetatable(self, RakeTracker)
    self.rakeUpUntill = 0
    self:CheckGear()
    return self
end

function RakeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.rakeUpUntill = 0
    self:CheckGear()
end

--- @param event string
--- @param arg1 string
function RakeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, ABILITY_RAKE) then
        local hit, crit, _, _, _ = Helpers:ParseCombatEvent(ABILITY_RAKE, arg1)
        if hit or crit then
            Logging:Debug(ABILITY_RAKE .. " is up")
            self.rakeUpUntill = GetTime() + self:CalculateRakeDuration()
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.rakeUpUntill = 0
    elseif event == "UNIT_INVENTORY_CHANGED" then
        self:CheckGear()
    end
end

--- @return boolean
function RakeTracker:ShouldCast()
    return self.rakeUpUntill < GetTime()
end

function RakeTracker:CheckGear()
    haveSavageryIdol = string.find(GetInventoryItemLink("player", 18), "item:61699:")
    haveRavagerCloak = string.find(GetInventoryItemLink("player", 15), "item:55095:")
end

function RakeTracker:CalculateRakeDuration()
    local tickMultiplier = 1
    if haveRavagerCloak then
        tickMultiplier = tickMultiplier - 0.05
    end
    if haveSavageryIdol then
        tickMultiplier = tickMultiplier - 0.1
    end

    return RAKE_DURATION * tickMultiplier
end
