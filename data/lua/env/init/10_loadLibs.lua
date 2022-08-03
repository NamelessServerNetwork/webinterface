local env = ...

dlog("Loading libs")


--===== load libs =====--
--NOTE: could add dynamic lib loading to reduce processing time of thread init.

env.lib = {}

env.lib.thread = require("love.thread")
env.lib.timer = require("love.timer")
env.lib.serialization = require("serpent")

env.lib.cqueues = require("cqueues")
env.lib.sqlite = require("lsqlite3complete")

env.lib.fs = require("love.filesystem")
env.lib.ut = require("UT")
env.lib.lfs = require("lfs")
env.lib.argon2 = require("argon2")


--====== legacy =====--
--ToDo: have to be removed from older source files.
env.thread = require("love.thread")
env.timer = require("love.timer")
env.serialization = require("serpent")

env.cqueues = require("cqueues")
env.sqlite = require("lsqlite3complete")
