return function(self)
	local userData = {}
	for i, v in pairs(self) do
		if type(v) ~= "function" then
			userData[i] = v
		end
	end
	return userData
end