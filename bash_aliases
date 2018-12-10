alias v='vim'
alias vi='vim'

alias lsco-a='hg status -m'
alias lsco-al="hg status"
alias vdiff='hg vimdiff'
alias cdiff='hg diff'
alias cpatch='hg import --no-commit'
alias review-gen='hg webrev'
alias update_view='hg pull -u'
alias uco='hg revert'
alias revert='revert_all_and_backup'
alias ucout="uncheckout"

alias bld="gmake OPTIMIZER=-g"

alias rd="cd /build/rrout"
alias wd="cd /build/webrev/rrout"


#Tmux Aliases.....
alias tmux="tmux -2"
alias ts="tmux new -s"
alias ta="tmux a -t"
alias t-ls="tmux ls"
alias th="tmux_help"



# rm to ask conformation
alias rm='rm -i'

shopt -s histappend
PROMPT_COMMAND='history -a'
# ~/.bashrc
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi


uncheckout() {
    if [ $# != 1 ]; then
        echo "Usage: uncheckout <name>"
    else
        read -r -p "Keep backup? [y/n] " response
        case "$response" in
            [yY][eE][sS]|[yY])
            hg diff $1 > $1.patch.$(date +%Y-%m-%d:%H:%M);
            cp $1 $1.keep.$(date +%Y-%m-%d:%H:%M);
            hg revert $1
            echo -e "Saved : $1.patch.$(date +%Y-%m-%d:%H:%M)"
            echo -e "Saved : $1.keep.$(date +%Y-%m-%d:%H:%M)"
            ;;
        *)
            hg revert $1
            ;;
        esac
        #mkdir -p $1 && cd $1                                                                                                        
    fi
}

uncheckout() {                                                                                                                       
    if [ $# != 1 ]; then
        echo "Usage: uncheckout <name>"
    else
        read -r -p "Keep backup? [y/n] " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
            hg diff $1 > $1.patch.$(date +%Y-%m-%d:%H:%M);
            cp $1 $1.keep.$(date +%Y-%m-%d:%H:%M);
            hg revert $1
            echo -e "Saved : $1.patch.$(date +%Y-%m-%d:%H:%M)"
            echo -e "Saved : $1.keep.$(date +%Y-%m-%d:%H:%M)"
            ;;
        *)
            hg revert $1
            ;;
        esac
        #mkdir -p $1 && cd $1
    fi
}

revert_all_and_backup() {
    #echo -e "$#";echo -e "$1";echo -e "$?"
    if [ $# != 0  ]; then
        echo -e "Error : Shouldn't specify argument"
        return
    fi
    read -r -p "It will save diff in current directory and revert all? [y/n] " response
    case "$response" in
        [yY][eE][sS]|[yY])
        #hg diff > AUTO_BKP_$(date +%F+%T).diff; hg revert --all
        hg diff > AUTO_BKP_$(date +%Y-%m-%d:%H:%M).diff;
        hg status -n -m > AUTO_BKP_FILES_$(date +%Y-%m-%d:%H:%M).diff
        #hg revert $1 --all
        hg revert --all
        echo -e "Saved : AUTO_BKP_$(date +%Y-%m-%d:%H:%M).diff"
        echo -e "Saved : AUTO_BKP_FILES_$(date +%Y-%m-%d:%H:%M).diff"
        ;;
        *)
        echo -e "Thanks!!!!!"
    esac
}

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

function h_tmux()
{
    echo "usage"
    echo "-----------------------------------------------------"
    echo " tmux                         - start new"
    echo " tmux new -s myname  A: ts    - start new with name"
    echo " tmux a                       - attach"
    echo " tmux a -t myname    A: ta    - attach to session"
    echo " tmux ls             A: t-ls  - list sessions"
    echo " tmux kill-session -t myname  - kill session"
    echo "====================================================="
    echo " CHEAT SHEET (Prefix: C-a)"
    echo "====================================================="
    echo " Prefix C-a   - pass-through"
    echo " Prefix C-r   - reload tmux.conf"
    echo " Prefix C-s   - choose session"
    echo " Prefix d     - detach from session"
    echo " Prefix c     - create window"
    echo " Prefix r     - rename window"
    echo " Prefix w     - list windows"
    echo " Prefix n     - next window"
    echo " Prefix p     - previous window"
    echo " Prefix space - last window"
    echo " Prefix 1-9   - goto window n"
    echo " Prefix s     - show pane numbers"
    echo " Prefix q     - quit pane"
    echo " Prefix ?     - list all bindings"
    echo " Prefix :     - command-line"
    echo " Prefix |     - horizontal split"
    echo " Prefix -     - vertical split"
    echo " Prefix C-c   - copy mode"
    echo " Prefix C-v   - paste"
    echo " Prefix PgUp  - scroll mode"
    echo "====================================================="
}

