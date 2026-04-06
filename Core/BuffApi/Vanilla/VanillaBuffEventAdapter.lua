--- @class VanillaBuffEventAdapter
VanillaBuffEventAdapter = {}
VanillaBuffEventAdapter.__index = VanillaBuffEventAdapter

--- @return VanillaBuffEventAdapter
function VanillaBuffEventAdapter.new()
    return setmetatable({}, VanillaBuffEventAdapter)
end

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
--- @return BuffPipelineSelfBuffMessage|nil
function VanillaBuffEventAdapter:SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffSelfBuff.SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
--- @return BuffPipelineDurationedSelfBuffMessage|nil
function VanillaBuffEventAdapter:DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffSelfBuff.DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `UNIT_CASTEVENT`: caster guid; `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 string|nil `UNIT_CASTEVENT`: mob guid
--- @param arg3 string|nil `UNIT_CASTEVENT`: subevent (`CAST`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
--- @return BuffPipelineDebuffMessage|nil
function VanillaBuffEventAdapter:DebuffMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffDebuff.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `UNIT_CASTEVENT`: caster guid; `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 string|nil
--- @param arg3 string|nil `UNIT_CASTEVENT`: subevent (`CAST`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
--- @return BuffPipelineDotMessage|nil
function VanillaBuffEventAdapter:DotMessage(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffDot.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil current target guid at event time
--- @param event string
--- @param arg1 unknown|nil `UNIT_CASTEVENT`: caster guid; `SPELLCAST_CHANNEL_START`: channel duration (ms); `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 unknown|nil
--- @param arg3 unknown|nil `UNIT_CASTEVENT`: subevent (`CAST`|`CHANNEL`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
--- @return BuffPipelineWarlockDotMessage|nil
function VanillaBuffEventAdapter:WarlockDotMessage(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffWarlockDot.Message(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
--- @return BuffPipelineEclipseMessage|nil
function VanillaBuffEventAdapter:EclipseMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    return VanillaBuffEclipse.Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end
