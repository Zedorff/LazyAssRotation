--- @class ModuleRegistry
--- @field modules table<string, Module>
ModuleRegistry = {}
ModuleRegistry.modules = {}

--- @param module Module
function ModuleRegistry:RegisterModule(module)
    self.modules[module.name] = module
end

--- @param name string
function ModuleRegistry:EnableModule(name)
    if self.modules[name] and not self.modules[name].enabled then
        self.modules[name]:enable()
    end
end

--- @param name string
function ModuleRegistry:DisableModule(name)
    if self.modules[name] and self.modules[name].enabled then
        self.modules[name]:disable()
    end
end

--- @param name string
--- @return boolean
function ModuleRegistry:IsModuleEnabled(name)
    return self.modules[name] and self.modules[name].enabled
end

--- @return Module[]
function ModuleRegistry:GetEnabledModules()
    local active = {}
    for _, data in pairs(self.modules) do
        --- @cast data Module
        if data.enabled then
            table.insert(active, data)
        end
    end
    return active
end

function ModuleRegistry:ClearRegistry()
    self.modules = {}
end