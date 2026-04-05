NampowerBuffCommon = {}

function NampowerBuffCommon.SkipRemovalForRefresh(arg7)
    return arg7 == 2
end

function NampowerBuffCommon.DurationSecFromAuraCast(arg8, fallbackSec)
    return Helpers:DurationFromAuraCastMs(arg8) or fallbackSec
end
