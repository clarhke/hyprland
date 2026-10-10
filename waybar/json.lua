-- Tiny JSON writer so we don't need any libraries.
local M = {}

local function esc(s)
    return (s:gsub('[%c"\\]', function(c)
        local map = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\t'] = '\\t' }
        return map[c] or string.format("\\u%04x", c:byte())
    end))
end

function M.encode(v, indent)
    indent = indent or ""
    local t = type(v)
    if t == "string" then return '"' .. esc(v) .. '"' end
    if t == "number" or t == "boolean" then return tostring(v) end
    local inner = indent .. "    "
    if #v > 0 then   -- array
        local parts = {}
        for _, x in ipairs(v) do parts[#parts + 1] = inner .. M.encode(x, inner) end
        return "[\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "]"
    end
    local keys = {}
    for k in pairs(v) do keys[#keys + 1] = k end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do
        parts[#parts + 1] = inner .. '"' .. esc(k) .. '": ' .. M.encode(v[k], inner)
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
end

return M
