---@class BuffPipelineMessage
---@field kind BuffPipelineKindEnum
BuffPipelineMessage = {}

---@param kind BuffPipelineKindEnum
---@return BuffPipelineMessage
function BuffPipelineMessage.new(kind)
    return { kind = kind }
end
