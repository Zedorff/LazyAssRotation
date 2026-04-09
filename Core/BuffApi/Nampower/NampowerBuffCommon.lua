NampowerBuffCommon = {}

--- Nampower emits removal on refresh and on real fade. `arg7` on `BUFF_REMOVED_SELF` / `DEBUFF_REMOVED_OTHER`
--- is a removal reason; `2` means refresh (reapply). When true, callers should ignore the event.
--- @param arg7 unknown|nil removal reason on buff/debuff removed events
--- @return boolean
function NampowerBuffCommon.SkipRemovalForRefresh(arg7)
    return arg7 == 2
end

--- Uses `Helpers:DurationFromAuraCastMs` for Nampower `AURA_CAST_ON_SELF` / `AURA_CAST_ON_OTHER` `arg8` (ms);
--- falls back to `fallbackSec` when missing or invalid.
--- @param arg8 unknown|nil aura duration ms
--- @param fallbackSec number
--- @return number
function NampowerBuffCommon.DurationSecFromAuraCast(arg8, fallbackSec)
    return Helpers:DurationFromAuraCastMs(arg8) or fallbackSec
end
