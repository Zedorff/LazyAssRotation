--- Semantic messages from VanillaBuffEventAdapter / NampowerBuffEventAdapter.
--- Each table is tagged with `t` (channel); `kind` is the sole variant switch within that channel.
--- Concrete shapes live in `Core/BuffApi/Messages/*.lua` (per-type `*.new`).

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

---@class BuffPipelineMessage
---@field kind BuffPipelineKindEnum
---@field t "debuff"|"dot"|"self_buff"|"durationed_self_buff"|"warlock_dot"|"eclipse"

---@alias BuffPipelineSelfBuffMessage PipelineSelfBuffUp|PipelineSelfBuffDown
---@alias BuffPipelineDurationedSelfBuffMessage PipelineDurationedSelfBuffUp|PipelineDurationedSelfBuffDown
---@alias BuffPipelineDebuffMessage PipelineDebuffApply|PipelineDebuffRemove|PipelineDebuffResistLine|PipelineDebuffSpellMiss|PipelineDebuffClearData
---@alias BuffPipelineDotMessage PipelineDotApply|PipelineDotRemove|PipelineDotResistLine|PipelineDotSpellMiss|PipelineDotClearData
---@alias BuffPipelineWarlockDotMessage PipelineWarlockDotApply|PipelineWarlockDotRemove|PipelineWarlockDotDhPending|PipelineWarlockDotDhChannelStart|PipelineWarlockDotDhChannelStop|PipelineWarlockDotResistLine|PipelineWarlockDotSpellMiss|PipelineWarlockDotClearData
---@alias BuffPipelineEclipseMessage PipelineEclipseArcane|PipelineEclipseNature|PipelineEclipseClear

---@alias BuffPipelineMessageAny BuffPipelineSelfBuffMessage|BuffPipelineDurationedSelfBuffMessage|BuffPipelineDebuffMessage|BuffPipelineDotMessage|BuffPipelineWarlockDotMessage|BuffPipelineEclipseMessage
