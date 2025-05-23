--- @class Module
--- @field name string
--- @field enabled boolean
Module = {}
Module.__index = Module

function Module.new(name)
    if MLDpsModuleSettings.modulesEnabled[name] == nil then
        MLDpsModuleSettings.modulesEnabled[name] = true
    end
    local instance = {
        name = name,
        enabled = MLDpsModuleSettings.modulesEnabled[name]
    }

    return setmetatable(instance, Module)
end

function Module:enable()
    self.enabled = true
    MLDpsModuleSettings.modulesEnabled[self.name] = true
end

function Module:disable()
    self.enabled = false
    MLDpsModuleSettings.modulesEnabled[self.name] = false
end

function Module:run()
    error("run() not implemented")
end

--- @param context ModuleRunContext
--- @return integer
function Module:getPriority(context)
    error("getPriority() not implementd")
end