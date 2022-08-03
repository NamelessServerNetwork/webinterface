local argparse = require("argparse")
local parser = argparse("TEST SCRIPT", "This is a test script", "EPILOG")


parser:argument("test_arg", "Test_arg"):args(1)
parser:argument("test_opt_arg", "Test_opt_arg"):args("+", "*")

parser:flag("-t --test", "test_flag")
parser:flag("-s --sec-test", "sec_test_flag")

parser:option("-o --option", "test_option", "default"):target("target") --bug: sometimes dont take default value?
parser:option("-g", "test_option")



local args = parser:parse()
for i, c in pairs(args) do
	print(i, c)
end
