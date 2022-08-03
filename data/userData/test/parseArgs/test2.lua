
--===== conf =====--
local conf = {
	paths = {
		fragments = "fragments",
		input = "input",
		output = "output",
	}
}

--===== argparse =====--
-- The MIT License (MIT)

-- argparse Copyright (c) 2013 - 2018 Peter Melnichenko

-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
local argparse = {}
do 
	
end

--===== local vars =====--
local fs = require("lfs")
local loadedFragments = {}
local parser = argparse("exportReadme")
local args

--===== local functions =====--
local function readFile(path)
	local fileString
	local file = io.open(path, "r")
	
	if file == nil then 
		return false 
	end
	
	fileString = file:read("*all")
	file:close()
	
	return fileString
end

--===== init =====--
--=== parse args ===--
parser:flag("-F --force", "force exporting files even with missing fragments")
parser:option("-i --input", "input dir")
parser:option("-o --output", "output dir")
parser:option("-f --fragments", "fragment dir")
args = parser.parse()

--=== initialize loadedFragments ===--
setmetatable(loadedFragments, {__index = function(self, index)
	local path = conf.paths.fragments .. "/" .. index
	local result = readFile(path)
	
	if result == false then
		print("File not found: " .. path)
		os.exit(1)
	end
	 
	self.index = result
	return self.index
end})

--===== prog start =====--

print(loadedFragments.test)








