#set pagination off


echo \n\033[33m--------Rashmi Ranjan Rout--------\033[0m
echo \n\033[33m--------Customized    feel--------\033[0m\n\n
#set non-stop on
#prevent thread event print
set print thread-events off
echo  \n\033[33m % [set print thread-events off]\033[0m

#Ignore SIGPIPE
handle SIGPIPE nostop
echo  \n\033[33m % [handle SIGPIPE nostop]\033[0m

# list command outout size  - Number of source lines gdb will list by default is 10.
set listsize 11

# By default, it only loads ~/.gdbinit. add "safe-path" will then allow you to create a .gdbinit file in each of your  build directories with behavior that makes sense for that build directory
set auto-load safe-path .
echo  \n\033[33m % [iset auto-load safe-path .].\033[0m
echo  \n\033[33m % INFO: gdbinit now refers to a version in the directory that GDB or a GDB Front End is ran from and not ~/.gdbinit\033[0m


# __________________gdb options_________________

# set to 1 to enable 64bits target by default (32bit is the default)
set $64BITS = 1

set confirm off
set verbose off
set prompt \001\033[1;32m\002(gdb)\001\033[0m\002\040
#set prompt \033[31mgdb$ \033[0m

set output-radix 0x10
set input-radix 0x10

# These make gdb never pause in its output
set height 0
set width 0

# Display instructions in Intel format
set disassembly-flavor intel

set $SHOW_CONTEXT = 1
set $SHOW_NEST_INSN = 0

set $CONTEXTSIZE_STACK = 6
set $CONTEXTSIZE_DATA  = 8
set $CONTEXTSIZE_CODE  = 8

# set to 0 to remove display of objectivec messages (default is 1)
set $SHOWOBJECTIVEC = 1
# set to 0 to remove display of cpu registers (default is 1)
set $SHOWCPUREGISTERS = 1
# set to 1 to enable display of stack (default is 0)
set $SHOWSTACK = 0
# set to 1 to enable display of data window (default is 0)
set $SHOWDATAWIN = 0

#https://sourceware.org/gdb/onlinedocs/gdb/Set-Breaks.html
set breakpoint pending on
echo  \n\033[33m % [set breakpoint pending on]\033[0m
# __________________end gdb options_________________


#References
#https://gist.github.com/CocoaBeans/1879270
#http://www.dirac.org/linux/gdb/04-Breakpoints_And_Watchpoints.php

#read for Options
#https://stackoverflow.com/questions/1471226/most-tricky-useful-commands-for-gdb-debugger
#http://apoorvaj.io/hitchhikers-guide-to-the-gdb.html
#http://devarea.com/10-things-you-can-only-do-with-gdb/#.WzPM7rSZ3dc
#https://thispointer.com/debugging-multi-threading-applications-with-gdb-debugger/

#https://caiorss.github.io/C-Cpp-Notes/
#https://caiorss.github.io/C-Cpp-Notes/Cpp-C-Debuggers.html
#http://www.haifux.org/lectures/222/GDB_haifux_David_Khosid.pdf
#https://github.com/dholm/dotgdb
#https://gist.githubusercontent.com/rrout/7cbe2e1aa090e566c87d3f2e327ffe03/raw/1ac839c7d82dcefe0ec8adb764609a162b61044a/.gdbinit
#https://sourceware.org/gdb/onlinedocs/gdb/Core-File-Generation.html#Core-File-Generation
#
source ~/gdbinit-cpp-butify.gdb
echo  \n\033[33m % [source ~/gdbinit-cpp-butify.gdb]\033[0m
source ~/gdbinit-tips.gdb
echo  \n\033[33m % [source ~/gdbinit-tips.gdb]\033[0m
echo  \n\033[33m % []\033[0m



















printf "\n"
