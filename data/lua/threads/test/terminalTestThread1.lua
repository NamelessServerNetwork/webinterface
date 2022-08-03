log("--===== TERMINAL TEST THREAD#1 START ======--")


print("test1", "test2", "test3")
io.write("test4")
io.write("test5")
io.write("test6")
io.flush()
print("test7", "test8", "test9")


log("--===== TERMINAL TEST THREAD#1 END ======--")