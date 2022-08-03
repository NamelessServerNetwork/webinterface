return function(requestData)
    local cookieTable = {}
    local rawCookies
    local firstCookieExtracted = false

    if requestData.headers.cookie then
        rawCookies = requestData.headers.cookie.value
    else
        return false, "No cookies avaiable"
    end

    --rawCookies = string.gsub(rawCookie, " ", "")

    for rawCookie in string.gmatch(rawCookies, "[^;]+") do
        local index
        for cookie in string.gmatch(rawCookie, "[^=]+") do
            if not index then
                if firstCookieExtracted then
                    cookie = string.sub(cookie, 2)
                end
                index = cookie
            else
                cookieTable[index] = cookie
                firstCookieExtracted = true
            end
        end
    end

    return cookieTable
end