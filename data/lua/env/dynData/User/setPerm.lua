return function(self, perm, level)
	local userID = self:getID()
	local db = env.loginDB
	local reason, suc = nil, nil
	
	local permSetAlready, permLevelError = self:getPerm(perm)
	
	if permSetAlready == true then
		debug.ulog("Update permission: " .. perm .. ", userID: " .. tostring(userID) .. ", to level: " .. tostring(level))
		suc = db:exec([[UPDATE permissions SET level = "]] .. tostring(level) .. [[" WHERE permission = "]] .. perm .. [[" AND userID = ]] .. tostring(userID))
	elseif permSetAlready == false then
		debug.ulog("Set permission: " .. perm .. ", userID: " .. tostring(userID) .. ", to level: " .. tostring(level))
		suc = db:exec([[INSERT INTO permissions VALUES ("]] .. tostring(userID) .. [[", "]] .. perm .. [[", ]] .. tostring(level) .. [[)]])
	else
		err("Cant set permission: " .. tostring(permSetAlready) .. " (" .. permLevelError .. ")")
		suc, reason = -50, tostring(permSetAlready) .. " (" ..  tostring(permLevelError) .. ")"
	end
	
	return suc, reason
end