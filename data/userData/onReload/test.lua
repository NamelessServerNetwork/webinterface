do return end

log("TEST")

env.shared.t1 = {}
env.shared.t1.t2 = {}
env.shared.t1.t2.test = "test var"
env.shared.t1.t2[1] = "1"

log(env.shared.t1.t2.test)
log(env.shared.t1.t2[1])
