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

--- Wraps module toggle buttons; mouse-enabled to bridge gaps between main button and modules.
--- @type Frame | nil
HotSwapModuleContainer = nil

--- Wraps the spec button cluster for hit-testing (spec buttons stay parented to HotSwapButton, like module buttons).
--- @type Frame | nil
HotSwapSpecContainer = nil

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

--- Tooltip-style rounded backdrop (shared with group panels and selection ring).
--- tile=false stretches the bg instead of tiling — avoids visible seam "lines" on small frames.
--- @param frame Frame
--- @param bgAlpha number
local function ApplyRoundedBackdrop(frame, bgAlpha)
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = false,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    if bgAlpha <= 0 then
        frame:SetBackdropColor(0, 0, 0, 0)
    else
        frame:SetBackdropColor(0.1, 0.1, 0.1, bgAlpha)
    end
    frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
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

    --- @type Frame
    local iconHolder = CreateFrame("Frame", nil, button)
    iconHolder:SetAllPoints(button)
    iconHolder:SetFrameLevel(1)
    iconHolder:EnableMouse(false)

    --- @type Texture
    local icon = iconHolder:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", iconHolder, "TOPLEFT", borderThickness, -borderThickness)
    icon:SetPoint("BOTTOMRIGHT", iconHolder, "BOTTOMRIGHT", -borderThickness, borderThickness)
    icon:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark")
    button.icon = icon

    --- Rounded selection ring above the icon (transparent fill; edge only is visible).
    --- Outset 3px (was 2) so the enabled state reads more clearly next to neighbors.
    --- @type Frame
    local border = CreateFrame("Frame", nil, button)
    local ringOutset = 3
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -ringOutset, ringOutset)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", ringOutset, -ringOutset)
    ApplyRoundedBackdrop(border, 0)
    border:SetFrameLevel(20)
    border:EnableMouse(false)
    border:Hide()
    button.border = border

    if button.RegisterForClicks then
        button:RegisterForClicks("LeftButtonUp")
    end

    button:Show()
    return button
end

--- Extra pixels inserted when `module.group` changes between adjacent module buttons.
local moduleGroupGap = 8

--- Padding around module icons inside each group backdrop.
local groupBackdropPad = 4

--- Inset around spec/module button clusters when fitting `HotSwapSpecContainer` / `HotSwapModuleContainer`.
local clusterContainerPad = 2

--- Space between the draggable main button edge and the first spec/module icon in the strip.
local mainButtonClusterGap = 2

--- Gap between adjacent icons along a spec or module strip (within a group run).
local clusterItemGap = 1

--- Cluster backdrop frames must stay below spec/module icon buttons (fixed levels; do not use parent+1 — that can pass button level when HotSwapButton’s level is high).
local clusterBackdropFrameLevel = 1
local clusterIconButtonFrameLevel = 20

