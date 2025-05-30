--- @class Module
--- @field name string
--- @field enabled boolean
--- @field trackers table<string, table>
--- @field iconPath string
Module = {}
Module.__index = Module

--- @param name string
--- @param trackers table<string, table>?
--- @param enabledByDefault boolean | nil
function Module.new(name, trackers, iconPath, enabledByDefault)
    if MLDpsModuleSettings.modulesEnabled[name] == nil then
        MLDpsModuleSettings.modulesEnabled[name] = enabledByDefault or true
    end
    local self = {
        name = name,
        enabled = MLDpsModuleSettings.modulesEnabled[name],
        trackers = trackers or {},
        iconPath = iconPath
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
    MLDpsModuleSettings.modulesEnabled[self.name] = true
    for _, tracker in pairs(self.trackers) do
        tracker:subscribe()
    end
end

function Module:disable()
    self.enabled = false
    MLDpsModuleSettings.modulesEnabled[self.name] = false
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