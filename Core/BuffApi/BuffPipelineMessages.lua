--- Semantic messages from VanillaBuffEventAdapter / NampowerBuffEventAdapter.
--- Each table is tagged with `t` (channel); `kind` is the sole variant switch within that channel.

---@enum BuffPipelineKindEnum
BuffPipelineKind = {
    BUFF_UP = 1,
    BUFF_DOWN = 2,
    DEBUFF_APPLY = 3,
    DEBUFF_REMOVE = 4,
    DEBUFF_RESIST_LINE = 5,
    DEBUFF_SPELL_MISS = 6,
    DEBUFF_CLEAR_DATA = 7,
    DH_PENDING_CHANNEL = 8,
    DH_CHANNEL_START = 9,
    DH_CHANNEL_STOP = 10,
    ECLIPSE_ARCANE = 11,
    ECLIPSE_NATURE = 12,
    ECLIPSE_CLEAR = 13,
}

--- Self buff (SelfBuffTracker)
---@class BuffPipelineSelfBuffUpMessage
---@field t "self_buff"
---@field kind BuffPipelineKindEnum

---@class BuffPipelineSelfBuffDownMessage
---@field t "self_buff"
---@field kind BuffPipelineKindEnum
---@field via_chat boolean|nil

---@alias BuffPipelineSelfBuffMessage BuffPipelineSelfBuffUpMessage|BuffPipelineSelfBuffDownMessage

--- Durationed self buff (DurationedSelfBuffTracker)
---@class BuffPipelineDurationedSelfBuffUpMessage
---@field t "durationed_self_buff"
---@field kind BuffPipelineKindEnum
---@field durationSec number

---@class BuffPipelineDurationedSelfBuffDownMessage
---@field t "durationed_self_buff"
---@field kind BuffPipelineKindEnum
---@field via_chat boolean|nil

---@alias BuffPipelineDurationedSelfBuffMessage BuffPipelineDurationedSelfBuffUpMessage|BuffPipelineDurationedSelfBuffDownMessage

--- Debuff (DebuffTracker)
---@class BuffPipelineDebuffApplyMessage
---@field t "debuff"
---@field kind BuffPipelineKindEnum
---@field mobGuid string
---@field durationSec number

---@class BuffPipelineDebuffRemoveMessage
---@field t "debuff"
---@field kind BuffPipelineKindEnum
---@field mobGuid string

---@class BuffPipelineDebuffResistLineMessage
---@field t "debuff"
---@field kind BuffPipelineKindEnum
---@field line string

---@class BuffPipelineDebuffSpellMissMessage
---@field t "debuff"
---@field kind BuffPipelineKindEnum
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil

---@class BuffPipelineDebuffClearDataMessage
---@field t "debuff"
---@field kind BuffPipelineKindEnum

---@alias BuffPipelineDebuffMessage BuffPipelineDebuffApplyMessage|BuffPipelineDebuffRemoveMessage|BuffPipelineDebuffResistLineMessage|BuffPipelineDebuffSpellMissMessage|BuffPipelineDebuffClearDataMessage

--- DoT (DotTracker)
---@class BuffPipelineDotApplyMessage
---@field t "dot"
---@field kind BuffPipelineKindEnum
---@field mobGuid string|nil
---@field durationSec number

---@class BuffPipelineDotRemoveMessage
---@field t "dot"
---@field kind BuffPipelineKindEnum
---@field mobGuid string

---@class BuffPipelineDotResistLineMessage
---@field t "dot"
---@field kind BuffPipelineKindEnum
---@field line string

---@class BuffPipelineDotSpellMissMessage
---@field t "dot"
---@field kind BuffPipelineKindEnum
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil

---@class BuffPipelineDotClearDataMessage
---@field t "dot"
---@field kind BuffPipelineKindEnum

---@alias BuffPipelineDotMessage BuffPipelineDotApplyMessage|BuffPipelineDotRemoveMessage|BuffPipelineDotResistLineMessage|BuffPipelineDotSpellMissMessage|BuffPipelineDotClearDataMessage

--- Warlock DoT (WarlockDotTracker)
---@class BuffPipelineWarlockDotApplyMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum
---@field mobGuid string|nil
---@field durationSec number

---@class BuffPipelineWarlockDotRemoveMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum
---@field mobGuid string

---@class BuffPipelineWarlockDotDhPendingMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum

---@class BuffPipelineWarlockDotDhChannelStartMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum
---@field channelDurationMs number|nil

---@class BuffPipelineWarlockDotDhChannelStopMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum

---@class BuffPipelineWarlockDotResistLineMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum
---@field line string

---@class BuffPipelineWarlockDotSpellMissMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil

---@class BuffPipelineWarlockDotClearDataMessage
---@field t "warlock_dot"
---@field kind BuffPipelineKindEnum

---@alias BuffPipelineWarlockDotMessage BuffPipelineWarlockDotApplyMessage|BuffPipelineWarlockDotRemoveMessage|BuffPipelineWarlockDotDhPendingMessage|BuffPipelineWarlockDotDhChannelStartMessage|BuffPipelineWarlockDotDhChannelStopMessage|BuffPipelineWarlockDotResistLineMessage|BuffPipelineWarlockDotSpellMissMessage|BuffPipelineWarlockDotClearDataMessage

--- Eclipse (EclipseTracker)
---@class BuffPipelineEclipseArcaneMessage
---@field t "eclipse"
---@field kind BuffPipelineKindEnum
---@field durationSec number

---@class BuffPipelineEclipseNatureMessage
---@field t "eclipse"
---@field kind BuffPipelineKindEnum
---@field durationSec number

---@class BuffPipelineEclipseClearMessage
---@field t "eclipse"
---@field kind BuffPipelineKindEnum
---@field via_chat boolean|nil

---@alias BuffPipelineEclipseMessage BuffPipelineEclipseArcaneMessage|BuffPipelineEclipseNatureMessage|BuffPipelineEclipseClearMessage

---@alias BuffPipelineMessageAny BuffPipelineSelfBuffMessage|BuffPipelineDurationedSelfBuffMessage|BuffPipelineDebuffMessage|BuffPipelineDotMessage|BuffPipelineWarlockDotMessage|BuffPipelineEclipseMessage
