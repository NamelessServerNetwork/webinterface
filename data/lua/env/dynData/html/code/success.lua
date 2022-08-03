return function(requestData)
    local returnString = [[
<html>
    <head>
        <title>Success!</title>  
    </head>    
    <h3>Success!</h3>
]]

    if requestData.headers.referer then
        local referer = requestData.headers.referer.value

        returnString = returnString .. [[
<body>     
    <a href="]]..referer..[[">  
        <input type="button" value="Go back"/>  
    </a>    
</body>    
]] 
    end
    
    return returnString .. "\n</html>"
end