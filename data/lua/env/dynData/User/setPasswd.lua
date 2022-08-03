return function(self, passwd)
	local userID = self:getID()
	local db = env.loginDB
	local reason, suc = nil, nil
	local execString = ""
	
	debug.ulog("Set passwd: userID: " .. tostring(userID))

	--log(type(env.hashPasswd(passwd)))

	suc = db:exec([[UPDATE users SET password = "]] .. env.hashPasswd(passwd) .. [[" WHERE id = ]] .. tostring(userID))
	
	return suc, reason
end