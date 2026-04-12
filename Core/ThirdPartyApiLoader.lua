ThirdPartyApiLoader = {}

function ThirdPartyApiLoader.DetectUnitXP3()
    if type(UnitXP) ~= "function" then
        return false
    end
    local ok = pcall(UnitXP, "nop", "nop")
    return ok
end

function ThirdPartyApiLoader.DetectNampower()
    if type(GetCVar) ~= "function" then
        return false
    end
    local ok, val = pcall(GetCVar, "NP_EnableAuraCastEvents")
    return ok and val ~= nil
end

function ThirdPartyApiLoader.EnsureNampowerAuraCastEventsEnabled()
    if not LARNampower then
        return false
    end
    local ok, val = pcall(GetCVar, "NP_EnableAuraCastEvents")
    if ok and val ~= "1" and type(SetCVar) == "function" then
        pcall(SetCVar, "NP_EnableAuraCastEvents", "1")
    end
    return true
end

function ThirdPartyApiLoader.Load()
    LARUnitXP3 = ThirdPartyApiLoader.DetectUnitXP3()
    LARNampower = ThirdPartyApiLoader.DetectNampower()
    ThirdPartyApiLoader.EnsureNampowerAuraCastEventsEnabled()
    if LARUnitXP3 then
        Logging:Log("[LAR] UnitXP3 API enabled")
    else
        Logging:Log("[LAR] UnitXP3: fallback to default API")
    end
    if LARNampower then
        Logging:Log("[LAR] Nampower API enabled")
    else
        Logging:Log("[LAR] Nampower: fallback to default API")
    end
end
