log("Open user DB")
env.loginDB = env.lib.sqlite.open(env.devConf.userLoginDatabasePath)