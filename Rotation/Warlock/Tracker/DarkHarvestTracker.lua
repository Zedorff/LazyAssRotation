---@class DarkHarvestTracker : CooldownTracker
---@field pendingChannel boolean
---@field dhCasting boolean
DarkHarvestTracker = setmetatable({}, { __index = CooldownTracker })
DarkHarvestTracker.__index = DarkHarvestTracker

---@return DarkHarvestTracker
function DarkHarvestTracker.new()
    ---@class DarkHarvestTracker
    local self = CooldownTracker.new()
    setmetatable(self, DarkHarvestTracker)

    self.pendingChannel = false
    self.dhCasting = false
    return self
end

function DarkHarvestTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.pendingChannel = false
    self.dhCasting = false
end

---@param event string
---@param arg1 any
function DarkHarvestTracker:onEvent(event, arg1)
    local now = GetTime()

    if event == "PLAYER_DEAD" then
        self.pendingChannel = false
        self.dhCasting = false

    elseif event == "LAR_SPELL_CAST" and arg1 == ABILITY_DARK_HARVEST then
        self.pendingChannel = true

    elseif event == "SPELLCAST_CHANNEL_START" and self.pendingChannel then
        self.dhCasting = true
        self.pendingChannel = false
        Core.eventBus:notify("LAR_DH_CHANNEL_START")
        Logging:Debug("Dark Harvest channel started (" .. (arg1 or 0) / 1000 .. "s)")

    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if self.dhCasting then
            self.dhCasting = false
            self.pendingChannel = false
            Core.eventBus:notify("LAR_DH_CHANNEL_STOP")
            Logging:Debug("Dark Harvest channel stopped / interrupted")
        end
    end
end

---@return boolean
function DarkHarvestTracker:ShouldCast()
    return false
end
