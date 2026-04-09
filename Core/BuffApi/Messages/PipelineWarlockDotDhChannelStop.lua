---@class PipelineWarlockDotDhChannelStop : BuffPipelineMessage
PipelineWarlockDotDhChannelStop = {}
PipelineWarlockDotDhChannelStop.__index = PipelineWarlockDotDhChannelStop

---@return PipelineWarlockDotDhChannelStop
function PipelineWarlockDotDhChannelStop.new()
    ---@type PipelineWarlockDotDhChannelStop
    local self = {
        kind = BuffPipelineKind.DH_CHANNEL_STOP,
        t = "warlock_dot",
    }
    return setmetatable(self, PipelineWarlockDotDhChannelStop)
end
