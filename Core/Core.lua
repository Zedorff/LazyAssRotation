--- @diagnostic disable: undefined-field
--- @class Core
--- @field eventBus EventBus
--- @field debugFrame Frame
Core = {}
Core.__index = Core
AceLibrary("AceHook-2.1"):embed(Core)

local hookListenersCounter = 0

function Core:SubscribeToHookedEvents()
    if hookListenersCounter == 0 then
        Core:StartHookingSpellCasts()
    end
    hookListenersCounter = hookListenersCounter + 1
end

function Core:UnsubscribeFromHookedEvents()
    hookListenersCounter = hookListenersCounter - 1
    if hookListenersCounter == 0 then
        Core:StopHookingSpellCasts()
    end
end

function Core:ForceUnhook()
    Core:StopHookingSpellCasts()
    hookListenersCounter = 0
end

function Core:StartHookingSpellCasts()
    if not self:IsHooked("CastSpellByName") then self:Hook("CastSpellByName") end
    if not self:IsHooked("UseAction") then self:Hook("UseAction") end
    if not self:IsHooked("CastSpell") then self:Hook("CastSpell") end
end

function Core:StopHookingSpellCasts()
    if self:IsHooked("CastSpellByName") then self:Unhook("CastSpellByName") end
    if self:IsHooked("UseAction") then self:Unhook("UseAction") end
    if self:IsHooked("CastSpell") then self:Unhook("CastSpell") end
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
