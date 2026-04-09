---@class PipelineDebuffRemove : BuffPipelineMessage
---@field mobGuid string
PipelineDebuffRemove = {}
PipelineDebuffRemove.__index = PipelineDebuffRemove

---@param mobGuid string
---@return PipelineDebuffRemove
function PipelineDebuffRemove.new(mobGuid)
    ---@type PipelineDebuffRemove
    local self = {
        kind = BuffPipelineKind.DEBUFF_REMOVE,
        t = "debuff",
        mobGuid = mobGuid,
    }
    return setmetatable(self, PipelineDebuffRemove)
end
