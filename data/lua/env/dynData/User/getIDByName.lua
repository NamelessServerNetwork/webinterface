return function(username)
	local db = env.loginDB
	local userExists = false
	local errCode, reason = nil, nil
	local userID = nil
	
	if type(username) ~= "string" or username == "" then
		return false, -1, "No valid username given"
	end
	
	--dlog("Try to get user by name: \"" .. username .. "\"")
	
	--check user existance.
	errCode = db:exec([[SELECT id FROM users WHERE username = "]] .. username .. [["]], function(udata, cols, values, names)
		userID = tonumber(values[1])
		
		if not userExists then
			userExists = true
		elseif userExists then
			err("Multiple users with same username are existing: " .. username)
			errCode = -302
			reason = "Multiple user with same username are existing."
		end
		return 0
	end)
	
	if errCode ~= 0 and errCode ~= nil then --if something went wrong
		return false, errCode, reason
	elseif type(userID) == "number" then --if anything is fine
		return true, userID
	end
	return false, -4, "username not found" --if the username can not be found
end