VanillaBuffSelfBuff = {}

---@return BuffPipelineSelfBuffUpMessage|BuffPipelineSelfBuffDownMessage|nil
function VanillaBuffSelfBuff.SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineSelfBuffUpMessage
        local m = { t = "self_buff", kind = BuffPipelineKind.BUFF_UP }
        return m
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineSelfBuffDownMessage
        local m = { t = "self_buff", kind = BuffPipelineKind.BUFF_DOWN }
        return m
    end
    return nil
end

---@return BuffPipelineDurationedSelfBuffUpMessage|BuffPipelineDurationedSelfBuffDownMessage|nil
function VanillaBuffSelfBuff.DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineDurationedSelfBuffUpMessage
        local m = { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_UP, durationSec = tracker.duration }
        return m
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineDurationedSelfBuffDownMessage
        local m = { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_DOWN }
        return m
    end
    return nil
end
