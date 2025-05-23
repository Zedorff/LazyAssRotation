MLDps = MLDps or {}

local dropdownCount = 0
local moduleDropdown
local optionList = {}

function MLDpsMinimapButton_OnLoad()
    this:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    this:Show()
end

function MLDpsMinimapButton_OnClick()
    if arg1 == "LeftButton" then
        Logging:ToggleDebug()
    else
        MLDps:ShowModuleToggleMenu()
    end
end

function MLDpsMinimapButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cffffff00MLDps|r") 
    GameTooltip:AddLine(" ", 1, 1, 1)
    GameTooltip:AddLine("Right-click to toggle modules", 1, 1, 1, true)
    GameTooltip:AddLine("Left-click to toggle debug mode", 1, 1, 1, true)
    GameTooltip:Show()
end

function MLDpsMinimapButton_OnLeave()
    GameTooltip:Hide()
end

-- Called on right-click
function MLDps:ShowModuleToggleMenu()
    if not moduleDropdown then
        dropdownCount = dropdownCount + 1
        moduleDropdown = CreateFrame("Frame", "MLDps_DropDown" .. dropdownCount, UIParent, "UIDropDownMenuTemplate")
    end

    -- Build fresh option list from ModuleRegistry
    optionList = {}
    for _, mod in pairs(ModuleRegistry.modules) do
        table.insert(optionList, {
            name = mod.name,
            enabled = mod.enabled
        })
    end

    local function Initialize()
        -- Add the title line at the top
        UIDropDownMenu_AddButton({
            text = "|cffffff00Toggle Modules|r",  -- bright yellow title
            isTitle = true,
            notCheckable = true,
            notClickable = true,
        }, 1)

        UIDropDownMenu_AddButton({
            text = "",
            notCheckable = true,
            notClickable = true,
        }, 1)
        
        local info
        
        for i, v in ipairs(optionList) do
            info = {}
            info.text = v.name
            info.arg1 = i
            info.func = function (arg1)
                local opt = optionList[arg1]
                if opt then
                    if opt.enabled then
                        ModuleRegistry:DisableModule(opt.name)
                    else
                        ModuleRegistry:EnableModule(opt.name)
                    end
                    opt.enabled = not opt.enabled
                end
                CloseDropDownMenus()
            end
            info.checked = v.enabled
            info.keepShownOnClick = true
            info.notCheckable = false
            UIDropDownMenu_AddButton(info, 1)
        end
    end

    UIDropDownMenu_Initialize(moduleDropdown, Initialize, "MENU")
    ToggleDropDownMenu(1, nil, moduleDropdown, "cursor", 0, 0)

    -- Optional style
    UIDropDownMenu_SetWidth(100, moduleDropdown)
    UIDropDownMenu_SetButtonWidth(124, moduleDropdown)
    UIDropDownMenu_JustifyText("LEFT", moduleDropdown)
end

