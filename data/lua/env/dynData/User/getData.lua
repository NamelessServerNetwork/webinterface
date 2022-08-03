return function(self)
	local db = env.loginDB
	local userExists = false
	local errCode, reason = 0, nil
	
	local userID = self.id
	local udata = {
		username = nil,
		usermail = nil,
	}
	
	if type(tonumber(userID)) ~= "number" then
		return false, -201, "No valid userID given"
	end
	
	
	errCode = db:exec([[SELECT id, username FROM users WHERE id = "]] .. tostring(userID) .. [["]], function(_, cols, values, names)
		udata.id = values[1]
		udata.username = values[2]
	
		
		if not userExists then
			userExists = true
		elseif userExists then
			err("Multiple users with same userID are existing: " .. username .. "; userID: " .. tostring(userID))
			errCode = -301
			reason = "Multiple user with same userID are existing."
		end
		return 0
	end)
	
	if errCode == 0 and userExists then
		return udata
	elseif errCode == 0 then
		return false, -202, "User not found by userID"
	else
		return false, errCode, reason
	end
end