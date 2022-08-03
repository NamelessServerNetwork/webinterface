local conf = ...

--===== local variables =====--

--===== local functions =====--

--===== initialization =====--

--===== test start =====--
log(db:exec([[
	CREATE TABLE users (
		username TEXT NOT NULL,
		password TEXT NOT NULL,
		id INTEGER NOT NULL
	);
]], exec))

log(db:exec([[
	CREATE TABLE permissions (
		permission TEXT NOT NULL,
		userID TEXT NOT NULL,
		value INTEGER NOT NULL
	);
]], exec))

--===== test end =====--