--- @class CleaveArmsModule : CleaveBase
--- @diagnostic disable: duplicate-set-field
CleaveArmsModule = setmetatable({}, { __index = CleaveBase })
CleaveArmsModule.__index = CleaveArmsModule

--- @return CleaveArmsModule
function CleaveArmsModule.new()
    --- @class CleaveArmsModule
    return setmetatable(CleaveBase.new(), CleaveArmsModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function CleaveArmsModule:getSpecPriority(context)
    if context.rage >= 70 then
        return 50
    else
        return -1
    end
end
