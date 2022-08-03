--[[
return function(func, ...)
	print(func, ...)
	return function()
		call(func, ...)
	end
end
]]