---@class PipelineWarlockDotDhChannelStart : BuffPipelineMessage
---@field channelDurationMs number|nil
PipelineWarlockDotDhChannelStart = {}
PipelineWarlockDotDhChannelStart.__index = PipelineWarlockDotDhChannelStart

---@param channelDurationMs number|nil
---@return PipelineWarlockDotDhChannelStart
function PipelineWarlockDotDhChannelStart.new(channelDurationMs)
    ---@type PipelineWarlockDotDhChannelStart
    local self = {
        kind = BuffPipelineKind.DH_CHANNEL_START,
        t = "warlock_dot",
        channelDurationMs = channelDurationMs,
    }
    return setmetatable(self, PipelineWarlockDotDhChannelStart)
end
