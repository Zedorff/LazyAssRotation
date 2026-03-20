--- @class BloodthirstArmsModule : BloodthirstBase
--- @diagnostic disable: duplicate-set-field
BloodthirstArmsModule = setmetatable({}, { __index = BloodthirstBase })
BloodthirstArmsModule.__index = BloodthirstArmsModule

--- @return BloodthirstArmsModule
function BloodthirstArmsModule.new()
    --- @class BloodthirstArmsModule
    return setmetatable(BloodthirstBase.new(false), BloodthirstArmsModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function BloodthirstArmsModule:getSpecPriority(context)
    return 80
end
