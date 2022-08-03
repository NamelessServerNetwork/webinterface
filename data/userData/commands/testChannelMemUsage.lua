local channel = env.lib.thread.getChannel("TEST")

for c = 0, 100000 do
	channel:push("tttttttttttttttttttttttttttttttttttttt")
end