local pattern = "[test]+"

print(string.match("test", pattern))
print(string.match("test2", pattern))
print(string.match("test2t", pattern))
print(string.match("tes", pattern))