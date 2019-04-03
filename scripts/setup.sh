#!/bin/bash

os=`uname`
if [ $os == "Linux" ]
then
    MPOINT=/build
    alias sts='service svc-nvOSd status'
    alias dis='service svc-nvOSd stop'
    alias ena='service svc-nvOSd start'
    alias vers='dpkg -s pn-nvos'
    alias stsw='while ( sts | egrep "offline" ) ; do sleep 2; done ; sts'
    alias cpnvos='dis; cp cmd/nvOSd/objs/nvOSd /usr/sbin/nvOSd; ena'
    alias mnt='mkdir -p $MPOINT; mount cartman:/build $MPOINT'
    alias umnt='umount $MPOINT'
    alias zlogin='lxc-attach -n'
    alias zlist='lxc-ls -f'
    alias nvospid="ps -ef | grep nvOSd.log | grep -v grep | awk '{print \$2}'"
    alias pmem="top -n 1 -b -p"
else
    MPOINT=/net/ike/build
    alias sts='svcs nvOSd'
    alias stsm='svcs nvOS_mon'
    alias dis='svcadm disable nvOSd'
    alias dism='svcadm disable nvOS_mon'
    alias ena='svcadm enable nvOSd'
    alias enam='svcadm enable nvOS_mon'
    alias vers='pkg info pn-nvos'
    alias stsw='while ( svcs -o STATE nvOSd | egrep "offline" ) ; do sleep 2; done ; sts'
    alias kvers='pkg -R / info kernel'
    alias cpnvos='dis; cp cmd/nvOSd/objs64/nvOSd /usr/sbin/nvOSd; ena'
    alias mnt='mkdir -p $MPOINT; mount ike:/build $MPOINT'
    alias umnt='umount $MPOINT'
    alias zlist='zoneadm list -civ'
	function cptozone()
    {
        zone=$1
        src=$2
        dst=$3
        cp $src /vnm/$zone/root/$dst
    }

    function loadgate()
    {
        cd /net/fixa/build/jenkins/nvOS-gate-pm/usr/src
        echo installing image from `pwd`
        digs
        dis
        sts
        gmake uninstall
        gmake install
        ena
        stsw
    }

fi

alias tlog='tail -f /var/nvOS/log/nvOSd.log'
alias vilog='vi /var/nvOS/log/nvOSd.log'
alias digest='echo $1 >/var/nvOS/etc/digest.conf'
alias mycli='cli --quiet'
#log="/var/nvOS/log/nvOSd.log"
alias chkcore='ls -l /var/nvOS/log/cores/core.nvOSd.`pgrep nvOSd`'
alias nvosgdb='gdb /usr/sbin/nvOSd --pid `pgrep -x nvOSd`'
function cdb()
{
        cd $MPOINT/manojtn/$1/usr/src
        pwd
}

function digs()
{
    d=`egrep "digest .*\"" cmd/nvOSd/data_version.pcl | awk -F\" '{print $2}'`
    #d=`echo $d | awk '{print $2}' | sed 's/\"//g' | sed 's/;//g'`
    my_echo "Setting digest to $d"
    echo $d >/var/nvOS/etc/digest.conf
}

function loadimg()
{
        if [ x$1 != "x" ]
        then
            cd $MPOINT/manojtn/$1/usr/src
        fi
        echo installing image from `pwd`
        digs
        dis
        sts
        gmake uninstall
        gmake install
        ena
        stsw
}
function newimg()
{
        if [ x$1 != "x" ]
        then
            cd $MPOINT/manojtn/$1/usr/src
        fi
        echo installing new image from `pwd`
        dis
        sts
        gmake install
        ena
        stsw
}
function bekvers()
{
        beadm mount $1 /m
        pkg -R /m info kernel
        beadm umount $1
}



alias l='ls -CF --color'
alias la='ls -A --color'
alias ll='ls -alF --color'
alias ltr='ls -ltrh --color'

alias gi='gmake install'
alias gu='gmake uninstall'
if [ `uname -s` = "SunOS" ]; then
	alias gui='gu;gi;u_digest;svcadm disable nvOSd;svcadm enable nvOSd'
else
	alias gui='gu;gi;u_digest;service svc-nvOSd restart'
fi

