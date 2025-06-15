--- @class ExecuteModule : Module
--- @diagnostic disable: duplicate-set-field
ExecuteModule = setmetatable({}, { __index = Module })
ExecuteModule.__index = ExecuteModule

--- @return ExecuteModule
function ExecuteModule.new()
    --- @class ExecuteModule
    return setmetatable(Module.new(Abilities.Execute.name, nil, "Interface\\Icons\\INV_Sword_48"), ExecuteModule);
end

function ExecuteModule:run()
    Logging:Debug("Casting "..Abilities.Execute.name)
    _ = SpellStopCasting()
    CastSpellByName(Abilities.Execute.name)
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
