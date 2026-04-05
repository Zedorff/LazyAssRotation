---@class MobDebuffState
---@field mobGuid string
---@field start number
---@field duration number

---@class DebuffTracker : CooldownTracker
---@field ability Ability
---@field data table<string, MobDebuffState>
---@field isSharedDebuff boolean
---@field textureName string|nil
---@field buffApi BuffApi
DebuffTracker = setmetatable({}, { __index = CooldownTracker })
DebuffTracker.__index = DebuffTracker

function DebuffTracker.new(ability, isSharedDebuff, textureName)
    ---@class DebuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DebuffTracker)

    local buffApi = BuffApiFactory.GetInstance()
    self.ability     = ability
    self.data        = {}
    self.isSharedDebuff    = isSharedDebuff or false
    self.textureName = textureName
    self.buffApi = buffApi

    return self
end

function DebuffTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

function DebuffTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    self.buffApi:OnDebuffTrackerEvent(self, GetTime(), event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function DebuffTracker:OnUnitCastEvent(now, casterGuid, targetGuid, eventType, spellId, durationSec)
    if eventType ~= "CAST" then return end
    if not IsMatchingRank(self.ability, tonumber(spellId)) then return end

    local playerGuid = Helpers:GetUnitGUID("player")
    if (not self.isSharedDebuff) and (casterGuid ~= playerGuid) then return end

    local mobGuid = targetGuid or Helpers:GetUnitGUID("target")
    if not mobGuid then return end

    self:ApplyDebuff(now, mobGuid, durationSec)
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

function DebuffTracker:ApplyDebuff(now, mobGuid, durationSec)
    local state = self:GetMobState(mobGuid)

    state.start = now
    state.duration = durationSec

    Logging:Debug(self.ability.name ..
        " applied on " .. mobGuid .. " duration=" .. tostring(durationSec))
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
    if not Helpers:IsSpellApplicationFailureMessage(self.ability.name, msg) then
        return
    end

    local targetGuid = Helpers:GetUnitGUID("target")
    self:ClearDebuff(targetGuid)
end

function DebuffTracker:GetRemainingOnTarget()
    local mobGuid = Helpers:GetUnitGUID("target")
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
