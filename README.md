DAMS is a framework to easly create multiuser HTTP(s) APIs using lua.

It is completly written in lua.

Its very WIP atm and has no documentation yet.

# Performance
DAMS uses multithreadding per default to execute multiple user orders in at the same time.  
This also allows the it to effectively use all of the avaiable CPU power. 

But due to the way the multithreadding is handled atm there is a massive overhead. So massive indeed that it does not justifies the advantage of the multithreadding in a productive usecase.

In short, there is quite some optimasation required.

# Recommendations
## Runtime environment
LÖVE 0.11.x

## luarocks
lsqlite3complete  
luafilesystem


# Known bugs
## event
listet events are not executet in main thread.

## UT
tostring is displays numbers in a table as string.

## shared
shared tables are not iterable using pairs or ipairs function. This is not fixable until löve uses lua5.2+.

local references to a shared table get not updatet properly in some cases. you should always work with env.shared directly.