local sqlite = env.sqlite

--===== local functions =====--
local orgPrint = print
function print(...)	
	orgPrint(...)
	return ...
end

function callback(udata,cols,values,names)
	print('exec:')
	for i=1,cols do 
		print('',names[i],values[i]) 
	end
	return 0
end

--===== local vars =====--
local db = print(sqlite.open("testDB.sqlite3"))


--===== prog start =====--
print(db:exec([[
	SELECT rowid, * FROM test
]], callback))

--===== prog end =====--
db:close()