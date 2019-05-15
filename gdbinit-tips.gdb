# _________________user tips_________________
# The 'tips' command is used to provide tutorial-like info to the user
define tips
  printf "GDB Tips Commands:\n"
  printf "tips-basic   : Breakpoint Tips\n"
  printf "tips-tui     : File and type Tips\n"
  printf "tips-c-stl   : C++ user utility tips\n"
  printf "tips-user    : AT&T vs Intel syntax\n"
end
document tips
    Provide a list of tips from users on various topics.
end

define tips-basic
    printf "Command	                          Description\n==============================================\n"
    printf "help or h                         : Show help\n"
    printf "info                              : Show help about all (i) or info commands\n"

    printf "Debug Program or Process\n==============================================\n"
    printf "file [path/to/program]            : Load some program/executable file (ELF format on U*nix)\n"
    printf "start                             : Start debugging a loaded program\n"
    printf "attach [PID]                      : Attach debugger to a running process\n"
    printf "detach                            : Detach debugger from process\n"
    printf "r or run                          : Run the loaded program\n"
    printf "r [ARG0] [ARG1] …                 : Run program with arguments ARG0, ARG1 …\n"
    printf "r > logging.fil                   : Run program redirecting output to file\n"
    printf "tty /dev/pts/4                    : Redirect program input and ouput to another terminal\n"
    printf "q or quit                         : Quit GNU debugger\n"
    printf "kill                              : Kill the process being debugged\n"

    printf "Break Points\n==============================================\n"
    printf "i b or i breakpoints              : Show brakpoints\n"
    printf "break main                        : Set break point at main function\n"
    printf "break [FUNCTION]                  : Set break point at some function\n"
    printf "break [OBJECT.method]             : Set break point at some class method\n"
    printf "break [LINE ]                     : Set break point at some line\n"
    printf "break [FILE] [LINE]               : Set break point at some line of a given file\n"
    printf "watch n == 10                     : Set watchpoint, that pauses program when n == 10 is true\n"
    printf "sycall catch fork                 : Stop execution whenever this syscall, fork, is invoked\n"
    printf "syscall catch read                : Set break point at read system call\n"

    printf "Setepping through\n==============================================\n"
    printf "s or step                         : Execute next line, stepping over any function calls\n"
    printf "n or next                         : Execute next line, stepping into function calls\n"
    printf "c, cont or continue               : Resume execution until next break point\n"
    printf "pop [RETURN VALUE]                : Pop current stack frame, returning from current function\n"
    printf "finish                            : Run until the current function returns\n"
    printf "ump [LINE] or *address            : Resume execution at different address\n"
    printf "lines                             : Show lines of srouce around current line\n"
    printf "where                             : Show current location\n"
    printf "bt or backtrace                   : Show backtrace\n"

    printf "Variables\n==============================================\n"
    printf "i locals                          : Show local variables\n"
    printf "i args                            : Show arguments of current function\n"
    printf "p [VAR] or print [VAR]            : Print some variable\n"
    printf "display [VAR]                     : Add variable to display list\n"
    printf "watch [VAR]                       : Watch variable\n"
    printf "set [VAR] = [VALUE]               : Set variable with some value\n"
    printf "i registers                       : Show CPU registers\n"
    printf "p $pc                             : Print program counter CPU Register\n"
    printf "p $sp                             : Print stack pointer\n"
    printf "p $fp                             : Print frame pointer\n"
    printf "ptype <VARIABLE>                  : Print variable type\n"
    printf "i vtbl <VARIBLE>                  : Display vtable or virtual table layout for the variable class\n"

    printf "Process Information\n==============================================\n"
    printf "i proc                            : Display basic information about current process\n"
    printf "i proc status                     : Show process status\n"
    printf "i proc all                        : Show all information about current process\n"
    printf "i inferior                        : Show path to executable and PID of debugged process\n"

    printf "pwd                               : Current process working directory\n"
    printf "cd [DIRECTORY]                    : Change process working directory\n"
    printf "show args                         : Show arguments used to invoke the program being debugged\n"
    printf "show environment                  : Show environment variables of the process being debugged\n"
    printf "show paths                        : Show PATH variable or serach paths\n"

    printf "Misc\n==============================================\n"
    printf "info threads                      : Show threads information\n"
    printf "info functions                    : Show all functions and symbols in the program\n"
    printf "info functions                    : Show all functions in the program\n"
    printf "info file                         : Show memory map of current process\n"
    printf "info proc m                       : Show memory mappings\n"
    printf "infi vtbl pFun                    : Print  C++ virtual function table\n"
    printf "info signals                      : Show information about signals\n"
    printf "info share                        : List shared libraries loaded into current process info share\n"
    printf "list <main>                       : Print/List function source code\n"
    printf "list                              : List source at current break point\n"
    printf "set print pretty on               : Turn on pretty print\n"
    printf "call Function()                   : Call some function and print returned value\n"
    printf "layout asm                        : Show a window within current terminal with assembly code\n"
    printf "laytout src                       : Show a window within current terminal with source code\n"
    printf "laytout spilt                     : Show all window within current terminal with source code and assembly\n"

    printf "Backtrace                         : Debug exceptions and signals such as segmentation fault\n"
    printf "backtrace or bt	Show backtrace\n"
    printf "backtrace full or bt full         : Show full backtrace\n"
    printf "disas <printHello>                :Disassembly some function\n"
    printf "shell <uname -r>                  :Execute shell command\n"

    printf "Key Bindign	                      Description\n==============================================\n"
    printf "Crtl + z	                      :Suspend GDB process, type fg to resume\n"
    printf "Crtl + c	                      :Terminate debugged process\n"
    printf "Ctrl + l	                      :Clear screen\n"
    printf "Ctrl + x + a	                  :TUI: Open a window in the terminal which shows the source code around the current line\n"

    printf "Line Editor	:Note: The liner editor is based on Emacs and Lib. GNUReadline\n"
    printf "Ctrl + a	                      :Move cursor to beggining of line\n"
    printf "Ctrl + e	                      :Move cursor to end of line\n"
    printf "Ctrl + d	                      :Send EOF (End of File char) 0x4 - means end of input\n"
    printf "Ctrl + p	                      :Previous command from history\n"
    printf "Ctrl + n	                      :Next command from history\n"
    printf "Ctrl + k                          : Delete characters from current cursor location to end of line\n"
    printf "Ctrl + u                          : Delete characters from current cursor location to beggining of line\n"
    printf "Ctrl + x + 2                      : Switch to other window\n"

    printf "Command line example	Description\n==============================================\n"
    printf "$ gdb –help                       : Show help options\n"
    printf "$ gdb                             : Start gdb interactive shell\n"
    printf "$ gdb –tui                        : Start gdb interactive shell with a TUI - Terminal User Interface\n"

    printf "Debug Executable\n==============================================\n"
    printf "$ gdb ./executable                : Load executable (Unix ELF or PE32 / PE64) on GDB shell\n"
    printf "$ gdb –args ./executable arg1 arg2 … argN : Load executable passing arguments to it\n"

    printf "Debug Running Process\n==============================================\n"
    printf "$ gdb -pid=9478                   : Attach GDB to process of PID (9478)\n"
    printf "$ gdb –tui –pid=9478              : Attach GDB to process of PID (9478) and use a TUI\n"
    printf "$ ps -ef                          : Show all processes and theirs PIDs on Unix-like Oses\n"
    printf "$ tasklist                        : Show all processes and theirs PIDs on MS-Windows\n"

    printf "Session automation\n==============================================\n"
    printf "$ gdb -x script.gdb               : Run a GDB (command) script containing session commands\n"

