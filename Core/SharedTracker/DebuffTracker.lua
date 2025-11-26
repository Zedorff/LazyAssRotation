--- @class DebuffTracker : CooldownTracker
--- @field ability Ability
--- @field data table<string, table>
--- @field isUnique boolean
--- @field textureName string|nil
--- @field debuffUp boolean
DebuffTracker = setmetatable({}, { __index = CooldownTracker })
DebuffTracker.__index = DebuffTracker

--- @param ability Ability
--- @param isUnique boolean
--- @param textureName string
function DebuffTracker.new(ability, isUnique, textureName)
    --- @class DebuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DebuffTracker)
    self.ability = ability
    self.data = {}
    self.isUnique = isUnique
    self.textureName = textureName
    self.debuffUp = false
    return self
end

function DebuffTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
    self.debuffUp = false
end

--- @param event string
--- @param arg1 string
function DebuffTracker:onEvent(event, arg1, arg2, arg3, arg4)
    local now = GetTime()
    local _, target = UnitExists("target")

    if self.isUnique then
        if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, self.ability.name) then
            Logging:Debug(self.ability.name .. " is on target")
            self.debuffUp = true
        elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, self.ability.name) then
            if target and string.find(arg1, target) then
                Logging:Debug(self.ability.name .. " is not on target")
                self.debuffUp = false
            end
        elseif event == "PLAYER_TARGET_CHANGED" then
            self.debuffUp = Helpers:HasDebuff("target", self.textureName or "")
        end
    else
        if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] and arg3 == "CAST" and IsMatchingRank(self.ability, tonumber(arg4)) then
            if target then
                self:ApplyDebuff(now, target)
            end
        elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
            self:HandleResist(arg1)
        elseif event == "PLAYER_REGEN_ENABLED" then
            self.data = {}
        end
    end
end

--- @param msg string
function DebuffTracker:HandleResist(msg)
    if msg and string.find(msg, self.ability.name) and (string.find(msg, "resisted") or string.find(msg, "immune") or string.find(msg, "dodged") or string.find(msg, "parried") or string.find(msg, "missed") or string.find(msg, "blocked")) then
        local _, target = UnitExists("target")
        self.data[target] = nil
        Logging:Debug(self.ability.name.." was miss/dodge/parry/miss/resist/blocked")
    end
end

--- @param now number
--- @param mob string | nil
function DebuffTracker:ApplyDebuff(now, mob)
    if not mob then return end
    local duration = Helpers:DebuffDuration(self.ability.name)
    local debuffData = self:GetMobData(mob)

    debuffData.start = now
    debuffData.duration = duration
    Logging:Debug(self.ability.name.." Applied by player, duration: "..tostring(duration))
end

--- @param mob string
--- @return table
function DebuffTracker:GetMobData(mob)
    local debuffData = self.data[mob]
    if not debuffData then
        debuffData = {}
        self.data[mob] = debuffData
    end
    return debuffData
end

--- @return boolean
function DebuffTracker:ShouldCast()
    if self.isUnique then
        return not self.debuffUp and Helpers:SpellReady(self.ability.name)
    end
    
    local remaining = self:GetRemainingOnTarget()
    if not remaining then return true end
    return remaining <= 0 and Helpers:SpellReady(self.ability.name)
end

--- @return number | nil
function DebuffTracker:GetRemainingOnTarget()
    local _, mob = UnitExists("target")
    if not mob then return nil end

    local debuffData = self.data[mob]
    if not debuffData then return 0 end

    local now = GetTime()
    return debuffData.duration - (now - debuffData.start)
end
