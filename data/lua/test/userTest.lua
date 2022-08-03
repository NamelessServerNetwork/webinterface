debug.setLogPrefix("[USER_TEST]")
log("start User test")

env.dl.load({
    target = env.dyn.User,
    dir = "./data/env/dynData/User",
    name = "User",
})