end
document tips-basic
    Provide a list of GDB Basic tips.
end

define tips-extended
    printf "ptype [var]	:Print type info of the given variable\n"
end

define tips-c-stl
    printf "C++ Print Beautifully\n==============================================\n"
    printf "         sourse gdbinit-cpp-butify.gdb before hand\n"
    printf "         ptype [var]  :Print type info of the given variable\n"
    printf "STL                              Command\n"
    printf "std::vector<T>                   : pvector\n"
    printf "std::list<T> 	         		 : plist or plist_member\n"
    printf "std::map<T,T>                    : pmap or pmap_member\n"
    printf "std::multimap<T,T>               : pmap or pmap_member\n"
    printf "std::set<T>                      : pset\n"
    printf "std::multiset<T>                 : pset\n"
    printf "std::deque<T>                    : pdequeue\n"
    printf "std::stack<T>                    : pstack\n"
    printf "std::queue<T>                    : pqueue\n"
    printf "std::priority_queue<T>           : ppqueue\n"
end

document tips-c-stl
    Tips for C++ STL Debugging
end


define tips-tui
    printf "TUI Debugging\n==============================================\n"
    printf "$ gdb –tui                        : Start gdb interactive shell with a TUI - Terminal User Interface\n"
    printf "$ gdb –tui –pid=9478              : Attach GDB to process of PID (9478) and use a TUI\n"
    printf "Ctrl + x + a                      :TUI: Open a window in the terminal which shows the source code around the current line\n"
    printf "tui enable                        :TUI: Open a window in the terminal which shows the source code around the current line\n"
    printf "tui disable                       :TUI: Close the window in the terminal which shows the source code around the current line\n"
end
document tips-tui
Tips for TUI Debugging
end

define rashmi
end

document rashmi
	Debugging deadlocks
	===============================
	Debugging deadlocks can be a tricky matter, especially if you’re dealing with a lot of complex multithreading.
	If a thread is permanently waiting on a mutex, you can find the thread that’s holding the mutex by doing the following:

	Navigate to the thread and stack frame that’s waiting on the mutex.
    You can navigate to this frame using the info threads, thread [num], bt, and frame [num] commands.

	Now you can print the thread ID of the mutex’s owner using the gdb command print mutex.__data.__owner.

	You can now go to that thread and figure out why it is not releasing the mutex properly.

    GDB Scripting
    ===============================
	$ cat script.gdb
		set logging on
		set breakpoint pending on

		# Set source directory to current directory
		dir .

		# Load symbols from shared library
		# file typesdb.so

		# Set breakpoint at main
		b main
		# --- Breakpoint at functions loaded from
		# shared library typesdb.so
		b VariantArgs_add_int
		b VariantArgs_add_cchar
		b typedb_call_function_void
		b 200                          # set breakpoint at line 200
		b MyClass::SomeMemberFunction  # set B.P. at some class method

		# Run executable with some arguments
		# It is similar to run:
		# $ gdb --args python -i test1.py
		run -i test1.py
	$ gdb --silent
	(gdb) source script.gdb

    Catchpoints
    ===============================
    Catchpoints allow you to break execution on exceptions, or more importantly, syscalls.
    This is very powerful when combined with the strace tool.

    You can catch a syscall using: catch syscall [syscall].
    For instance, catch syscall open will break any time your program initiates an open syscall.
    :strace command does the same
end

