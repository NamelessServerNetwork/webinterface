return function(udata,cols,values,names)
	print('exec:')
	for i=1,cols do 
		print('',names[i],values[i]) 
	end
	return 0
end