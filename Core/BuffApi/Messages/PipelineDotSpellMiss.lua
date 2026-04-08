---@class PipelineDotSpellMiss : BuffPipelineMessage
---@field t "dot"
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil
PipelineDotSpellMiss = {}
PipelineDotSpellMiss.__index = PipelineDotSpellMiss

---@return PipelineDotSpellMiss
function PipelineDotSpellMiss.new(casterGuid, targetGuid, spellId, missInfo)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_SPELL_MISS)
    self.t = "dot"
    self.casterGuid = casterGuid
    self.targetGuid = targetGuid
    self.spellId = spellId
    self.missInfo = missInfo
    return setmetatable(self, PipelineDotSpellMiss)
end
