---@class PipelineDurationedSelfBuffUp : BuffPipelineMessage
---@field t "durationed_self_buff"
---@field durationSec number
PipelineDurationedSelfBuffUp = {}
PipelineDurationedSelfBuffUp.__index = PipelineDurationedSelfBuffUp

---@param durationSec number
---@return PipelineDurationedSelfBuffUp
function PipelineDurationedSelfBuffUp.new(durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.BUFF_UP)
    self.t = "durationed_self_buff"
    self.durationSec = durationSec
    return setmetatable(self, PipelineDurationedSelfBuffUp)
end
