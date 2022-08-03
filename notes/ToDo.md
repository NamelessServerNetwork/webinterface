# setup
## installer
installer that uses luarocks and git to build the libraries and buts it into the local lib folder.

# Performance  
## Buffer thread
a thread used as buffer for file strings loaded often.
needs to be tested if it actually saves time/usage.

## Threads  
dynamic lib loading to reduce init time (__index).  
