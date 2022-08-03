local args, version = ...
local parser = require("data.lua.libs.thirdParty.argparse")("DAMS")



parser:flag("-v --version", "prints DAMS version"):target("version")
--parser:flag("-D --dev", "forces dev mode"):target("devMode")



args = parser:parse(args)

if args.version then
	print("DAMS " .. version)
	os.exit(0)
end

return args