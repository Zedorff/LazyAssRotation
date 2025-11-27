---@class MobDebuffState
---@field mobGuid string
---@field start number
---@field duration number

---@class DebuffTracker : CooldownTracker
---@field ability Ability
---@field data table<string, MobDebuffState>
---@field isSharedDebuff boolean
---@field textureName string|nil
DebuffTracker = setmetatable({}, { __index = CooldownTracker })
DebuffTracker.__index = DebuffTracker

function DebuffTracker.new(ability, isSharedDebuff, textureName)
    ---@class DebuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DebuffTracker)

    self.ability     = ability
    self.data        = {}
    self.isSharedDebuff    = isSharedDebuff or false
    self.textureName = textureName

    return self
end

function DebuffTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

function DebuffTracker:onEvent(event, arg1, arg2, arg3, arg4)
    local now = GetTime()

    if event == "UNIT_CASTEVENT" then
        self:OnUnitCastEvent(now, arg1, arg2, arg3, arg4)
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE"
        or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        self:HandleResist(arg1)

    elseif event == "PLAYER_REGEN_ENABLED" then
        self.data = {}
    end
end

function DebuffTracker:OnUnitCastEvent(now, casterGuid, targetGuid, eventType, spellId)
    if eventType ~= "CAST" then return end
    if not IsMatchingRank(self.ability, tonumber(spellId)) then return end

    local _, playerGuid = UnitExists("player")
    if (not self.isSharedDebuff) and (casterGuid ~= playerGuid) then return end

    local mobGuid = targetGuid or ({ UnitExists("target") })[2]
    if not mobGuid then return end

    self:ApplyDebuff(now, mobGuid)
end

function DebuffTracker:GetMobState(mobGuid)
    local state = self.data[mobGuid]
    if not state then
        ---@type MobDebuffState
        state = { mobGuid = mobGuid, start = 0, duration = 0 }
        self.data[mobGuid] = state
    end
    return state
end

function DebuffTracker:ApplyDebuff(now, mobGuid)
    local duration = Helpers:DebuffDuration(self.ability.name)
    local state = self:GetMobState(mobGuid)

    state.start = now
    state.duration = duration

    Logging:Debug(self.ability.name ..
        " applied on " .. mobGuid .. " duration=" .. tostring(duration))
end

function DebuffTracker:ClearDebuff(mobGuid)
    if not mobGuid then return end
    local state = self.data[mobGuid]
    if state then
        state.start = 0
        state.duration = 0
    end

    Logging:Debug(self.ability.name .. " cleared on " .. tostring(mobGuid))
end

function DebuffTracker:HandleResist(msg)
    if not msg or not string.find(msg, self.ability.name) then return end

    if not (string.find(msg, "resisted")
        or string.find(msg, "immune")
        or string.find(msg, "dodged")
        or string.find(msg, "parried")
        or string.find(msg, "missed")
        or string.find(msg, "blocked")) then
        return
    end

    local _, targetGuid = UnitExists("target")
    self:ClearDebuff(targetGuid)
end

function DebuffTracker:GetRemainingOnTarget()
    local _, mobGuid = UnitExists("target")
    if not mobGuid then return nil end

    local state = self.data[mobGuid]
    if not state then return 0 end

    return state.duration - (GetTime() - state.start)
end

function DebuffTracker:ShouldCast()
    if not Helpers:SpellReady(self.ability.name) then return false end

    local remaining = self:GetRemainingOnTarget()
    if remaining == nil then return true end
    if remaining <= 0 then return true end

    return false
end
