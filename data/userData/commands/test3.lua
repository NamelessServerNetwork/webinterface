--local env = ...

--[[
print("TEST 3")

print("ARGS: ", ...)

io.write("TW")
io.flush()
io.write("TW2")

ldlog("LDLOG")

io.stdout:write("STDOUT")
io.stderr:write("STDERR")

io.flush()
]]
--print(env)

--print(env.lib.ut.tostring(env))

--env.startFileThread("TEST", "TEST_THREAD")
