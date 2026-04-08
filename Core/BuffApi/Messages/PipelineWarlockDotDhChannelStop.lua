---@class PipelineWarlockDotDhChannelStop : BuffPipelineMessage
---@field t "warlock_dot"
PipelineWarlockDotDhChannelStop = {}
PipelineWarlockDotDhChannelStop.__index = PipelineWarlockDotDhChannelStop

---@return PipelineWarlockDotDhChannelStop
function PipelineWarlockDotDhChannelStop.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.DH_CHANNEL_STOP)
    self.t = "warlock_dot"
    return setmetatable(self, PipelineWarlockDotDhChannelStop)
end
