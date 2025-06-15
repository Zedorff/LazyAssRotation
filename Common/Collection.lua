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

--- @generic T
--- @param arr1 T[]
--- @param arr2 T[]
--- @return T[]
function Collection.combine(arr1, arr2)
    local result = {}
    for _, v in ipairs(arr1) do table.insert(result, v) end
    for _, v in ipairs(arr2) do table.insert(result, v) end
    return result
end

--- @generic T
--- @param t T[]
--- @return T[]
function Collection.shallowCopy(t)
    local copy = {}
    for i, v in ipairs(t) do
        copy[i] = v
    end
    return copy
end