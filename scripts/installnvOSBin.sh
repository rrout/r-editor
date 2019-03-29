#!/bin/bash

# Test argument
if [ -z "$1" ]; then
  echo "No argument supplied"
  echo "Usage : $0 <file with switch names/ip> <complete build-path>"
  exit
else
  inputfile=$1
  if [ ! -f $inputfile ]; then
    echo "InputFile "$inputfile" not found"
    exit
  fi
fi

if [ -z "$2"  ]; then
	echo "Build Path not supplied"
	echo "Usage : $0 <file with switch names/ip> <complete build-path>"
	exit
fi

color_echo ()
{
    tput setaf 3
    echo "INFO : $@"
    tput sgr0
}

col_echo ()
{
    tput setaf 2
    echo "$@"
    tput sgr0
}

col_printf ()
{
    tput setaf 5
    printf "$@"
    tput sgr0
}

colr_printf ()
{
    tput setaf 2
	printf "$@"
    tput sgr0
}

err_printf ()
{
	tput setaf 1
	#tput setab 3
	tput bold
	printf "ERR : $@"
	tput sgr0
}

succ_printf ()
{
    tput setaf 2
	tput setab 3
    tput bold
    printf "$@"
    tput sgr0
}

if [ `uname -s` = "SunOS" ]; then
		err_printf "Use Solaris specific command\n";
		return;
fi;

#colr_printf $#
if [ $# != 2 ]; then
		err_printf "ERROR : Specify Work space starting after username\n";
		return;
fi;

CMD=$0;
WSPS=$2;
for i in {2..15}
do
	PTHEND=$PTH
	PTH=`echo $WSPS | cut -d \/ -f $i`;
	#echo $PTH
	if [ $i == 2 ];then
		PATHBEG=$PTH
	fi
	if [ "$PTH" == "src" ];then
		PTHEND=$PTH
	fi
	if [ -z $PTH ];then
		#colr_printf $PATHBEG $PTHEND
		if [ "$PATHBEG" == "build" ] || [ "$PATHBEG" == "build2" ];then
			if [ "$PTHEND" == "src" ];then
				break;
			else
				err_printf "Wrong path starting with $PATHBEG and ending with $PTHEND (Should start with /biuld/ or /build2 and end with /src)\n"
				exit
			fi
		else
			err_printf "Wrong path starting with $PATHBEG (Should start with /build or /build2\n)"
			exit
		fi
		break
	fi
done


progress()
{
    sleep 1;
    while true
    do
        echo -n .;
        sleep 1;
    done
}

stop_progress()
{
	col_printf "\rActivity complete.....\n"
	#kill $1  > /dev/null 2>&1
	#kill $1 2>&1 > /dev/null
	kill $1 > /dev/null 2>&1
	wait $1 2>/dev/null #https://stackoverflow.com/questions/81520/how-to-suppress-terminated-message-after-killing-in-bash
}

progressbar()
{
    local loopcount=1
    local loopmax=502
    #trap "kill $!" EXIT
    col_printf "Activity start.......\n"
    sleep 2
    while [ $loopcount -le $loopmax  ]
    do
        #printf "\r-----------------$loopcount"
        sleep .1
        #printf "\r[Progress] : [ \ ]"
        #printf "\r[>>              ]"
        colr_printf "\r[>>              >>              ]"
        sleep .1
        #printf "\r[pRogress] : [ | ]"
        #printf "\r[  >>            ]"
        col_printf "\r[  >>              >>            ]"
        sleep .1
        #printf "\r[prOgress] : [ / ]"
        #printf "\r[    >>          ]"
        colr_printf "\r[    >>              >>          ]"
        sleep .1
        #printf "\r[proGress] : [ - ]"
        #printf "\r[      >>        ]"
        col_printf "\r[      >>              >>        ]"
        sleep .1
        #printf "\r[progRess] : [ \ ]"
        #printf "\r[        >>      ]"
        colr_printf "\r[        >>              >>      ]"
        sleep .1
        #printf "\r[progrEss] : [ | ]"
        #printf "\r[          >>    ]"
        col_printf "\r[          >>              >>    ]"
        sleep .1
        #printf "\r[progreSs] : [ / ]"
        #printf "\r[            >>  ]"
        colr_printf "\r[            >>              >>  ]"
        sleep .1
        #printf "\r[progresS] : [ - ]"
        #printf "\r[              >>]"
        col_printf "\r[              >>              >>]"
        #loopcount = `expr $loopcount + 1`
        #let lopcount = $loopcount++
        #printf "loop iteration:"
        ((loopcount++))
    done;
}

install_process() {
	#printf " \n$1 $2 $3 $4\n"
	col_printf "\r${FUNCNAME[0]} : Scheduling Install process for switch : $1\n"
	expect -f /build/rrout/dbg/ssh-cpnvosbin.expect $1 $2 $3 $4
	if [ "$?" -eq 0 ];then
		succ_printf "\r${FUNCNAME[0]} : Instalation Status ($1) : Done\n"
		return
	fi
	err_printf "\r${FUNCNAME[0]} : Instalation Status ($1) : Failed\n"
	return
}

color_echo "Command : $0 $1 $2 $3"
color_echo "Switch List"
color_echo "--------------------------------"
while read line
do
	[[ "$line" =~ ^#.*$ ]] && continue
    col_echo "       $line"
done <$inputfile
color_echo "--------------------------------"
color_echo "Build path"
col_echo "       $2"
color_echo "Log Path"
col_echo "       switch-install.log"

while true; do
    read -p "Please check all info correct? Are you sure to proceed (Y/N)? " yn
    case $yn in
        [Yy]* ) color_echo "Proceed recheck with you"; break;;
        [Nn]* ) color_echo "Ok, done"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "You have entered to proceed, Are you really sure (Y/N)? " yn
    case $yn in
        [Yy]* ) col_echo "Proceeding to install"; break;;
        [Nn]* ) color_echo "Ok, done"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

pids=""

rm -rf switch-install.log

col_echo "================================================================"

while read line
do
	[[ "$line" =~ ^#.*$ ]] && continue

	install_process $line root test123 $2 &
	pids+="$! "
	#printf "$pids\n"
done <$inputfile

#printf "out $pids\n"
echo ""
progressbar &
progress_id=$!
trap 'stop_progress $progress_id' SIGINT
#printf "\nprogress bar pid : $progress_id"
wait $pids
stop_progress $progress_id

col_echo "================================================================"
color_echo "Instalation Complete"
color_echo "Installed Image from loc : $2"
color_echo "On Target switch(s)"
while read line
do
	[[ "$line" =~ ^#.*$ ]] && continue
    col_echo "        $line "
done <$inputfile

color_echo "Thanks Happy Debug"
echo ""


#echo "test" | sed "s,.*,$(tput setaf 1)&$(tput sgr0),"
#tput setaf 1
#ls -alt
#tput sgr0
