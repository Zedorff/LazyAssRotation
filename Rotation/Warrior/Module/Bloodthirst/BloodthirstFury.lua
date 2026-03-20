--- @class BloodthirstFuryModule : BloodthirstBase
--- @diagnostic disable: duplicate-set-field
BloodthirstFuryModule = setmetatable({}, { __index = BloodthirstBase })
BloodthirstFuryModule.__index = BloodthirstFuryModule

--- @return BloodthirstFuryModule
function BloodthirstFuryModule.new()
    --- @class BloodthirstFuryModule
    return setmetatable(BloodthirstBase.new(true), BloodthirstFuryModule)
end

--- @param context WarriorModuleRunContext
--- @return integer
function BloodthirstFuryModule:getSpecPriority(context)
    return 90
end
