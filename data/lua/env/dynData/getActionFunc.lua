return function(path) --generates avtion/site functions.
    local siteCode = env.lib.ut.readFile(path)
    local tracebackPathNote = path

    if not siteCode then
        return false, "File not found"
    end

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "userData")) + 2)

    siteCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local requestData, cookie, Session = args[1], env.cookie, env.dyn.Session; " .. siteCode
    
    return load(siteCode)
end