local ose = { --operating system executions
	addUser = "expect script.exp",
}

local function run(c)
	os.execute(c)
end

run("env TEST_ONE=\"test\" TEST_TWO=\"test2\" " .. ose.addUser)

