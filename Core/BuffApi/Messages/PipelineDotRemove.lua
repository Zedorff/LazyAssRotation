---@class PipelineDotRemove : BuffPipelineMessage
---@field t "dot"
---@field mobGuid string
PipelineDotRemove = {}
PipelineDotRemove.__index = PipelineDotRemove

---@param mobGuid string
---@return PipelineDotRemove
function PipelineDotRemove.new(mobGuid)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_REMOVE)
    self.t = "dot"
    self.mobGuid = mobGuid
    return setmetatable(self, PipelineDotRemove)
end
