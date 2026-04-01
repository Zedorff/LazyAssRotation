--- @class Module
--- @field name string
--- @field enabled boolean
--- @field trackers table<string, table>
--- @field iconPath string
--- @field group any | nil
--- @field groupLabel string | nil
Module = {}
Module.__index = Module

--- @param name string
--- @param trackers table<string, table>?
--- @param iconPath string
--- @param enabledByDefault boolean | nil
--- @param groupLabel string | nil
function Module.new(name, trackers, iconPath, enabledByDefault, groupLabel)
    if LARModuleSettings.modulesEnabled[name] == nil then
        LARModuleSettings.modulesEnabled[name] = enabledByDefault or true
    end
    local self = {
        name = name,
        enabled = LARModuleSettings.modulesEnabled[name],
        trackers = trackers or {},
        iconPath = iconPath,
        group = nil,
        groupLabel = groupLabel
    }

    if self.enabled then
        for _, tracker in pairs(self.trackers) do
            tracker:subscribe()
        end
    end

    return setmetatable(self, Module)
end

function Module:enable()
    self.enabled = true
    LARModuleSettings.modulesEnabled[self.name] = true
    for _, tracker in pairs(self.trackers) do
        tracker:subscribe()
    end
end

function Module:disable()
    self.enabled = false
    LARModuleSettings.modulesEnabled[self.name] = false
    for _, tracker in pairs(self.trackers) do
        tracker:unsubscribe()
    end
end

function Module:run()
    error("run() not implemented")
end

--- @param context ModuleRunContext
--- @return integer
function Module:getPriority(context)
    error("getPriority() not implementd")
end
