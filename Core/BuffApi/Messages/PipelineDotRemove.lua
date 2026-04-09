---@class PipelineDotRemove : BuffPipelineMessage
---@field mobGuid string
PipelineDotRemove = {}
PipelineDotRemove.__index = PipelineDotRemove

---@param mobGuid string
---@return PipelineDotRemove
function PipelineDotRemove.new(mobGuid)
    ---@type PipelineDotRemove
    local self = {
        kind = BuffPipelineKind.DEBUFF_REMOVE,
        t = "dot",
        mobGuid = mobGuid,
    }
    return setmetatable(self, PipelineDotRemove)
end
