---@class PipelineDebuffSpellMiss : BuffPipelineMessage
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil
PipelineDebuffSpellMiss = {}
PipelineDebuffSpellMiss.__index = PipelineDebuffSpellMiss

---@param casterGuid string|nil
---@param targetGuid string|nil
---@param spellId string|number|nil
---@param missInfo string|number|nil
---@return PipelineDebuffSpellMiss
function PipelineDebuffSpellMiss.new(casterGuid, targetGuid, spellId, missInfo)
    ---@type PipelineDebuffSpellMiss
    local self = {
        kind = BuffPipelineKind.DEBUFF_SPELL_MISS,
        t = "debuff",
        casterGuid = casterGuid,
        targetGuid = targetGuid,
        spellId = spellId,
        missInfo = missInfo,
    }
    return setmetatable(self, PipelineDebuffSpellMiss)
end