unset LC_CTYPE
alias gdbinit="/build2/vkuma/gdbinit"

BUILD_MECHIENE=jerry

function ld(){
	CARTMAN=$BUILD_MECHIENE
	MNTPTH=/build
	MNTDIR=/build
	BUILDPATH=/build/rrout
	BUILDDIR=/work/main$1
	SPACE=/nvOS/usr/src
	if [ $# != 1  ]; then
		my_echo "Specify Work space number (Must be /work/main(NUMBER))"
		 return
	 fi
	my_echo "Preparing work space $BUILDPATH/$BUILDDIR/$SPACE"
	my_echo "Creating mount point : $MNTDIR"
	mkdir -p $MNTDIR
	my_echo "Mounting Workspace  ${CARTMAN}: ${MNTDIR}"
	mount ${CARTMAN}: ${MNTPTH}
	my_echo "Entering $MNTDIR/$BUILDDIR/$SPACE"
	cd $BUILDPATH/$BUILDDIR/$SPACE
	my_echo "Install from `pwd`"
	gu;gi
	digs
	my_echo "Entering root dir"
	cd
	my_echo "Unmounting ${MNTDIR}"
	umount ${MNTDIR}
	my_echo "Restart nvOSd"
	nv r
}

function loadl()
{
	if [ `uname -s` = "SunOS"  ]; then
		my_echo "Use Linux specific command"
		return
	fi
	if [ $# != 1 ]; then
		my_echo "Specify Work space starting after username"
		return
	fi
	CARTMAN=$BUILD_MECHIENE
	MNTPTH=/build
	MNTDIR=/build
	BUILDPATH=/build/rrout
	BUILDDIR=$1
	my_echo "Preparing work space $BUILDPATH/$BUILDDIR"
	my_echo "Creating mount point : $MNTDIR"
	mkdir -p $MNTDIR
	my_echo "Mounting Workspace  ${CARTMAN}: ${MNTDIR}"
	mount ${CARTMAN}: ${MNTPTH}
	my_echo "Entering $MNTDIR/$BUILDDIR"
	cd $BUILDPATH/$BUILDDIR/$SPACE
	my_echo "installing image from `pwd`"
	gu;gi
	digs
	my_echo "Entering root dir"
	cd
	my_echo "Unmounting ${MNTDIR}"
	umount ${MNTDIR}
	my_echo "Restart nvOSd"
	nv r
}

function loads()
{
	BUILDPATH=/net/ike/build
	BUILDDIR=$1
	if [ `uname -s` = "Linux"  ]; then
        my_echo "Use Solaris specific command"
        return
    fi
    if [ $# != 1 ]; then
        my_echo "Specify Work space starting with username"
        return
    fi
	my_echo "Entering Workspace $BUILDPATH/$BUILDDIR"
	cd $BUILDPATH/$BUILDDIR
	gu;gi
	cd /
	my_echo "Restart nvOSd"
	nv r

}

function ldwkspce ()
{
	if [ `uname -s` = "SunOS"  ]; then
        my_echo "Use Solaris specific command"
        return
    fi
    if [ $# != 1 ]; then
        c_echo "ERROR : Specify Work space starting after username"
        return
    fi
    CMD=$0
	WSPS=$1
	PTH1=`echo $WSPS | cut -d \/ -f 1`
	PTH2=`echo $WSPS | cut -d \/ -f 2`
	if [ -n "$PTH1" ]
	then
        c_echo "ERROR : Work name space must start with "/build...." "
        return
	else
        my_echo "Cmd : $CMD  -work space : $WSPS"
	fi
	echo ""$PTH2 $0 $1 $2""
	if [  "$PTH2" = "build" -o  "$PTH2" = "build2"  ]
	then
        my_echo "Checking work space $WSPS"
	else
    	c_echo "ERROR : Wrong work space $WSPS"
        return
	fi
    CARTMAN=$BUILD_MECHIENE
    MNTDIR="/$PTH2"
    MNTPTH=$MNTDIR
    BUILDPATH=$MNTDIR
    my_echo "Preparing work space $WSPS"
    my_echo "Creating mount point :$MNTDIR"
    mkdir -p $MNTDIR
    my_echo "Mounting Workspace  ${CARTMAN}: ${MNTPTH}"
    mount ${CARTMAN}: ${MNTPTH}
    my_echo "Entering work space $WSPS"
    cd $WSPS
    my_echo "Installing image from `pwd`"
    gu;gi
    digs
	my_echo "Entering root dir"
    cd
    my_echo "Unmounting ${MNTDIR}"
    umount ${MNTDIR}
    my_echo "Restart nvOSd"
    nv r
}

function zo(){
	if [ `uname -s` = "Linux"   ]; then
		CMD="lxc-attach -n"
	elif [ `uname -s` = "SunOS"   ]; then
		CMD=zlogin
	else
		my_echo "Unknown os"
		return
	fi
	if [ $# != 1  ]; then
		my_echo "Specify name"
		return
	fi
	$CMD $1
}

function zgo(){
	if [ `uname -s` = "Linux"    ]; then
		zo `lxc-ls`
	else
		my_echo "Command applicable only on linux"
	fi
}

function fnd(){
	ps -ef | grep $1
}

function fin(){
	find . -name "*$1*"
}

function lsp(){
	for p in `hg qseries`;do
		echo "`hg root`/.hg/patches/$p"
	done
}
function mymnt(){
	CARTMAN=$BUILD_MECHIENE
	MNTPATH=/build
	if [ -d ${MNTPATH} ]; then
        	umount ${MNTPATH}
    	fi
    	my_echo "Mounting ${CARTMAN}: ${MNTPATH}..."
    	mount ${CARTMAN}: ${MNTPATH}
    	cd ${MNTPATH}
}

function myumnt(){
	CARTMAN=$BUILD_MECHIENE
	MNTPATH=/build
	cd
	my_echo "unMounting ${MNTPATH}"
	if [ -d ${MNTPATH}  ]; then
		umount ${MNTPATH}
	fi
}

function m-mnt(){
    CARTMAN=$BUILD_MECHIENE
    MNTPATH=/build2
    if [ -d ${MNTPATH} ]; then
            umount ${MNTPATH}
    fi
        my_echo "Mounting ${CARTMAN}: ${MNTPATH}..."
        mount ${CARTMAN}: ${MNTPATH}
        cd ${MNTPATH}
}

function m-umnt(){
    CARTMAN=$BUILD_MECHIENE
    MNTPATH=/build2
    cd
    my_echo "unMounting /build2"
    if [ -d ${MNTPATH}  ]; then
        umount ${MNTPATH}
    fi
}

function zpath(){
	my_echo "/var/cache/lxc/trusty/rootfs-amd64/usr/sbin"
	my_echo "cat /var/lib/lxc/vr2/rootfs/"
	my_echo "/var/cache/lxc/xenial/rootfs-amd64/usr/sbin"
}

function mkenv() {
	apt-get update ; apt-get install make && apt-get install mercurial
	ln -s /usr/bin/make /usr/bin/gmake
}

function pi(){
	set -x
	dpkg -i `ls -tr ../../proto/root_x86_64/*nvos*.deb | tail -1`
	set +x
}

function my_echo(){
	#echo -e "\e[1;34m$1\e[m"
	echo -e "\e[0;31mINFO:\e[m \e[1;34m$1\e[m"
}


function c_echo(){
	echo -e "\e[1;37m$1\e[m"
}

function nv()
{
	case $1 in
		s )
			if [ `uname` == "Linux" ]; then
				set -x
				service svc-nvOSd status
				set +x
			else
				set -x
				svcs nvOSd
				set +x
			fi
			;;
		sp )
			if [ `uname` == "Linux" ]; then
				set -x
				service svc-nvOSd stop
				set +x
			else
				set -x
				svcadm disable nvOSd
				set +x
			fi
			;;
		r )
			if [ `uname` == "Linux" ]; then
				set -x
				service svc-nvOSd restart
				set +x
			else
				set -x
				svcadm disable nvOSd
				svcadm enable nvOSd
				set +x
			fi
			;;
		monsp )
			if [ `uname` == "Linux"  ]; then
				set -x
				service svc-nvOS_mon stop
				set +x
			else
				set -x
				svcadm disable nvOS_mon
				set +x
			fi
			;;
	esac
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
	#(gdb) run -l /var/nvOS/log/nvOSd.log -d 2
	--- "-b" detaches it and runs it in the background hence exclude -b
	------------------

	EOF
}

function h_ssh(){
	cat<<-EOF
		vkuma@Viveks-MacBook-Pro ~ (exit=0)
		$ ssh-add -k
		Identity added: /Users/vkuma/.ssh/id_rsa (/Users/vkuma/.ssh/id_rsa)

		vkuma@ike:/build/vkuma/16180_ping_coredump (exit=0)
		$ ssh-add -L
	EOF
}

function h_setup(){
	cat<<-EOF
	Command    Descreption
	---------- --------------------------------------------------------------------
	ld         load image from /build/rrout/work/main<>/nvOS/usr/src( ld <1....3> )
	loadl      load linux image ( loadl <work/main5/nvOS/usr/src> )
	loads      load solaris image ( loads <work/main5/nvOS/usr/src>  )
	ldwkspce   load image from /build/rrout/work/main/nvOS/usr/src
	zo         go to zone/lxc (zo <lxc name> )
	zlist      list zone/lxc s
	zgo        go to zone/lxc
	nv         nvOS services options ( nv s -status, nv sp -stop, nv r -restart )
	mymnt      mount /build/rrout from $BUILD_MECHIENE
	myumnt     unmount /build/rrout from $BUILD_MECHIENE
	m-mnt      mount /build2 from $BUILD_MECHIENE
	m-umnt     unmount /build2 from $BUILD_MECHIENE
	nvosgdb    gdb --pid "'pidof nvOSd'"
	h_tcpdump  help tcpdump
	h_gdb      help gdb
	h_dtrace   help dtrace
	zpath      lxc rootfs path
	mkenv      install gmake and hg
	EOF
}

function title ()
{
	    TITLE=$*;
	        export PROMPT_COMMAND='echo -ne "\033]0;$TITLE\007"'
}

# title ${HOSTNAME}
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
	PS1=$"\[\e[1;32m\u\e[m\]@\[\e[1;31m\h\e[m\]:\[\e[1;35m\w\e[m\]:\n\[\e[1;32m$ \e[m\] "
    #PS1=$"\[\e[1;32m\u\e[m\]@\[\e[1;31m\h\e[m\]:\[\e[1;35m\w\e[m\]:\[\e[1;36m(exit=$EXIT)\e[m\]\n\[\e[1;32m$\e[m\] "
}