function h_tcpdump()
{
        cat<<-EOF
                https://danielmiessler.com/study/tcpdump/

                tcpdump -i eth0
                tcpdump -ttttnnvvS
                tcpdump host 1.2.3.4
                tcpdump -nnvXSs 0 -c1 icmp
                tcpdump src 2.3.4.5 
                tcpdump dst 3.4.5.6
                tcpdump net 1.2.3.0/24
                tcpdump port 3389 
                tcpdump src port 1025
                tcpdump icmp
                tcpdump ip6
                tcpdump portrange 21-23
                tcpdump less 32 
                tcpdump greater 64 
                tcpdump <= 128

                tcpdump port 80 -w capture_file
                tcpdump -r capture_file

                tcpdump -nnvvS src 10.5.2.3 and dst port 3389
                tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16
                tcpdump dst 192.168.0.2 and src net and not icmp
                tcpdump -vv src mars and not dst port 22
                tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'

                tcpdump 'tcp[tcpflags] == tcp-syn'
                tcpdump 'ip[8] < 10' :- PACKETS WITH A TTL LESS THAN 10 
        EOF
}

function h_gdb(){
        cat<<-EOF
        gdb -q -ex "set height 0" -ex "info sources" -ex quit /usr/sbin/pim-sm-d
        (gdb) set substitute-path /build/rrout/ /media/cartman/
        (gdb) 
        +CFLAGS         += -fno-inline-small-functions
        -----------------
        Run gdb cmdline : gdb --args executablename arg1 arg2 arg3
        -----------------
        Run gdb nvOS fron begin:
        #gdb /usr/sbin/nvOSd
        #(gdb) run -l /var/OS/log/OSd.log -d 2
        --- "-b" detaches it and runs it in the background hence exclude -b
        ------------------

        EOF
}

function h_dtrace()
{
        cat<<-EOF
                dtrace -F -n 'pid6120:a.out::entry/tid == 6978/{}'
                dtrace -Z -F -n 'fbt::port_show*:entry/execname == "nvOSd"/{}'
                dtrace -F -n 'pid6120:a.out:nvOS_count_command:entry/tid == 6978/{ustack();}'

                dtrace -n 'syscall:::entry {@[probefunc]=count();}'
                dtrace -n 'syscall::ioctl:entry {@[execname]=count();}'
                dtrace -n 'syscall::ioctl:entry /execname =="nvOSd"/ {@[ustack()]=count();}'
                /opt/DTT/Bin/iotop
                /opt/DTT/Bin/iosnoop -Deg
        EOF
}


function h_gtags(){
        cat<<-EOF
        ----------------------
        GTAGS COMMANDS
        ----------------------
        Command    Descreption
        ---------- --------------------------------------------------------------------
        gtags      Create GRATS Database in current Directory

        ----------------------
        GTAGS VIM COMMANDS
        ----------------------
        Command    Descreption
        ---------- --------------------------------------------------------------------
        <C-|>      Go to Defination
        <C-R>      Lookup Reference
        <C-E>      Go to Defination in left hand
        <C-S>      Local symbol reference
        <C-G>      Gtags raw string search [STRING-PATTERN]
        <C-D>      Open Navigation Path
        <C-T>      Return to previous tag
        <C-X><C-X> Open reference          [X-PARTEEN]
        <C-F><C-F> kg search               [K-PATTERN]
        <C-Y><C-Y> Ack search              [ACK-PATTREN]
        <C-LMouse> Mouse open Defination
        <C-R><C-R> Open Reference          [R-PATTERN}
        <C-G><C-G> Gtags grep search       [G-PARTTEN]
        <C-P><C-P> Open File Path
        <C-S><C-S> Searc sub string        [SUB-PATTERN]
        <C-F><C-R> Gtags search and replace
        <C-F><C-L> Gtags view cursor file
        <C-X><C-X> Search Parten Reference
        EOF
}

function h_ctags(){
        cat<<-EOF
        ----------------------
        GTAGS COMMANDS
        ----------------------
        Command    Descreption
        ---------- --------------------------------------------------------------------
        gtags      Create GRATS Database in current Directory

        ----------------------
        GTAGS VIM COMMANDS
        ----------------------
        Command    Descreption
        ---------- --------------------------------------------------------------------
        <C-|>      Go to Defination
        <C-R>      Lookup Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        <C-X><C-X> Search Parten Reference
        EOF
}

