local debugMessages = {}
local maxMessages = 200
local filterText = ""
local lineHeight = 14

-- Helper to get table size
local function tableLength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Add a message to debug history
function DebugFrame_AddMessage(msg)
    table.insert(debugMessages, msg) -- append at end (top to bottom)

    if tableLength(debugMessages) > maxMessages then
        table.remove(debugMessages, 1)
    end

    if Core.debugFrame then
        Core.debugFrame:UpdateContent()
    end
end

-- Create or show the debug frame
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

    -- Filter input box
    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -10)
    editBox:SetWidth(300)
    editBox:SetHeight(20)
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnTextChanged", function()
        filterText = editBox:GetText()
        frame:UpdateContent()
    end)
    frame.filterBox = editBox

    -- Scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "DebugScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    -- Content holder
    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(340)
    scrollFrame:SetScrollChild(content)

    -- FontString that will hold all log lines
    local fontString = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    fontString:SetPoint("TOPLEFT", 0, 0)
    fontString:SetWidth(340)
    fontString:SetJustifyH("LEFT")
    fontString:SetJustifyV("TOP")
    fontString:SetText("")
    frame.fontString = fontString
    frame.scrollFrame = scrollFrame
    frame.content = content

    -- UpdateContent function
    function frame:UpdateContent()
    -- Get font size dynamically
        local _, fontSize = self.fontString:GetFont()
        local lineHeight = fontSize

        local lines = {}
        for i = 1, tableLength(debugMessages) do
            local msg = debugMessages[i]
            if filterText == "" or string.find(string.lower(msg), string.lower(filterText), 1, true) then
                table.insert(lines, msg)
            end
        end

        self.fontString:SetText(table.concat(lines, "\n"))
        local estimatedHeight = tableLength(lines) * lineHeight + lineHeight

        local scrollHeight = self.scrollFrame:GetHeight()
        if estimatedHeight < scrollHeight then
            estimatedHeight = scrollHeight
        end

        self.content:SetHeight(estimatedHeight)
        self.fontString:SetHeight(estimatedHeight)

        self.scrollFrame:UpdateScrollChildRect()

        local maxScroll = self.scrollFrame:GetVerticalScrollRange()
        if maxScroll < 0 then maxScroll = 0 end
        self.scrollFrame:SetVerticalScroll(maxScroll)
    end

    -- Close button
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

    Core.debugFrame = frame
end
