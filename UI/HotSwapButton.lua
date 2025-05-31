--- @diagnostic disable: undefined-field, param-type-mismatch, inject-field
--- @type table<string, table<number, Button>>
ButtonCache = ButtonCache or {}

--- @type table<string, Button[]>
ButtonSets = ButtonSets or {}

--- @type number
local lastUpdate = 0

--- @type number
local hideTimer = 0

--- @type number
local hideDelay = 0.5

--- @type boolean
local hidden = true

function HotSwap_SaveDraggableButtonPosition()
    --- @type Frame
    local frame = HotSwapButton
    local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
    --- @type { [1]: string, [2]: string, [3]: number, [4]: number }
    LARFloatingButtonPosition = { point, relativePoint, xOfs, yOfs }
end

function RestoreDraggableButtonPosition()
    --- @type Frame
    local frame = HotSwapButton
    if LARFloatingButtonPosition then
        local point, relativePoint, xOfs, yOfs = unpack(LARFloatingButtonPosition)
        frame:ClearAllPoints()
        frame:SetPoint(point, UIParent, relativePoint, xOfs, yOfs)
    else
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

function HotSwapButton_OnMouseUp()
    this:StopMovingOrSizing()
    HotSwap_SaveDraggableButtonPosition()
end

function HotSwapButton_OnLoad()
    RestoreDraggableButtonPosition()
    this:SetScript("OnUpdate", HotSwap_DraggableButton_OnUpdate)
end

function HotSwapButton_OnMouseDown()
    if LARLockHotSwapButton ~= true then
        this:StartMoving()
    end
end

--- @param texturePath string
function HotSwap_SetDraggableButtonIcon(texturePath)
    if HotSwapButtonIcon then
        HotSwapButtonIcon:SetTexture(texturePath)
    end
end

--- @param parent Frame
--- @param name string
--- @param iconPath string
--- @return Button
local function CreateSmallButton(parent, name, iconPath)
    local buttonSize = 24
    local borderThickness = 2

    --- @type Button
    local button = CreateFrame("Button", name, parent)
    button:SetWidth(buttonSize)
    button:SetHeight(buttonSize)

    --- @type Texture
    local border = button:CreateTexture(nil, "BACKGROUND")
    border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    border:SetVertexColor(0, 1, 0)
    border:SetAllPoints(button)
    border:Hide()
    button.border = border

    --- @type Texture
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", button, "TOPLEFT", borderThickness, -borderThickness)
    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -borderThickness, borderThickness)
    icon:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark")
    button.icon = icon

    button:Show()
    return button
end

