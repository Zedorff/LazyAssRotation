local sides = { "TOP", "LEFT", "RIGHT", "BOTTOM" }

function Settings_OnLoad()
    Settings_InitializeLAR_SpecDropdown()
    Settings_InitializeLAR_ModuleDropdown()

    LAR_ShowSpellCheckbox:SetChecked(LARShowRotationSpells or false)
end

function Settings_InitializeLAR_SpecDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(LAR_SpecDropdown, arg1)
                    LARSpecSide = arg1
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(LAR_SpecDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(LAR_SpecDropdown, LARSpecSide or "TOP")
end

function Settings_InitializeLAR_ModuleDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(LAR_ModuleDropdown, arg1)
                    LARSpecSidee = arg1
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(LAR_ModuleDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(LAR_ModuleDropdown, LARSpecSide or "RIGHT")
end

function ToggleShowCurrentSpell(checked)
    LARShowRotationSpells = checked == 1
end
