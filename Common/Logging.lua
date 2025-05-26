Logging = {
    debugEnabled = false
}

function Logging:ToggleDebug()
    self.debugEnabled = not self.debugEnabled

    if self.debugEnabled then
        DebugFrame_Create()
        Core.debugFrame:Show()
    elseif Core.debugFrame then
        Core.debugFrame:Hide()
    end
end

--- @param msg string
function Logging:Log(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00 " .. msg .. "|r")
    end
end

--- @param msg string
function Logging:Debug(msg)
    if self.debugEnabled and Core.debugFrame then
        local timestamp = date("%H:%M:%S")  -- current time in 24h format
        DebugFrame_AddMessage("[" .. timestamp .. "] " .. msg)
    end
end