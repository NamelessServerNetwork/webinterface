return function(reason, wait)
	env.event.push("STOP_PROGRAM", reason)
end