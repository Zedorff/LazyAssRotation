---@class PipelineDebuffApply : BuffPipelineMessage
---@field t "debuff"
---@field mobGuid string
---@field durationSec number
PipelineDebuffApply = {}
PipelineDebuffApply.__index = PipelineDebuffApply

---@param mobGuid string
---@param durationSec number
---@return PipelineDebuffApply
function PipelineDebuffApply.new(mobGuid, durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_APPLY)
    self.t = "debuff"
    self.mobGuid = mobGuid
    self.durationSec = durationSec
    return setmetatable(self, PipelineDebuffApply)
end
