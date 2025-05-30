--- @class ModuleButtonInfo
--- @field icon string
--- @field name string
--- @field enabled boolean

ModuleButtonInfo = {}
ModuleButtonInfo.__index = ModuleButtonInfo

--- @return ModuleButtonInfo
function ModuleButtonInfo.new(icon, name, enabled)
    local self = {
        icon = icon,
        name = name,
        enabled = enabled
    }
    --- @type ModuleButtonInfo
    return setmetatable(self, ModuleButtonInfo)
end
