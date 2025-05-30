function MLDpsMinimapButton_OnLoad()
    this:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    this:Show()
end

function MLDpsMinimapButton_OnClick()
    if arg1 == "LeftButton" then
        Logging:ToggleDebug()
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
