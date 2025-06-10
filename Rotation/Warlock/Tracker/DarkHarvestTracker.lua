---@class DarkHarvestTracker : CooldownTracker
---@field channelingUntil number
---@field pendingChannel boolean
---@field channelDuration number
DarkHarvestTracker = setmetatable({}, { __index = CooldownTracker })
DarkHarvestTracker.__index = DarkHarvestTracker

local ABILITY_DARK_HARVEST = "Dark Harvest"
local HASTE_MULTIPLIER = 0.7 -- 30% faster ticks ⇒ 70% duration

---@return DarkHarvestTracker
function DarkHarvestTracker.new()
    ---@class DarkHarvestTracker
    local self = CooldownTracker.new()
    setmetatable(self, DarkHarvestTracker)

    self.channelingUntil = 0
    self.pendingChannel = false
    self.channelDuration = 0
    return self
end

function DarkHarvestTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.channelingUntil = 0
    self.pendingChannel = false
    self.channelDuration = 0
end

---@param event string
---@param arg1 any
function DarkHarvestTracker:onEvent(event, arg1)
    local now = GetTime()

    if event == "PLAYER_DEAD" then
        self.channelingUntil = 0
        self.pendingChannel = false
        self.channelDuration = 0

    elseif event == "LAR_SPELL_CAST" and arg1 == ABILITY_DARK_HARVEST then
        self.pendingChannel = true

    elseif event == "SPELLCAST_CHANNEL_START" and self.pendingChannel then
        local durationSec = (arg1 or 0) / 1000
        self.channelingUntil = now + durationSec
        self.channelDuration = durationSec
        self.pendingChannel = false
        Core.eventBus:notify("LAR_DH_CHANNEL_START")
        Logging:Debug("Dark Harvest channel started (" .. durationSec .. "s)")

    elseif event == "SPELLCAST_CHANNEL_STOP"
        or event == "SPELLCAST_INTERRUPTED" then
        self.channelingUntil = 0
        self.pendingChannel = false
        Core.eventBus:notify("LAR_DH_CHANNEL_STOP")
        Logging:Debug("Dark Harvest channel stopped / interrupted")
    end
end

--- Check if DH is currently channeling
---@return boolean
function DarkHarvestTracker:IsActive()
    return GetTime() < self.channelingUntil
end

--- Used in DotTracker's durationFn
---@param mobName string
---@return number multiplier, number activeDuration
function DarkHarvestTracker:GetHasteInfo(mobName)
    if UnitName("target") == mobName and self:IsActive() then
        return HASTE_MULTIPLIER, math.max(0, self.channelingUntil - GetTime())
    end
    return 1.0, 0
end
