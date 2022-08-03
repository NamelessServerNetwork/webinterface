local crypto = require("crypto")

local key = crypto.pkey.generate("rsa", 128)
local keys = key:to_pem()
local fkey = crypto.digest("MD5", keys)

--local publicKey2, privateKey2 = crypto.pkey.generate("dsa", 256)

print(key)
print(keys)
print(fkey)

local test = crypto.encrypt("AES128", "test msg", fkey, "tttttttttttttttt")

local file = io.open("tt", "w")
file:write(test)
file:close()

local file = io.open("key", "w")
file:write(keys)
file:close()

local file = io.open("tt", "rb")

print(crypto.decrypt("AES128", test, fkey, "tttttttttttttttt"))
--print(crypto.decrypt("AES256", file:read("*all"), key))

file:close()



os.exit(0)