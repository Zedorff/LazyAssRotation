--- @class ExecuteModule : Module
--- @diagnostic disable: duplicate-set-field
ExecuteModule = setmetatable({}, { __index = Module })
ExecuteModule.__index = ExecuteModule

--- @return ExecuteModule
function ExecuteModule.new()
    --- @class ExecuteModule
    return setmetatable(Module.new(ABILITY_EXECUTE), ExecuteModule);
end

function ExecuteModule:run()
    Logging:Debug("Casting Execute")
    CastSpellByName(ABILITY_EXECUTE)
end

function ExecuteModule:getPriority()
    if self.enabled then
        if Helpers:ShouldUseExecute() then
            return 1000; --- Max priority always!
        else
            return -1;
        end
    else
        return -1;
    end
end
