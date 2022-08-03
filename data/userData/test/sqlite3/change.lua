local sqlite = require("lsqlite3complete")

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
	UPDATE test SET first_val = "test4" WHERE rowid = 4
]], callback))


--===== prog end =====--
db:close()