--- Length of a dense array (WoW Lua may not support the # operator).
--- @param t table
--- @return integer
local function arrayLength(t)
    local n = 0
    for _ in ipairs(t) do
        n = n + 1
    end
    return n
end

--- @return Frame
local function GetOrCreateModuleButtonContainer()
    if HotSwapModuleContainer then
        return HotSwapModuleContainer
    end
    --- @type Frame
    local f = CreateFrame("Frame", "HotSwapModuleContainer", HotSwapButton)
    f:SetFrameStrata(HotSwapButton:GetFrameStrata())
    f:SetFrameLevel(clusterBackdropFrameLevel)
    f:EnableMouse(true)
    HotSwapModuleContainer = f
    return f
end

--- @return Frame
local function GetOrCreateSpecButtonContainer()
    if HotSwapSpecContainer then
        return HotSwapSpecContainer
    end
    --- @type Frame
    local f = CreateFrame("Frame", "HotSwapSpecContainer", HotSwapButton)
    f:SetFrameStrata(HotSwapButton:GetFrameStrata())
    f:SetFrameLevel(clusterBackdropFrameLevel)
    f:EnableMouse(true)
    ApplyRoundedBackdrop(f, 0.65)
    HotSwapSpecContainer = f
    return f
end

--- Size the container around laid-out spec/module buttons (padding fills gaps for hover).
--- @param container Frame
--- @param buttons Button[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
local function FitClusterContainerBounds(container, buttons, side)
    local pad = clusterContainerPad
    if arrayLength(buttons) == 0 then
        container:Hide()
        return
    end
    if hidden then
        container:Hide()
    else
        container:Show()
    end
    local first = buttons[1]
    local last = buttons[arrayLength(buttons)]
    container:ClearAllPoints()
    if side == "RIGHT" then
        container:SetPoint("TOPLEFT", first, "TOPLEFT", -pad, pad)
        container:SetPoint("BOTTOMRIGHT", last, "BOTTOMRIGHT", pad, -pad)
    elseif side == "LEFT" then
        container:SetPoint("TOPRIGHT", first, "TOPRIGHT", pad, pad)
        container:SetPoint("BOTTOMLEFT", last, "BOTTOMLEFT", -pad, -pad)
    elseif side == "TOP" then
        container:SetPoint("BOTTOMLEFT", first, "BOTTOMLEFT", -pad, -pad)
        container:SetPoint("TOPRIGHT", last, "TOPRIGHT", pad, pad)
    elseif side == "BOTTOM" then
        container:SetPoint("TOPLEFT", first, "TOPLEFT", -pad, pad)
        container:SetPoint("BOTTOMRIGHT", last, "BOTTOMRIGHT", pad, -pad)
    end
end

--- @type FontString | nil
local groupLabelMeasureFontString = nil

--- Matches width used in `CreateGroupLabelFrame` (`padX = 10` there).
--- @param text string
--- @return number
local function GetGroupLabelChipWidth(text)
    if not groupLabelMeasureFontString then
        groupLabelMeasureFontString = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        groupLabelMeasureFontString:Hide()
    end
    groupLabelMeasureFontString:SetText(text)
    return groupLabelMeasureFontString:GetStringWidth() + 10
end

--- @param moduleGroupLabels (string | nil)[]
--- @param i integer
--- @param j integer
--- @return string | nil
local function resolveGroupLabelText(moduleGroupLabels, i, j)
    for k = i, j do
        local t = moduleGroupLabels[k]
        if t and t ~= "" then
            return t
        end
    end
    return nil
end

--- Same layout as AnchorButtonSetWithGroups but anchors geometry to `mainFrame` (buttons parented to module container separately).
--- Group runs use `groups`; labeled runs center the icon cluster in max(button span along strip, label chip width)
--- on LEFT/RIGHT. TOP/BOTTOM: no horizontal shift (labels are placed above/below the group, centered).
--- @param buttons Button[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
--- @param mainFrame Frame
--- @param groups any[] | nil
--- @param moduleGroupLabels (string | nil)[] | nil
local function AnchorModuleButtonSetWithGroups(buttons, side, mainFrame, groups, moduleGroupLabels)
    local btnWidth = buttons[1]:GetWidth()
    local btnHeight = buttons[1]:GetHeight()
    local n = arrayLength(buttons)
    local pos = mainButtonClusterGap

    local i = 1
    while i <= n do
        if i > 1 and groups and groups[i] ~= groups[i - 1] then
            pos = pos + moduleGroupGap
        end

        local j = i
        if groups then
            local g = groups[i]
            while j < n and groups[j + 1] == g do
                j = j + 1
            end
        else
            j = n
        end

        local labelText = moduleGroupLabels and resolveGroupLabelText(moduleGroupLabels, i, j) or nil

        if side == "LEFT" or side == "RIGHT" then
            local runCount = j - i + 1
            local runSpan = runCount * btnWidth + (runCount - 1) * clusterItemGap
            local slotAlong = runSpan
            if labelText then
                slotAlong = math.max(runSpan, GetGroupLabelChipWidth(labelText))
            end
            local lead = (slotAlong - runSpan) / 2
            pos = pos + lead

            for k = i, j do
                local b = buttons[k]
                b:ClearAllPoints()
                if side == "RIGHT" then
                    b:SetPoint("LEFT", mainFrame, "RIGHT", pos, 0)
                else
                    b:SetPoint("RIGHT", mainFrame, "LEFT", -pos, 0)
                end
                pos = pos + btnWidth
                if k < j then
                    pos = pos + clusterItemGap
                end
            end
            pos = pos + lead
        else
            for k = i, j do
                local b = buttons[k]
                b:ClearAllPoints()
                if side == "TOP" then
                    b:SetPoint("BOTTOM", mainFrame, "TOP", 0, pos)
                else
                    b:SetPoint("TOP", mainFrame, "BOTTOM", 0, -pos)
                end
                pos = pos + btnHeight
                if k < j then
                    pos = pos + clusterItemGap
                end
            end
        end

        i = j + 1
    end
end

--- @param buttons Button[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
--- @param parent Frame
--- @param groups any[] | nil
---        Parallel to `buttons`: same group id as previous index → no extra gap; change → insert `moduleGroupGap`.
local function AnchorButtonSetWithGroups(buttons, side, parent, groups)
    local btnWidth = buttons[1]:GetWidth()
    local btnHeight = buttons[1]:GetHeight()
    local pos = mainButtonClusterGap
    local n = arrayLength(buttons)

    for i, btn in ipairs(buttons) do
        btn:ClearAllPoints()
        if i > 1 and groups and groups[i] ~= groups[i - 1] then
            pos = pos + moduleGroupGap
        end
        if side == "TOP" then
            btn:SetPoint("BOTTOM", parent, "TOP", 0, pos)
        elseif side == "BOTTOM" then
            btn:SetPoint("TOP", parent, "BOTTOM", 0, -pos)
        elseif side == "LEFT" then
            btn:SetPoint("RIGHT", parent, "LEFT", -pos, 0)
        elseif side == "RIGHT" then
            btn:SetPoint("LEFT", parent, "RIGHT", pos, 0)
        end
        if side == "TOP" or side == "BOTTOM" then
            pos = pos + btnHeight
        else
            pos = pos + btnWidth
        end
        if i < n then
            pos = pos + clusterItemGap
        end
    end
end

--- @param buttons Button[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
--- @param parent Frame
local function AnchorButtonSet(buttons, side, parent)
    local groups = {}
    for i, _ in ipairs(buttons) do
        groups[i] = nil
    end
    AnchorButtonSetWithGroups(buttons, side, parent, groups)
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

--- For group backdrops, which two buttons define TOPLEFT vs BOTTOMRIGHT corners.
--- Order along the strip from the main button: for LEFT/TOP the first index is the inner
--- (main-side) button and growth is toward lower X / higher Y; pairing first→TL and last→BR
--- inverts the rect unless we swap.
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
--- @param firstIdx integer
--- @param lastIdx integer
--- @return Button, Button  topLeftButton, bottomRightButton
local function GroupBackdropCornerButtons(buttons, side, firstIdx, lastIdx)
    if side == "LEFT" or side == "TOP" then
        return buttons[lastIdx], buttons[firstIdx]
    end
    return buttons[firstIdx], buttons[lastIdx]
end

--- Label chip placement depends on module bar side (same tooltip style as group backdrops).
--- TOP/BOTTOM: chip to the right of the icon column (LEFT of chip on RIGHT edge of backdrop), text right-justified.
--- LEFT/RIGHT: above the horizontal strip, centered on the backdrop.
--- Minimum height keeps the 9-slice border from tearing on very short strips.
--- @param parentBackdrop Frame
--- @param text string
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
local function CreateGroupLabelFrame(parentBackdrop, text, side)
    --- @type Frame
    local f = CreateFrame("Frame", nil, parentBackdrop)
    f:SetFrameLevel(parentBackdrop:GetFrameLevel() + 3)
    f:EnableMouse(false)

    --- @type FontString
    local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetText(text)
    if side == "LEFT" or side == "RIGHT" then
        fs:SetJustifyH("CENTER")
    else
        fs:SetJustifyH("RIGHT")
    end
    -- Vanilla-style gold (title / quest reward tone).
    if GOLD_FONT_COLOR then
        fs:SetTextColor(GOLD_FONT_COLOR.r, GOLD_FONT_COLOR.g, GOLD_FONT_COLOR.b)
    else
        fs:SetTextColor(1, 0.82, 0, 1)
    end

    local padX = 10
    local padY = 1
    local textPad = 4
    local w = fs:GetStringWidth() + padX
    local h = fs:GetHeight() + padY * 2
    local minLabelH = 20
    if h < minLabelH then
        h = minLabelH
    end
    f:SetWidth(w)
    f:SetHeight(h)

    fs:SetPoint("TOPLEFT", f, "TOPLEFT", textPad, -textPad)
    fs:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -textPad, textPad)
    fs:SetJustifyV("MIDDLE")

    ApplyRoundedBackdrop(f, 0.65)
    f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local edgeOut = 6
    if side == "LEFT" or side == "RIGHT" then
        f:SetPoint("CENTER", parentBackdrop, "TOP", 0, edgeOut)
    else
        f:SetPoint("LEFT", parentBackdrop, "RIGHT", 0, 0)
    end
    f:Show()
end

--- Contiguous runs of the same `module.group` get one rounded panel behind them.
--- @param moduleParent Frame
--- @param buttons Button[]
--- @param moduleGroups any[]
--- @param moduleGroupLabels (string | nil)[]
--- @param side "TOP" | "BOTTOM" | "LEFT" | "RIGHT"
local function RefreshModuleGroupBackdrops(moduleParent, buttons, moduleGroups, moduleGroupLabels, side)
    RemoveChildrenByPrefix(moduleParent, "HotSwapModuleGroup")
    local n = arrayLength(buttons)
    if n == 0 then
        return
    end

    local i = 1
    local gidx = 0
    while i <= n do
        local g = moduleGroups[i]
        local j = i
        while j < n and moduleGroups[j + 1] == g do
            j = j + 1
        end
        gidx = gidx + 1
        --- @type Frame
        local backdrop = CreateFrame("Frame", "HotSwapModuleGroup" .. gidx, moduleParent)
        backdrop:SetFrameLevel(1)
        ApplyRoundedBackdrop(backdrop, 0.65)
        local tlBtn, brBtn = GroupBackdropCornerButtons(buttons, side, i, j)

        backdrop:SetPoint("TOPLEFT", tlBtn, "TOPLEFT", -groupBackdropPad, groupBackdropPad)
        backdrop:SetPoint("BOTTOMRIGHT", brBtn, "BOTTOMRIGHT", groupBackdropPad, -groupBackdropPad)
        backdrop:EnableMouse(false)
        backdrop:Show()

        local labelText = resolveGroupLabelText(moduleGroupLabels, i, j)
        if labelText then
            CreateGroupLabelFrame(backdrop, labelText, side)
        end

        i = j + 1
    end
end

--- @param specs SpecButtonInfo[]
function HotSwap_CreateSpecButtons(specs)
    local mainFrame = HotSwapButton
    RemoveChildrenByPrefix(mainFrame, "Spec")
    local specContainer = GetOrCreateSpecButtonContainer()

    --- @type Button[]
    local specButtons = {}
    for i, spec in ipairs(specs) do
        --- @cast spec SpecButtonInfo
        local localSpec = spec
        local btn = AcquireButton("Spec", i, mainFrame, localSpec.icon)
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

    local specSide = LARSpecSide or "TOP"
    AnchorButtonSet(specButtons, specSide, mainFrame)
    for _, btn in ipairs(specButtons) do
        btn:SetFrameLevel(clusterIconButtonFrameLevel)
        if btn.border then
            btn.border:SetFrameLevel(btn:GetFrameLevel() + 5)
        end
    end
    FitClusterContainerBounds(specContainer, specButtons, specSide)
    ButtonSets["SpecSet"] = specButtons
end

function HotSwap_InvalidateModuleButtons()
    local orderedModules = ModuleRegistry:GetOrderedModules()
    local modules = Collection.map(orderedModules, function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end)

    local mainFrame = HotSwapButton
    RemoveChildrenByPrefix(mainFrame, "Module")
    local moduleParent = GetOrCreateModuleButtonContainer()
    RemoveChildrenByPrefix(moduleParent, "HotSwapModuleGroup")
    RemoveChildrenByPrefix(moduleParent, "Module")

    --- @type Button[]
    local moduleButtons = {}
    --- @type any[]
    local moduleGroups = {}
    --- @type (string | nil)[]
    local moduleGroupLabels = {}
    for i, module in ipairs(modules) do
        --- @cast module ModuleButtonInfo
        local localModule = module
        local btn = AcquireButton("Module", i, mainFrame, localModule.icon)
        HotSwap_SetButtonEnabled(btn, localModule.enabled)
        btn:SetScript("OnClick", function()
            local name = localModule.name
            local wasEnabled = ModuleRegistry:IsModuleEnabled(name)
            if wasEnabled then
                ModuleRegistry:DisableModule(name)
            else
                ModuleRegistry:EnableModule(name)
            end
            local set = ButtonSets["ModuleSet"]
            if set then
                local om = ModuleRegistry:GetOrderedModules()
                for index, specBtn in ipairs(set) do
                    local m = om[index]
                    HotSwap_SetButtonEnabled(specBtn, m and m.enabled)
                end
            end
        end)
        btn:Hide()
        table.insert(moduleButtons, btn)
        table.insert(moduleGroups, orderedModules[i] and orderedModules[i].group or nil)
        local mod = orderedModules[i]
        table.insert(moduleGroupLabels, mod and mod.groupLabel or nil)
    end

    local side = LARModuleSide or "RIGHT"
    if arrayLength(moduleButtons) > 0 then
        AnchorModuleButtonSetWithGroups(moduleButtons, side, mainFrame, moduleGroups, moduleGroupLabels)
        for _, btn in ipairs(moduleButtons) do
            btn:SetFrameLevel(clusterIconButtonFrameLevel)
            if btn.border then
                btn.border:SetFrameLevel(btn:GetFrameLevel() + 5)
            end
        end
        RefreshModuleGroupBackdrops(moduleParent, moduleButtons, moduleGroups, moduleGroupLabels, side)
    end
    FitClusterContainerBounds(moduleParent, moduleButtons, side)
    ButtonSets["ModuleSet"] = moduleButtons
    ButtonSets["ModuleGroups"] = moduleGroups
    ButtonSets["ModuleGroupLabels"] = moduleGroupLabels
end

--- @param button Button
--- @param enabled boolean
function HotSwap_SetButtonEnabled(button, enabled)
    local b = button.border
    if not b then
        return
    end
    local icon = button.icon
    if enabled then
        if icon then
            icon:SetVertexColor(1, 1, 1)
        end
        b:SetBackdropBorderColor(0.65, 1, 0.5, 1)
        b:Show()
    else
        if icon then
            -- ~10% closer to white than prior (0.42/0.46) for clearer disabled read.
            icon:SetVertexColor(0.48, 0.48, 0.51)
        end
        b:Hide()
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
        if HotSwapSpecContainer and mouseFocus == HotSwapSpecContainer then
            return true
        end
        for _, btn in ipairs(set) do
            if mouseFocus == btn then
                return true
            end
        end
    end

    set = ButtonSets["ModuleSet"]
    if set then
        if HotSwapModuleContainer and mouseFocus == HotSwapModuleContainer then
            return true
        end
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
    -- Set expanded first so FitClusterContainerBounds shows the module/spec containers.
    -- After HotSwap_InvalidateModuleButtons(), buttons are Hide() while the bar
    -- may still be expanded; we show them again when the mouse is over the cluster.
    hidden = false
    local set = ButtonSets["SpecSet"]
    if set then
        if HotSwapSpecContainer then
            HotSwapSpecContainer:Show()
        end
        for _, btn in ipairs(set) do btn:Show() end
        if HotSwapSpecContainer and arrayLength(set) > 0 then
            local specSide = LARSpecSide or "TOP"
            FitClusterContainerBounds(HotSwapSpecContainer, set, specSide)
        end
    end
    set = ButtonSets["ModuleSet"]
    if set then
        if HotSwapModuleContainer then
            HotSwapModuleContainer:Show()
        end
        for _, btn in ipairs(set) do btn:Show() end
        if HotSwapModuleContainer and arrayLength(set) > 0 then
            local side = LARModuleSide or "RIGHT"
            FitClusterContainerBounds(HotSwapModuleContainer, set, side)
        end
    end
end

function HotSwap_HideButtonSets()
    if not hidden then
        local set = ButtonSets["SpecSet"]
        if set then
            for _, btn in ipairs(set) do btn:Hide() end
            if HotSwapSpecContainer then
                HotSwapSpecContainer:Hide()
            end
        end
        set = ButtonSets["ModuleSet"]
        if set then
            for _, btn in ipairs(set) do btn:Hide() end
            if HotSwapModuleContainer then
                HotSwapModuleContainer:Hide()
            end
        end
        hidden = true
    end
end

function HotSwap_RearrangeButtons()
    local specSide = LARSpecSide or "TOP"
    local specSet = ButtonSets["SpecSet"]
    if specSet then
        AnchorButtonSet(specSet, specSide, HotSwapButton)
        for _, btn in ipairs(specSet) do
            btn:SetFrameLevel(clusterIconButtonFrameLevel)
            if btn.border then
                btn.border:SetFrameLevel(btn:GetFrameLevel() + 5)
            end
        end
    end
    if specSet and HotSwapSpecContainer and arrayLength(specSet) > 0 then
        FitClusterContainerBounds(HotSwapSpecContainer, specSet, specSide)
    end
    local moduleButtons = ButtonSets["ModuleSet"]
    if moduleButtons and arrayLength(moduleButtons) > 0 then
        local groups = ButtonSets["ModuleGroups"]
        if not groups or arrayLength(groups) ~= arrayLength(moduleButtons) then
            groups = {}
            local ordered = ModuleRegistry:GetOrderedModules()
            for i, _ in ipairs(moduleButtons) do
                groups[i] = ordered[i] and ordered[i].group or nil
            end
        end
        local moduleGroupLabels = ButtonSets["ModuleGroupLabels"]
        if not moduleGroupLabels or arrayLength(moduleGroupLabels) ~= arrayLength(moduleButtons) then
            moduleGroupLabels = {}
            local ordered = ModuleRegistry:GetOrderedModules()
            for i, _ in ipairs(moduleButtons) do
                local m = ordered[i]
                moduleGroupLabels[i] = m and m.groupLabel or nil
            end
            ButtonSets["ModuleGroupLabels"] = moduleGroupLabels
        end
        local side = LARModuleSide or "RIGHT"
        AnchorModuleButtonSetWithGroups(moduleButtons, side, HotSwapButton, groups, moduleGroupLabels)
        for _, btn in ipairs(moduleButtons) do
            btn:SetFrameLevel(clusterIconButtonFrameLevel)
            if btn.border then
                btn.border:SetFrameLevel(btn:GetFrameLevel() + 5)
            end
        end
        if HotSwapModuleContainer then
            RefreshModuleGroupBackdrops(HotSwapModuleContainer, moduleButtons, groups, moduleGroupLabels, side)
            FitClusterContainerBounds(HotSwapModuleContainer, moduleButtons, side)
        end
    end
end
