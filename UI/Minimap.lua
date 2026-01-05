local function LAR_MinimapButton_UpdatePosition()
    local btn = LAR_MinimapButton
    if not btn then return end

    local angle = math.mod(LARMinimapAngle or 220, 360)
    local rad = angle * math.pi / 180

    btn:ClearAllPoints()
    btn:SetPoint("CENTER", Minimap, "CENTER",
        math.cos(rad) * 80,
        math.sin(rad) * 80
    )
    btn:Show()
end

function LAR_MinimapButton_OnLoad()
    LAR_MinimapButton:RegisterEvent("VARIABLES_LOADED");
    LAR_MinimapButton:SetScript("OnEvent", function()
        LAR_MinimapButton_OnEvent(event)
    end)
end

function LAR_MinimapButton_OnEvent(event)
    if event == "VARIABLES_LOADED" then
       LAR_MinimapButton_UpdatePosition()
    end
end

function LAR_MinimapButton_OnDragStart()
    LAR_MinimapButton:SetScript("OnUpdate", function()
        local x, y = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        x = x / scale
        y = y / scale

        local mx, my = Minimap:GetCenter()
        local dx = x - mx
        local dy = y - my

        local angle = math.deg(math.atan2(dy, dx))
        if angle < 0 then angle = angle + 360 end

        LARMinimapAngle = angle
        LAR_MinimapButton_UpdatePosition()
    end)
end

function LAR_MinimapButton_OnDragStop()
    LAR_MinimapButton:SetScript("OnUpdate", nil)
end

function LAR_MinimapButton_OnClick()
    if arg1 == "LeftButton" then
        if LAR_SettingsFrame then
            LAR_SettingsFrame:Show()
        end
    else
        if Logging and Logging.ToggleDebug then
            Logging:ToggleDebug()
        end
    end
end

function LAR_MinimapButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("|cffffff00Lazy Ass Rotation|r")
    GameTooltip:AddLine(" ", 1, 1, 1)
    GameTooltip:AddLine("Left-click: open settings", 1, 1, 1)
    GameTooltip:AddLine("Right-click: toggle debug", 1, 1, 1)
    GameTooltip:Show()
end

function LAR_MinimapButton_OnLeave()
    GameTooltip:Hide()
end
