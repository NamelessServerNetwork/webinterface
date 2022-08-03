#!/bin/lua

local args = {...}
local threadID = args[1]
local exec = os.execute

local username, currentPasswd, newPasswd1, newPasswd2 = "testuser", "tt", "passwd", "passwd"

local execString = [[env \
DAMS_USER_]] .. tostring(threadID) .. [[="]] .. username .. [[" \
DAMS_PASSWD_]] .. tostring(threadID) .. [[="]] .. currentPasswd .. [[" \
DAMS_NEWPASSWD1_]] .. tostring(threadID) .. [[="]] .. newPasswd1 .. [[" \
DAMS_NEWPASSWD2_]] .. tostring(threadID) .. [[="]] .. newPasswd2 .. [[" \
./changePasswd.exp ]] .. tostring(threadID) 

print(execString)
print("=====")


print(exec(execString))

--env DAMS_USER_" .. tostring(threadID) .. "="test" DAMS_PASSWD1_" .. tostring(threadID) .. "=" ./changePasswd.exp " .. threadID)