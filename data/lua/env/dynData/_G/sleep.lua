local env = ...

_G.sleep = env.timer.sleep

return env.timer.sleep