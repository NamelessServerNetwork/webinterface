local rawRequestData = ...
local convertedTable = {}

-- I have no idea what actually happens here...
-- https://stackoverflow.com/questions/20282054/how-to-urldecode-a-request-uri-string-in-lua
local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end
local unescape = function(url)
    return url:gsub("%%(%x%x)", hex_to_char)
end

-- split the string and convert it into a table
for s in string.gmatch(rawRequestData, "[^&]+") do
    local index, value
    for s2 in string.gmatch(s, "[^=]+") do
        if index == nil then
            index = s2
        else
            value = s2
        end
    end
    if value == nil then
        convertedTable[index] = ""
    else
        convertedTable[index] = unescape(string.gsub(value, "+", " "))
    end
end

return convertedTable


