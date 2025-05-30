local sides = { "TOP", "LEFT", "RIGHT", "BOTTOM" }

function Settings_OnLoad()
    InitializeSpecDropdown()
    InitializeModuleDropdown()


    -- Checkbox
    ShowSpellCheckbox:SetChecked(ShowRotationSpells or false)
end

function InitializeSpecDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(SpecDropdown, arg1)
                    SpecSide = arg1
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(SpecDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(SpecDropdown, SpecSide or "TOP")
end

function InitializeModuleDropdown()
    local function initialize()
        for _, side in ipairs(sides) do
            local info = {
                text = side,
                value = side,
                arg1 = side,
                func = function(arg1)
                    UIDropDownMenu_SetSelectedValue(ModuleDropdown, arg1)
                    ModuleSidee = arg1
                end,
            }
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(ModuleDropdown, initialize)
    UIDropDownMenu_SetSelectedValue(ModuleDropdown, ModuleSide or "RIGHT")
end

function ToggleShowCurrentSpell(checked)
    ShowRotationSpells = checked == 1
end
