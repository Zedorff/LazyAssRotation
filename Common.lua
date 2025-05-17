-- Print
Common = {}

function Common:Print(msg)
    local coloredMessage = "|c00FFFF00" .. msg .. "|r"
    if (not DEFAULT_CHAT_FRAME) then
        return;
    end
    DEFAULT_CHAT_FRAME:AddMessage(coloredMessage);
end

function Common:Debug(msg)
    if (Common["Debug"]) then
        if (not DEFAULT_CHAT_FRAME) then
            return;
        end
        DEFAULT_CHAT_FRAME:AddMessage(msg);
    end
end