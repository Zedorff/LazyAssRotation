---@class PipelineWarlockDotDhChannelStart : BuffPipelineMessage
---@field t "warlock_dot"
---@field channelDurationMs number|nil
PipelineWarlockDotDhChannelStart = {}
PipelineWarlockDotDhChannelStart.__index = PipelineWarlockDotDhChannelStart

---@param channelDurationMs number|nil
---@return PipelineWarlockDotDhChannelStart
function PipelineWarlockDotDhChannelStart.new(channelDurationMs)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DH_CHANNEL_START)
    self.t = "warlock_dot"
    self.channelDurationMs = channelDurationMs
    return setmetatable(self, PipelineWarlockDotDhChannelStart)
end
