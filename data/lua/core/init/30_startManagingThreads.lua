local env = ...

dlog("Starting event manager")
env.startFileThread("lua/threads/threadManager.lua", "THREAD_MANAGER")
dlog("Starting sharing manager")
env.startFileThread("lua/threads/sharingManager.lua", "SHARING_MANAGER")
dlog("Starting event manager")
env.startFileThread("lua/threads/eventManager.lua", "EVENT_MANAGER")
dlog("Starting event listener")
env.startFileThread("lua/threads/eventListener.lua", "EVENT_LISTENER")