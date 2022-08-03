local env, args = ...
local username, password = args[1], args[2]


log(env.addUser(username, password))