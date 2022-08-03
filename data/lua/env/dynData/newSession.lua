return function(userData)
	local sessionID = env.ut.randomString(32)
	local user
	
	while env.getSession(sessionID) ~= nil do
		sessionID = env.ut.randomString(32)
	end
	
	userData.loginToken = sessionID
	user = env.User.new(userData)
	env.shared.openSessions[sessionID] = user:getData()
	
	return sessionID
end