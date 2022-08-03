local env, args = ...


env.commands.rlenv(env, {}, {})



local user, reason = env.dyn.User.new(1)
print(env.lib.ut.tostring(user), reason)

print(user:checkPassword("123"))

--print(env.dyn.User.checkPassword({id=1}, "123"))

--tret

--print(getUserIDByName(args[1]))
--print(login(args[1], args[2]))