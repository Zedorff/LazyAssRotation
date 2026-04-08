---@class PipelineEclipseClear : BuffPipelineMessage
---@field t "eclipse"
PipelineEclipseClear = {}
PipelineEclipseClear.__index = PipelineEclipseClear

---@return PipelineEclipseClear
function PipelineEclipseClear.new()
    local self = BuffPipelineMessage.new(BuffPipelineKind.ECLIPSE_CLEAR)
    self.t = "eclipse"
    return setmetatable(self, PipelineEclipseClear)
end
