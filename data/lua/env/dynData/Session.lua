local Session = {}

function Session.new(sessionLogin)
    local self = setmetatable({}, {__index = Session})

    local seperatorPos = string.find(sessionLogin, "[$]") or math.huge

    local sessionID = string.sub(sessionLogin, 0, seperatorPos - 1)
    local token = string.sub(sessionLogin, seperatorPos + 1)

    self.sessionData = {}
    self.sessionData.sessionID = sessionID

    if sessionID == "" or token == "" then
        return false, -12, "No valid session token given"
    end

    errCode = env.loginDB:exec([[SELECT token, userID, expireTime FROM sessions WHERE sessionID = "]] .. sessionID .. [["]], function(_, cols, values, names)
        for index, name in ipairs(names) do
            self.sessionData[name] = values[index]
        end
		return 0
	end)

    if errCode ~= 0 then
        return false, errCode
    end

    if not self.sessionData.userID then
        return false, -10, "sessionID not found"
    end

    if tonumber(self.sessionData.expireTime) ~= -1 and tonumber(self.sessionData.expireTime) < os.time() then
        if env.devConf.session.deleteExpiredSessions then
            self:delete()
        end

        return false, -11, "sessionID expired"
    end

    if not env.verifyPasswd(self.sessionData.token, token) then
        return false, -13, "Can not verify session token"
    end

    return self
end

function Session.create(user, expireTime) --expireTime in seconds ongoing from 1970 00:00:00 UTC (os.time(...) in unix systems) or a time table.
    local token = env.lib.ut.randomString(32)
    local sessionID = env.lib.ut.randomString(32)
    local suc

    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end
    
    --print([[INSERT INTO sessions VALUES ("]] .. sessionID .. [[", "]] .. env.hashPasswd(token) .. [[", ]] .. expireTime ..[[, ]] .. tostring(user:getID()) .. [[)]])

    suc = env.loginDB:exec([[INSERT INTO sessions VALUES ("]] .. sessionID .. [[", "]] .. env.hashPasswd(token) .. [[", ]] .. expireTime ..[[, ]] .. tostring(user:getID()) .. [[)]])

    if suc ~= 0 then
        return false, suc
    else
        return true, Session.new(sessionID .. "$" .. token), sessionID .. "$" .. token
    end
end


function Session:getSessionID()
    return self.sessionData.sessionID
end

function Session:renew(expireTime)
    local suc

    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end

    if type(expireTime) ~= "number" then
        error("Invalid expire time given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET expireTime = ]] .. tostring(expireTime) .. [[ WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:delete()
    local suc

    suc = env.loginDB:exec([[DELETE FROM sessions WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end


return Session