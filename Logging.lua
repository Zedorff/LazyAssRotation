Logging = {
    debugEnabled = false
}

function Logging:ToggleDebug()
    self.debugEnabled = not self.debugEnabled
    self:Log("Debug mode: " .. tostring(self.debugEnabled))
end

function Logging:Log(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00 " .. msg .. "|r")
    end
end

function Logging:Debug(msg)
    if self.debugEnabled then
        self:Log("[DEBUG] " .. msg)
    end
end