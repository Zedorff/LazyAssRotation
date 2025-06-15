--- @class WarlockDotTracker : CooldownTracker
--- @field rankedAbility RankedAbility
--- @field pendingChannel boolean
--- @field dhCasting boolean
--- @field data table<string, table>
WarlockDotTracker = setmetatable({}, { __index = CooldownTracker })
WarlockDotTracker.__index = WarlockDotTracker

local HASTE_FACTOR = 0.30

--- @param rankedAbility RankedAbility
--- @return WarlockDotTracker
function WarlockDotTracker.new(rankedAbility)
    --- @class WarlockDotTracker
    local self = CooldownTracker.new()
    setmetatable(self, WarlockDotTracker)

    self.rankedAbility  = rankedAbility
    self.data           = {}
    self.pendingChannel = false
    self.dhCasting      = false

    return self
end

function WarlockDotTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.data           = {}
    self.pendingChannel = false
    self.dhCasting      = false
end

--- @param event string
--- @param arg1 string
function WarlockDotTracker:onEvent(event, arg1, _, arg3, arg4)
    local now = GetTime()
    local _, target = UnitExists("target")

    if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] then
        if arg3 == "CAST" and IsMatchingRank(self.rankedAbility, tonumber(arg4)) then
            self:ApplyDot(now, target)
        elseif arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
            self.pendingChannel = true
        end
    elseif event == "SPELLCAST_CHANNEL_START" and self.pendingChannel then
        self.dhCasting = true
        self.pendingChannel = false
        self:StartDarkHarvest(target, now)
        Logging:Debug("Dark Harvest channel started (" .. (arg1 or 0) / 1000 .. "s)")
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if self.dhCasting then
            self.dhCasting = false
            self.pendingChannel = false
            self:EndDarkHarvest(target, now)
            Logging:Debug("Dark Harvest channel stopped / interrupted")
        end
    elseif event == "PLAYER_DEAD" then
        self.pendingChannel = false
        self.dhCasting = false
    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:RecordTick(arg1, now)
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        self:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.data = {}
    end
end

--- @param now number
--- @param mob string | nil
function WarlockDotTracker:ApplyDot(now, mob)
    if not mob then return end

    local duration      = Helpers:SpellDuration(self.rankedAbility.name)

    local dotData       = self:GetMobData(mob)
    dotData.start       = now
    dotData.duration    = duration
    dotData.lastTick    = nil
    dotData.dhStartTime = nil
    dotData.dhEndTime   = nil
    Logging:Debug("Apply dot: " .. self.rankedAbility.name .. ", withDuration: " .. duration)
end

--- @param msg string
--- @param now number
function WarlockDotTracker:RecordTick(msg, now)
    local mob = string.match(msg, "^(.-) suffers %d+ .- from your " .. self.rankedAbility.name)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData then return end

    dotData.lastTick = now
    Logging:Debug("Tick recorded: " .. self.rankedAbility.name .. ", after : " .. (dotData.start - now) .. "s")
end

--- @param mob string | nil
--- @param now number
function WarlockDotTracker:StartDarkHarvest(mob, now)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData then return end

    if not dotData.dhStartTime then
        dotData.dhStartTime = dotData.lastTick or now
        dotData.dhEndTime   = nil
    end
    Logging:Debug("Dark Harvest started for: " .. self.rankedAbility.name)
end

--- @param mob string | nil
--- @param now number
function WarlockDotTracker:EndDarkHarvest(mob, now)
    if not mob then return end

    local dotData = self.data[mob]
    if not dotData or not dotData.dhStartTime then return end

    if not dotData.dhEndTime then
        dotData.dhEndTime = now
    end
    Logging:Debug("Dark Harvest stopped for: " .. self.rankedAbility.name)
end

--- @param msg string
function WarlockDotTracker:HandleResist(msg)
    if msg and string.find(msg, self.rankedAbility.name) and (string.find(msg, "resisted") or string.find(msg, "immune") or string.find(msg, "dodged") or string.find(msg, "parried") or string.find(msg, "missed")) or string.find(msg, "blocked") then
        local _, target = UnitExists("target")
        self.data[target] = nil
        Logging:Debug(self.rankedAbility.name .. " was miss/dodge/parry/miss/resist/blocked")
    end
end

--- @return boolean
function WarlockDotTracker:ShouldCast()
    local remaining = self:GetRemainingOnTarget()
    if not remaining then return true end
    return remaining <= 0 and Helpers:SpellReady(self.rankedAbility.name)
end

--- @return number
function WarlockDotTracker:GetRemainingDuration()
    return self:GetRemainingOnTarget() or 0
end

--- @return number | nil
function WarlockDotTracker:GetRemainingOnTarget()
    local _, mob = UnitExists("target")
    if not mob then return nil end

    local dotData = self.data[mob]
    if not dotData then return 0 end

    local now = GetTime()
    local dhReduction = 0
    if dotData.dhStartTime then
        local dhEnd = dotData.dhEndTime or now
        local dhActiveDuration = dhEnd - dotData.dhStartTime
        if dhActiveDuration > 0 then
            dhReduction = dhActiveDuration * HASTE_FACTOR
        end
    end

    return dotData.duration - (now - dotData.start) - dhReduction
end

--- @param mob string
--- @return table
function WarlockDotTracker:GetMobData(mob)
    local dotData = self.data[mob]
    if not dotData then
        dotData = {}
        self.data[mob] = dotData
    end
    return dotData
end
