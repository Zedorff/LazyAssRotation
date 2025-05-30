function MinimapButton_OnLoad()
    this:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    this:Show()
end

function MinimapButton_OnClick()
    if arg1 == "LeftButton" then
        Logging:ToggleDebug()
    else
        SettingsFrame:Show()
    end
end

function MinimapButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cffffff00Lazy Ass Rotation|r") 
    GameTooltip:AddLine(" ", 1, 1, 1)
    GameTooltip:AddLine("Right-click to toggle modules", 1, 1, 1)
    GameTooltip:AddLine("Left-click to toggle debug mode", 1, 1, 1)
    GameTooltip:Show()
end

function MinimapButton_OnLeave()
    GameTooltip:Hide()
end
