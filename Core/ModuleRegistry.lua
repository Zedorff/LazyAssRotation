--- @class ModuleRegistry
--- @field modules table<string, Module>
--- @field orderedModules Module[]
--- @field _groupStack any[] | nil
---       Stack of group names while inside RegisterGroup callbacks (Gradle-style scoped blocks).
--- @field _groupLabelStack (string | nil)[] | nil
---       Parallel to _groupStack: optional hot-swap group title (see Module.groupLabel).
ModuleRegistry = {}
ModuleRegistry.modules = {}

--- @param stack any[] | nil
--- @return any | nil
local function stackPeek(stack)
    if not stack or not stack[1] then
        return nil
    end
    local top = nil
    for _, v in ipairs(stack) do
        top = v
    end
    return top
end

--- Scoped block: all RegisterModule calls inside `callback` get `module.group = groupName`.
--- Nested RegisterGroup calls use the innermost group. Same idea as Gradle Kotlin DSL blocks.
--- Overload: `RegisterGroup(groupName, callback)` or `RegisterGroup(groupName, groupLabel, callback)`.
--- @param groupName any
--- @param groupLabelOrCallback string | fun()
--- @param callback fun() | nil
function ModuleRegistry:RegisterGroup(groupName, groupLabelOrCallback, callback)
    local groupLabel
    local cb
    if type(groupLabelOrCallback) == "function" then
        cb = groupLabelOrCallback
        groupLabel = nil
    else
        groupLabel = groupLabelOrCallback
        cb = callback
    end
    self._groupStack = self._groupStack or {}
    self._groupLabelStack = self._groupLabelStack or {}
    table.insert(self._groupStack, groupName)
    table.insert(self._groupLabelStack, groupLabel)
    cb()
    table.remove(self._groupStack)
    table.remove(self._groupLabelStack)
end

--- @param module Module
function ModuleRegistry:RegisterModule(module)
    local g = stackPeek(self._groupStack)
    if g ~= nil then
        module.group = g
    end
    local lbl = stackPeek(self._groupLabelStack)
    if lbl ~= nil and lbl ~= "" and (module.groupLabel == nil or module.groupLabel == "") then
        module.groupLabel = lbl
    end
    self.modules[module.name] = module
    table.insert(self.orderedModules, module)
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
    self.orderedModules = {}
    self._groupStack = nil
    self._groupLabelStack = nil
end

function ModuleRegistry:GetOrderedModules()
    return self.orderedModules
end