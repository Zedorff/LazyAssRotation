---@diagnostic disable: undefined-field, param-type-mismatch, inject-field
local debugMessages = {}
local maxMessages = 200
local filterText = ""

local function arrayLen(t)
    local n = 0
    while t[n + 1] ~= nil do
        n = n + 1
    end
    return n
end

function DebugFrame_AddMessage(msg)
    table.insert(debugMessages, msg)

    while arrayLen(debugMessages) > maxMessages do
        table.remove(debugMessages, 1)
    end

    if Core.debugFrame then
        Core.debugFrame:UpdateContent(true)
    end
end

function DebugFrame_Create()
    if Core.debugFrame then
        Core.debugFrame:Show()
        return
    end

    local frame = CreateFrame("Frame", "DebugFrame", UIParent)
    frame:SetWidth(400)
    frame:SetHeight(300)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.8)

    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function()
        frame:Hide()
    end)

    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -10)
    editBox:SetPoint("TOPRIGHT", close, "TOPLEFT", -4, 0)
    editBox:SetHeight(20)
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnTextChanged", function()
        filterText = editBox:GetText()
        frame:UpdateContent(false)
    end)
    frame.filterBox = editBox

    local scrollFrame = CreateFrame("ScrollFrame", "DebugScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 12)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(340)
    scrollFrame:SetScrollChild(content)

    local fontString = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    fontString:SetPoint("TOPLEFT", 0, 0)
    fontString:SetWidth(340)
    fontString:SetJustifyH("LEFT")
    fontString:SetJustifyV("TOP")
    fontString:SetText("")
    frame.fontString = fontString
    frame.scrollFrame = scrollFrame
    frame.content = content

    function frame:UpdateContent(scrollToBottom)
        local _, fontSize = self.fontString:GetFont()
        local lineHeight = fontSize

        local prevScroll = self.scrollFrame:GetVerticalScroll()

        local lines = {}
        for i = 1, arrayLen(debugMessages) do
            local msg = debugMessages[i]
            if filterText == "" or string.find(string.lower(msg), string.lower(filterText), 1, true) then
                table.insert(lines, msg)
            end
        end

        self.fontString:SetText(table.concat(lines, "\n"))
        local estimatedHeight = arrayLen(lines) * lineHeight + lineHeight

        local scrollHeight = self.scrollFrame:GetHeight()
        if estimatedHeight < scrollHeight then
            estimatedHeight = scrollHeight
        end

        self.content:SetHeight(estimatedHeight)
        self.fontString:SetHeight(estimatedHeight)

        self.scrollFrame:UpdateScrollChildRect()

        local maxScroll = self.scrollFrame:GetVerticalScrollRange()
        if maxScroll < 0 then maxScroll = 0 end
        if scrollToBottom then
            self.scrollFrame:SetVerticalScroll(maxScroll)
        else
            self.scrollFrame:SetVerticalScroll(math.min(prevScroll, maxScroll))
        end
    end

    Core.debugFrame = frame
end
