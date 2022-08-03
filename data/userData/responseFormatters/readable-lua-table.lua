local responseData = ...

if responseData.returnValue and responseData.returnValue.html then
    responseData.returnValue.html = nil
end

return env.lib.ut.tostring(responseData)