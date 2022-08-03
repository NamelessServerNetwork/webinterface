local argparse = require("argparse")
local parser = argparse("TEST SCRIPT", "This is a test script", "EPILOG")

parser:option("-o --option", "test_option", "default"):target("target") --bug: sometimes dont take default value?



local args = parser:parse()
for i, c in pairs(args) do
	print(i, c)
end
