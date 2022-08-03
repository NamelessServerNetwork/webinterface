function love.quit()
	local tmp = {}

	log("SHUTTING DOWN")

	env.dl.executeDir("lua/core/shutdown", "SHUTDOWN")
	
	love.update() --printing the terminal a last time
end