print("SQL_TEST")

local timer = require("love.timer")

local sql = require("lsqlite3complete")

--local db = sql.open("db/testDB.sqlite3")
local db = sql.open("db/chinook.db")

local sqlCommand = ""

--[[
sqlCommand = [=[
          CREATE TABLE numbers(num1,num2,str);
          INSERT INTO numbers VALUES(1,11,"ABC");
          INSERT INTO numbers VALUES(2,22,"DEF");
          INSERT INTO numbers VALUES(3,33,"UVW");
          INSERT INTO numbers VALUES(4,44,"XYZ");
          SELECT * FROM numbers;
        ]=]
]]

sqlCommand = [[
SELECT * FROM tracks;
]]

function showrow(udata,cols,values,names)
	print('exec:')
	for i=1,cols do 
		print('',names[i],values[i]) 
	end
	return 0
end
print(db:exec(sqlCommand, showrow))



timer.sleep(.1)
db:close()
os.exit(0)