local Body = {}

local parseArgs = env.lib.ut.parseArgs

function Body.new()
    local self = setmetatable({}, {__index = Body})

    self.content = {
        "<!DOCTYPE html> \n<html>",
    }

    return self
end

function Body:addRaw(text)
    local html = "\n" .. text .. "\n"
    table.insert(self.content, html)
    return html
end

function Body:addRefButton(name, link)
    local html = [[
<a href="]]..link..[[">  
    <input type="button" value="]]..name..[["/>  
</a> 
]]
    table.insert(self.content, html)
    return html
end

function Body:addGoBackButton(name, requestData)
    local html
    if requestData.headers and requestData.headers.referer then
        local referer = requestData.headers.referer.value 
        html = [[
<a href="]]..referer..[[">  
    <input type="button" value="]]..name..[["/>  
</a> 
]]
    else
        html = [[
<p>(Go back error. Please contact an admin.)</p>
]]
    end
    table.insert(self.content, html)
    return html
end

function Body:addAction(link, method, actions)
    local actionString = [[<form action="]]..link..[[" method="]]..method..[[">]]
    for _, action in pairs(actions) do
        if action[1] == "input" then
            local target = parseArgs(action.target, action.id, action.name)
            local type = parseArgs(action.type, "text")
            local value = parseArgs(action.value, "")
            local name = parseArgs(action.name, "")
            actionString = actionString .. [[
<div>
    <label for="]]..name..[[">]]..name..[[</label>
    <input type="]]..type..[[" name="]]..target..[[" value="]]..value..[[">
</div>
]]
        elseif action[1] == "hidden" then
            local target = parseArgs(action.target, action.id, action.name)
            actionString = actionString .. [[
<div>
    <input type="hidden" name="]]..target..[[" value="]]..action.value..[[">
</div>
]]
        elseif action[1] == "textarea" then
            actionString = actionString .. [[
<div>
    <textarea for="]]..action.name..[[" name="]]..action.name..[[">]]..action.value..[[</textarea>
</div>
]]
        elseif action[1] == "button" or action[1] == "submit" then
            local type = parseArgs(action.type, action[1])
            local value = parseArgs(action.value, action.name)
            actionString = actionString .. [[
<div>
    <button type="]]..type..[[">]]..value..[[</button>
</div>
]]
        end
    end
    table.insert(self.content, actionString)
    return actionString
end

function Body:addHeader(level, text)
    local html = [[
<h]]..tostring(level)..[[>]]..tostring(text)..[[</h]]..tostring(level)..[[>
    ]]
    table.insert(self.content, html)
end

function Body:addReturnButton(text, requestData)
    local html 
    if requestData.headers and requestData.headers.referer then
        local referer = requestData.headers.referer.value 
        html = [[
<a href="]]..referer..[[">  
    <input type="button" value="]]..tostring(text)..[["/>  
</a>     
]]
    else
        html = [[
<p>(Return button error. Please contact an admin.)</p>
]]
    end
    table.insert(self.content, html)
    return html
end

function Body:addP(text)
    local html = [[
<p>]]..tostring(text)..[[</p>
]]
    table.insert(self.content, html)
    return html
end 

function Body:addLink(link, name)
    local html = [[
<a href="]] .. link .. [[">]] .. parseArgs(name, link) .. [[</a>
]]
    table.insert(self.content, html)
    return html
end


function Body:goTo(link, delay)
    local html = [[
<meta http-equiv="Refresh" content="]]..tostring(delay or 0)..[[; url=']]..link..[['" />
]]
    table.insert(self.content, html)
    return html
end

function Body:goBack(requestData, delay)
    local html
    if requestData.headers and requestData.headers.referer then
        local referer = requestData.headers.referer.value 
        html = [[
<meta http-equiv="Refresh" content="]]..tostring(delay or 0)..[[; url=']]..referer..[['" />
]]
    else
        html = [[
<p>(Go back error. Please contact an admin.)</p>
]]
    end
    table.insert(self.content, html)
    return html
end

function Body:generateCode()
    local htmlCode = ""
    for _, c in pairs(self.content) do
        htmlCode = htmlCode .. c
    end
    return htmlCode .. "</html>"
end

return Body