--- @param buttons Button[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
--- @param parent Frame
local function AnchorButtonSet(buttons, side, parent)
    local btnWidth = buttons[1]:GetWidth()
    local btnHeight = buttons[1]:GetHeight()

    for i, btn in ipairs(buttons) do
        btn:ClearAllPoints()
        local offset = (i - 1)
        if side == "TOP" then
            btn:SetPoint("BOTTOM", parent, "TOP", 0, offset * btnHeight)
        elseif side == "BOTTOM" then
            btn:SetPoint("TOP", parent, "BOTTOM", 0, -(offset * btnHeight))
        elseif side == "LEFT" then
            btn:SetPoint("RIGHT", parent, "LEFT", -(offset * btnWidth), 0)
        elseif side == "RIGHT" then
            btn:SetPoint("LEFT", parent, "RIGHT", offset * btnWidth, 0)
        end
    end
end

--- @param cacheKey string
--- @param index integer
--- @param parent Frame
--- @param icon string
--- @return Button
local function AcquireButton(cacheKey, index, parent, icon)
    ButtonCache[cacheKey] = ButtonCache[cacheKey] or {}
    local cache = ButtonCache[cacheKey]

    if cache[index] then
        local btn = cache[index]
        btn:SetParent(parent)
        btn.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        return btn
    else
        local btn = CreateSmallButton(parent, cacheKey .. index, icon)
        cache[index] = btn
        return btn
    end
end

--- @param parent Frame
--- @param prefix string
local function RemoveChildrenByPrefix(parent, prefix)
    --- @type Frame[]
    local children = { parent:GetChildren() }

    for i = Collection.size(children), 1, -1 do
        local child = children[i]
        --- @cast child Frame | nil
        if child then
            local name = child:GetName()
            if name and string.find(name, "^" .. prefix) then
                child:Hide()
                child:ClearAllPoints()
                child:SetParent(nil)
            end
        end
    end
end

--- @param specs SpecButtonInfo[]
function HotSwap_CreateSpecButtons(specs)
    local parent = HotSwapButton
    RemoveChildrenByPrefix(parent, "Spec")

    --- @type Button[]
    local specButtons = {}
    for i, spec in ipairs(specs) do
        --- @cast spec SpecButtonInfo
        local localSpec = spec
        local btn = AcquireButton("Spec", i, parent, localSpec.icon)
        btn:SetScript("OnClick", function()
            Core.eventBus:notify("SPEC_CHANGED", localSpec)
            local set = ButtonSets["SpecSet"]
            if set then
                for _, spec in ipairs(set) do
                    HotSwap_SetButtonEnabled(spec, false)
                end
            end
            HotSwap_SetButtonEnabled(btn, true)
            HotSwap_HideButtonSets()
        end)
        HotSwap_SetButtonEnabled(btn, localSpec.enabled)
        btn:Hide()
        table.insert(specButtons, btn)
    end

    AnchorButtonSet(specButtons, LARSpecSide or "TOP", parent)
    ButtonSets["SpecSet"] = specButtons
end

function HotSwap_InvalidateModuleButtons()
    local modules = Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end)

    local parent = HotSwapButton
    RemoveChildrenByPrefix(parent, "Module")

    --- @type Button[]
    local moduleButtons = {}
    for i, module in ipairs(modules) do
        --- @cast module ModuleButtonInfo
        local localModule = module
        local btn = AcquireButton("Module", i, parent, localModule.icon)
        HotSwap_SetButtonEnabled(btn, localModule.enabled)
        btn:SetScript("OnClick", function()
            if ModuleRegistry:IsModuleEnabled(localModule.name) then
                ModuleRegistry:DisableModule(localModule.name)
            else
                ModuleRegistry:EnableModule(localModule.name)
            end
            local set = ButtonSets["ModuleSet"]
            if set then
                for index, spec in ipairs(set) do
                    HotSwap_SetButtonEnabled(spec, ModuleRegistry:GetOrderedModules()[index].enabled)
                end
            end
        end)
        btn:Hide()
        table.insert(moduleButtons, btn)
    end

    AnchorButtonSet(moduleButtons, LARModuleSide or "RIGHT", parent)
    ButtonSets["ModuleSet"] = moduleButtons
end

--- @param button Button
--- @param enabled boolean
function HotSwap_SetButtonEnabled(button, enabled)
    if enabled then
        button.border:Show()
    else
        button.border:Hide()
    end
end

--- @return boolean
local function IsMouseOverMainOrSet()
    local mouseFocus = GetMouseFocus()

    if mouseFocus == HotSwapButton then
        return true
    end

    local set = ButtonSets["SpecSet"]
    if set then
        for _, btn in ipairs(set) do
            if mouseFocus == btn then
                return true
            end
        end
    end

    set = ButtonSets["ModuleSet"]
    if set then
        for _, btn in ipairs(set) do
            if mouseFocus == btn then
                return true
            end
        end
    end

    return false
end

function HotSwap_DraggableButton_OnUpdate()
    local now = GetTime()
    local elapsed = 0
    if lastUpdate > 0 then
        elapsed = now - lastUpdate
    end
    lastUpdate = now

    local isMouseOverNow = IsMouseOverMainOrSet()

    if isMouseOverNow then
        hideTimer = 0
        HotSwap_ShowButtonSets()
    else
        hideTimer = hideTimer + elapsed
        if hideTimer >= hideDelay then
            HotSwap_HideButtonSets()
            hideTimer = 0
        end
    end
end

function HotSwap_ShowButtonSets()
    if hidden then
        local set = ButtonSets["SpecSet"]
        if set then
            for _, btn in ipairs(set) do btn:Show() end
        end
        set = ButtonSets["ModuleSet"]
        if set then
            for _, btn in ipairs(set) do btn:Show() end
        end
        hidden = false
    end
end

function HotSwap_HideButtonSets()
    if not hidden then
        local set = ButtonSets["SpecSet"]
        if set then
            for _, btn in ipairs(set) do btn:Hide() end
        end
        set = ButtonSets["ModuleSet"]
        if set then
            for _, btn in ipairs(set) do btn:Hide() end
        end
        hidden = true
    end
end

function HotSwap_RearrangeButtons()
    AnchorButtonSet(ButtonSets["SpecSet"], LARSpecSide or "TOP", HotSwapButton)
    AnchorButtonSet(ButtonSets["ModuleSet"], LARModuleSide or "RIGHT", HotSwapButton)
end
