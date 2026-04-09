---@class PipelineDurationedSelfBuffUp : BuffPipelineMessage
---@field durationSec number
PipelineDurationedSelfBuffUp = {}
PipelineDurationedSelfBuffUp.__index = PipelineDurationedSelfBuffUp

---@param durationSec number
---@return PipelineDurationedSelfBuffUp
function PipelineDurationedSelfBuffUp.new(durationSec)
    ---@type PipelineDurationedSelfBuffUp
    local self = {
        kind = BuffPipelineKind.BUFF_UP,
        t = "durationed_self_buff",
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineDurationedSelfBuffUp)
end
