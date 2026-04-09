---@class PipelineEclipseClear : BuffPipelineMessage
PipelineEclipseClear = {}
PipelineEclipseClear.__index = PipelineEclipseClear

---@return PipelineEclipseClear
function PipelineEclipseClear.new()
    ---@type PipelineEclipseClear
    local self = {
        kind = BuffPipelineKind.ECLIPSE_CLEAR,
        t = "eclipse",
    }
    return setmetatable(self, PipelineEclipseClear)
end
