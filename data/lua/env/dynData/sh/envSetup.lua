return function(envTable)
    local execString = "env "

    for index, value in pairs(envTable) do
        execString = execString .. index .. "=\"" .. tostring(value) .. "\" " 
    end

    return execString
end