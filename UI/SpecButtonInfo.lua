--- @class SpecButtonInfo
--- @field icon string
--- @field name string
--- @field enabled boolean

SpecButtonInfo = {}
SpecButtonInfo.__index = SpecButtonInfo

--- @return SpecButtonInfo
function SpecButtonInfo.new(icon, name, enabled)
    local self = {
        icon = icon,
        name = name,
        enabled = enabled
    }
    --- @type SpecButtonInfo
    return setmetatable(self, SpecButtonInfo)
end
