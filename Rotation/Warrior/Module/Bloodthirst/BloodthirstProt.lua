--- @class BloodthirstProtModule : BloodthirstBase
--- @diagnostic disable: duplicate-set-field
BloodthirstProtModule = setmetatable({}, { __index = BloodthirstBase })
BloodthirstProtModule.__index = BloodthirstProtModule

--- @return BloodthirstProtModule
function BloodthirstProtModule.new()
    --- @class BloodthirstProtModule
    return setmetatable(BloodthirstBase.new(false), BloodthirstProtModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function BloodthirstProtModule:getSpecPriority(context)
    return 85
end
