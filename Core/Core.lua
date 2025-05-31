--- @diagnostic disable: undefined-field
--- @class Core
--- @field eventBus EventBus
--- @field debugFrame Frame
Core = {}
Core.__index = Core
AceLibrary("AceHook-2.1"):embed(Core)

local hookListenersCounter = 0

function Core:StartHookingSpellCasts()
    if hookListenersCounter == 0 then
        self:Hook("CastSpellByName")
        self:Hook("UseAction")
        self:Hook("CastSpell")
    end
    hookListenersCounter = hookListenersCounter + 1
end

function Core:StopHookingSpellCasts()
    hookListenersCounter = hookListenersCounter - 1
    if hookListenersCounter == 0 then
        self:Unhook("CastSpellByName")
        self:Unhook("UseAction")
        self:Unhook("CastSpell")
    end
end

function Core:CastSpellByName(text, onself)
    if Core.eventBus then
        Core.eventBus:notify("LAR_SPELL_CAST", text)
    end
    return self.hooks["CastSpellByName"](text, onself)
end

function Core:UseAction(slot, clicked, onself)
    local spellName

    -- Only check if the action is a spell
    if HasAction(slot) then
        LAR_GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
        LAR_GameTooltip:SetAction(slot)

        local text = getglobal("LAR_GameTooltipTextLeft1")
        if text then
            spellName = text:GetText()
        end
    end

    if Core.eventBus and spellName then
        Core.eventBus:notify("LAR_SPELL_CAST", spellName)
    end

    return self.hooks["UseAction"](slot, clicked, onself)
end

function Core:CastSpell(index, bookType)
    local spellName = GetSpellName(index, bookType)

    if Core.eventBus and spellName then
        Core.eventBus:notify("LAR_SPELL_CAST", spellName)
    end

    return self.hooks["CastSpell"](index, bookType)
end
