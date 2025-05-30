Collection = {}

--- Maps a function over a list and returns a new list.
--- @generic T, R
--- @param input T[]          -- Input array of type T
--- @param fn fun(item: T): R -- Mapping function from T to R
--- @return R[]               -- Output array of type R
function Collection.map(input, fn)
    local output = {}
    for i, v in ipairs(input) do
        output[i] = fn(v)
    end
    return output
end

--- @param input table     -- Any Lua table (list or dictionary)
--- @return integer        -- Number of key-value pairs
function Collection.size(input)
    local count = 0
    for _ in pairs(input) do
        count = count + 1
    end
    return count
end