# PS1="\[\e[1;32m\u\e[m\]@\[\e[1;31m\h\e[m\]:\[\e[1;33m\w\e[m\] \[\e[1;36m(exit=$?)\e[m\]\n\[\e[1;32m$\e[m\] "


function g(){
	[ -f /build/vkuma/mybashrc.sh ] && RF=/build/vkuma
	[ -f /net/ike/build/vkuma/mybashrc.sh ] && RF=/net/ike/build/vkuma
	[ -f /build2/vkuma/mybashrc.sh ] && RF=/build2/vkuma
	if [ -d $RF ]; then
		if [ -z $1 ]; then
			cd $RF
		else
			cd ${RF}/*$1*/nvOS*/usr/src
		fi
	fi
}

alias log='cd /var/nvOS/log'
alias dlog='tail -f /var/nvOS/log/nvOSd.log'
alias core='cd /var/nvOS/log/cores'
alias etc='cd /var/nvOS/etc'
digest='/var/nvOS/etc/digest.conf'

function u_digest(){
	grep -i "digest \"" ./cmd/nvOSd/data_version.pcl | awk -F"\"" '{print $2}' > $digest
}

#alias sp='ps -elf | grep -v grep| grep --color -e "\\sPID\\s" -i -e '
alias sp='ps -elf | grep -v grep| grep --color -e "[[:space:]]PID[[:space:]]" -i -e '
[ "`uname -s`" == "SunOS" ] && alias sp='ps -elf | ggrep -v ggrep| ggrep --color -e "[[:space:]]PID[[:space:]]" -i     -e '
# dtrace -l | awk '{print $2}' | sort | uniq
# dtrace -l -P sysinfo

if [ ${USER} = "root" ]; then
	[ -f ~/.bashrc ] && source ~/.bashrc
	[ -f ~/.bash_profile ] && source ~/.bash_profile
fi
export LOGVIM=/build2/vkuma/logs.vim
#export VIMINIT='source /build2/vkuma/logs.vim'
