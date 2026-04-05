---@class MobDebuffState
---@field mobGuid string
---@field start number
---@field duration number

---@class DebuffTracker : CooldownTracker
---@field ability Ability
---@field data table<string, MobDebuffState>
---@field isSharedDebuff boolean
---@field textureName string|nil
---@field buffPipeline BuffEventPipeline
DebuffTracker = setmetatable({}, { __index = CooldownTracker })
DebuffTracker.__index = DebuffTracker

function DebuffTracker.new(ability, isSharedDebuff, textureName)
    ---@class DebuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DebuffTracker)

    local buffPipeline = BuffApiFactory.GetInstance()
    self.ability     = ability
    self.data        = {}
    self.isSharedDebuff    = isSharedDebuff or false
    self.textureName = textureName
    self.buffPipeline = buffPipeline

    return self
end

function DebuffTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

function DebuffTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local now = GetTime()
    self.buffPipeline:ApplyDebuffEvent(self, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        if not msg then
            return
        end
        if msg.kind == BuffPipelineKind.DEBUFF_APPLY then
            self:ApplyDebuff(now, msg.mobGuid, msg.durationSec)
        elseif msg.kind == BuffPipelineKind.DEBUFF_REMOVE then
            self:ClearDebuff(msg.mobGuid)
        elseif msg.kind == BuffPipelineKind.DEBUFF_RESIST_LINE then
            self:HandleResist(msg.line)
        elseif msg.kind == BuffPipelineKind.DEBUFF_SPELL_MISS then
            self:HandleSpellMiss(msg.casterGuid, msg.targetGuid, msg.spellId, msg.missInfo)
        elseif msg.kind == BuffPipelineKind.DEBUFF_CLEAR_DATA then
            self.data = {}
        end
    end)
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

function DebuffTracker:HandleSpellMiss(casterGuid, targetGuid, spellId, missInfo)
    local playerGuid = Helpers:GetUnitGUID("player")
    if not playerGuid or casterGuid ~= playerGuid then
        return
    end
    if not Helpers:IsSpellApplicationMissInfo(missInfo) then
        return
    end
    if not IsMatchingRank(self.ability, tonumber(spellId)) then
        return
    end
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
