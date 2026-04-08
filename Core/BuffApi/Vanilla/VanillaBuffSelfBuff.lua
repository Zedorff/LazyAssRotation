--- @class VanillaBuffSelfBuff : BuffSelfBuffHandler
--- @field pipeline VanillaBuffPipeline
VanillaBuffSelfBuff = {}
VanillaBuffSelfBuff.__index = VanillaBuffSelfBuff

--- @return VanillaBuffSelfBuff
function VanillaBuffSelfBuff.new()
    return setmetatable({ pipeline = VanillaBuffPipeline.new() }, VanillaBuffSelfBuff)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
---@return BuffPipelineSelfBuffMessage|nil
function VanillaBuffSelfBuff:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TrySelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
---@return BuffPipelineDurationedSelfBuffMessage|nil
function VanillaBuffSelfBuff:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return self.pipeline:TryDurationedSelfBuffMessage(tracker, event, arg1, arg3, arg7, arg8)
end
