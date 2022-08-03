local ose = { --operating system executions
	addUser = "expect addUser.exp",
}

local function run(c)
	os.execute(c)
end

local function addUser(name, passwd)
	run("env DAMS_USER=\"" .. name .. "\" DAMS_PASSWD=\"" .. passwd .. "\" " .. ose.addUser)	
end

addUser("testuser", "test")
