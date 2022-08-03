env.loginDB:exec([[
	SELECT * FROM sysinfo
]], function(udata,cols,values,names)
	print('sysinfo:')
	for i=1,cols do 
		print('',tostring(names[i]) .. ": " .. tostring(values[i])) 
	end
	return 0
end)