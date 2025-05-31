local sides = { "TOP", "LEFT", "RIGHT", "BOTTOM" }

function Settings_OnLoad()
    Settings_Initialize_SpecDropdown()
    Settings_Initialize_ModuleDropdown()

    LAR_ShowSpellCheckbox:SetChecked(LARShowRotationSpells == true)
    LAR_LockHotSwapButtonCheckbox:SetChecked(LARLockHotSwapButton == true)
end

function Settings_Initialize_SpecDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(LAR_SpecDropdown, arg1)
                    LARSpecSide = arg1
                    HotSwap_RearrangeButtons()
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(LAR_SpecDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(LAR_SpecDropdown, LARSpecSide or "TOP")
end

function Settings_Initialize_ModuleDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(LAR_ModuleDropdown, arg1)
                    LARModuleSide = arg1
                    HotSwap_RearrangeButtons()
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(LAR_ModuleDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(LAR_ModuleDropdown, LARModuleSide or "RIGHT")
end

function LAR_ToggleShowCurrentSpell(checked)
    LARShowRotationSpells = checked == 1
end

function LAR_ToggleLockHotSwapButtonCheckbox(checked)
    LARLockHotSwapButton = checked == 1
end
