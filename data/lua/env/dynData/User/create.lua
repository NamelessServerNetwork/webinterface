return function(username, password)
	local db = env.loginDB
	local createUser, reason, suc = true, nil, nil
	local userID = nil
	
	if type(username) ~= "string" or username == "" then
		return -1, "No valid username given"
	end
	if type(password) ~= "string" or password == "" then
		return -2, "No valid password given"
	end
	
	log("Try to create user: \"" .. username .. "\"")
	
	db:exec([[SELECT username FROM users WHERE username = "]] .. username .. [["]], function(udata, cols, values, names)
		createUser = false
		suc = -101
		reason = "Username already taken"
		return 0
	end)
	
	db:exec([[SELECT userCount FROM sysinfo]], function(udata, cols, values, names)
		userID = tonumber(values[1]) +1
		return 0
	end)
	
	db:exec([[SELECT userCount FROM sysinfo WHERE userCount = "]] .. tostring(userID) .. [["]], function(udata, cols, values, names)
		createUser = false
		suc = -301
		reason = "UserID already taken"
		return 0
	end)
	
	if createUser then
		log("Create userDB entry: username: \"" .. username .. "\", ID: " .. tostring(userID) .. "")
		
		suc = db:exec([[INSERT INTO users VALUES ("]] .. username .. [[", "]] .. env.hashPasswd(password) .. [[", ]] .. tostring(userID) .. [[)]])
	end
	
	if createUser ~= true or suc ~= 0 then
		if suc < 0 then
			err("Can't create user: \"" .. username .. "\" (" .. tostring(userID) .. "); code: " .. tostring(suc) .. "; " .. tostring(reason))
		else
			log("Can't create user: \"" .. username .. "\" (" .. tostring(userID) .. "); code: " .. tostring(suc) .. "; " .. tostring(reason))
		end
	else
		suc = db:exec([[UPDATE sysinfo SET userCount = ]] .. tostring(userID) .. [[]])
	end
	
	return suc, reason
end