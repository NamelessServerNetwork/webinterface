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
	INSERT INTO test VALUES ("test1", "sec test1");
]], callback))

print(db:exec([[
	INSERT INTO test VALUES ("test2", "sec test2");
]], callback))

print(db:exec([[
	INSERT INTO test VALUES ("test3", NULL);
]], callback))


--===== prog end =====--
db:close()