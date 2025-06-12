--- @class DotTracker : CooldownTracker
--- @field ability string
--- @field spellId integer
--- @field data table<string, table>
DotTracker = setmetatable({}, { __index = CooldownTracker })
DotTracker.__index = DotTracker

--- @param spellId integer
--- @param ability string
--- @return DotTracker
function DotTracker.new(spellId, ability)
    --- @class DotTracker
    local self = CooldownTracker.new()
    setmetatable(self, DotTracker)

    self.ability = ability
    self.spellId = spellId
    self.data    = {}

    return self
end

function DotTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

--- @param event string
--- @param arg1 string
function DotTracker:onEvent(event, arg1, arg2, arg3, arg4)
    local now = GetTime()
    local _, target = UnitExists("target")

    if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] and arg3 == "CAST" and arg4 == self.spellId then
        self:ApplyDot(now, target)
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        self:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.data = {}
    end
end

--- @param now number
--- @param mob string | nil
function DotTracker:ApplyDot(now, mob)
    if not mob then return end

    local duration   = Helpers:SpellDuration(self.ability)

    local dotData    = self:GetMobData(mob)
    dotData.start    = now
    dotData.duration = duration
    Logging:Debug(self.ability.." Applied, duration: "..duration)
end

--- @param msg string
function DotTracker:HandleResist(msg)
    if msg and string.find(msg, self.ability) and (string.find(msg, "resisted") or string.find(msg, "immune") or string.find(msg, "dodged") or string.find(msg, "parried") or string.find(msg, "missed")) or string.find(msg, "blocked") then
        local _, target = UnitExists("target")
        self.data[target] = nil
        Logging:Debug(self.ability.." was miss/dodge/parry/miss/resist/blocked")
    end
end

--- @return boolean
function DotTracker:ShouldCast()
    local _, mob = UnitExists("target")
    if not mob then return false end

    local dotData = self.data[mob]
    if not dotData then return true end

    local now = GetTime()
    local remaining = dotData.duration - (now - dotData.start)
    return remaining <= 0 and Helpers:SpellReady(self.ability)
end

--- @return number
function DotTracker:GetRemainingDuration()
    local _, mob = UnitExists("target")
    if not mob then return 0 end

    local dotData = self.data[mob]
    if not dotData then return 0 end

    local now = GetTime()
    return dotData.duration - (now - dotData.start)
end

--- @param mob string
--- @return table
function DotTracker:GetMobData(mob)
    local dotData = self.data[mob]
    if not dotData then
        dotData = {}
        self.data[mob] = dotData
    end
    return dotData
end
