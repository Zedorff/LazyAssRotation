MLDps = MLDps or {}
--- @diagnostic disable-next-line: undefined-global
AceLibrary("AceHook-2.1"):embed(MLDps)
local global = MLDps

function MLDps:StartHookingSpellCasts()
    self:Hook("CastSpellByName")
    self:Hook("UseAction")
    self:Hook("CastSpell")
end

function MLDps:StoptHookingSpellCasts()
    self:Unhook("CastSpellByName")
    self:Unhook("UseAction")
    self:Unhook("CastSpell")
end

function MLDps:CastSpellByName(text, onself)
	if global.eventBus then
        global.eventBus:notify("MLDPS_SPELL_CAST", text)
    end
	return self.hooks["CastSpellByName"](text, onself)
end

function MLDps:UseAction(slot, clicked, onself)
    local spellName

    -- Only check if the action is a spell
    if HasAction(slot) then
        MLDpsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
        MLDpsTooltip:SetAction(slot)

        local text = getglobal("MLDpsTooltipTextLeft1")
        if text then
            spellName = text:GetText()
        end
    end

    if global.eventBus and spellName then
        global.eventBus:notify("MLDPS_SPELL_CAST", spellName)
    end

    return self.hooks["UseAction"](slot, clicked, onself)
end

function MLDps:CastSpell(index, bookType)
    local spellName = GetSpellName(index, bookType)

    if global.eventBus and spellName then
        global.eventBus:notify("MLDPS_SPELL_CAST", spellName)
    end

    return self.hooks["CastSpell"](index, bookType)
end

