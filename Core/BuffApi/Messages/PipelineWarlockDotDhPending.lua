---@class PipelineWarlockDotDhPending : BuffPipelineMessage
PipelineWarlockDotDhPending = {}
PipelineWarlockDotDhPending.__index = PipelineWarlockDotDhPending

---@return PipelineWarlockDotDhPending
function PipelineWarlockDotDhPending.new()
    ---@type PipelineWarlockDotDhPending
    local self = {
        kind = BuffPipelineKind.DH_PENDING_CHANNEL,
        t = "warlock_dot",
    }
    return setmetatable(self, PipelineWarlockDotDhPending)
end
