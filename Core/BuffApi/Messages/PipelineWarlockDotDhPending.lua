---@class PipelineWarlockDotDhPending : BuffPipelineMessage
---@field t "warlock_dot"
PipelineWarlockDotDhPending = {}
PipelineWarlockDotDhPending.__index = PipelineWarlockDotDhPending

---@return PipelineWarlockDotDhPending
function PipelineWarlockDotDhPending.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.DH_PENDING_CHANNEL)
    self.t = "warlock_dot"
    return setmetatable(self, PipelineWarlockDotDhPending)
end
