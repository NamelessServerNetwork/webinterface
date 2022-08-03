local args = {...}
local msg

print(args[1])

io.write("Enter new UNIX password: ")
print(io.read("*line"))
io.write("Retype new UNIX password: ")
msg = io.read("*line")

print(msg, msg == "test ")

for i = 0, string.len(msg) do
	print(string.byte(string.sub(msg, i, i)))
end


print("     ")
print("     ")
print("     ")
os.execute("sleep 1")