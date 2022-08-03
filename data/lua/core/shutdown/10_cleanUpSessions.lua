if env.devConf.session.cleanupExpiredSessionsAtShutdown then
    log("Cleanup expired sessions")
    log(env.loginDB:exec([[DELETE FROM sessions WHERE expireTime != -1 AND expireTime <= ]] .. os.time() .. [[]]))
end