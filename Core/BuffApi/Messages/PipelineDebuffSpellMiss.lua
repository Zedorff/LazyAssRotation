---@class PipelineDebuffSpellMiss : BuffPipelineMessage
---@field t "debuff"
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil
PipelineDebuffSpellMiss = {}
PipelineDebuffSpellMiss.__index = PipelineDebuffSpellMiss

---@return PipelineDebuffSpellMiss
function PipelineDebuffSpellMiss.new(casterGuid, targetGuid, spellId, missInfo)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_SPELL_MISS)
    self.t = "debuff"
    self.casterGuid = casterGuid
    self.targetGuid = targetGuid
    self.spellId = spellId
    self.missInfo = missInfo
    return setmetatable(self, PipelineDebuffSpellMiss)
end
