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
    tput bold
    echo "$@"
    tput sgr0
}

col_printf ()
{
    tput setaf 2
    printf "$@"
    tput sgr0
}

colr_printf ()
{
    tput setaf 1
	printf "$@"
    tput sgr0
}

if [ `uname -s` = "SunOS" ]; then
		color_echo "Use Solaris specific command";
		return;
fi;

#colr_printf $#
if [ $# != 2 ]; then
		color_echo "ERROR : Specify Work space starting after username";
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
				colr_printf "Wrong path starting with $PATHBEG and ending with $PTHEND (Should start with /biuld/ or /build2 and end with /src)"
				exit
			fi
		else
			colr_printf "Wrong path starting with $PATHBEG (Should start with /build or /build2)"
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
    	sleep 1
	    #printf "\r[Progress] : [ \ ]"
	    col_printf "\r[>>              ]"
	    sleep 1
	    #printf "\r[pRogress] : [ | ]"
	    colr_printf "\r[  >>            ]"
	    sleep 1
	    #printf "\r[prOgress] : [ / ]"
	    col_printf "\r[    >>          ]"
	    sleep 1
	    #printf "\r[proGress] : [ - ]"
	    colr_printf "\r[      >>        ]"
	    sleep 1
	    #printf "\r[progRess] : [ \ ]"
	    col_printf "\r[        >>      ]"
	    sleep 1
	    #printf "\r[progrEss] : [ | ]"
	    colr_printf "\r[          >>    ]"
	    sleep 1
	    #printf "\r[progreSs] : [ / ]"
	    col_printf "\r[            >>  ]"
	    sleep 1
	    #printf "\r[progresS] : [ - ]"
	    colr_printf "\r[              >>]"
	    #loopcount = `expr $loopcount + 1`
		#let lopcount = $loopcount++
		#printf "loop iteration:"
		((loopcount++))
	done;
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

while read line
do
   [[ "$line" =~ ^#.*$ ]] && continue
   echo "===================================================="
   color_echo "Logging in to switch $line"

	progressbar &
	progress_id=$!
	trap 'stop_progress $progress_id' SIGINT
	#trap "kill $progress_id" EXIT
	#trap "kill $progress_id" SIGINT

    expect -f /build/rrout/dbg/ssh-install.expect $line root test123 $2

	sleep 15
	#echo $progress_id
	stop_progress $progress_id

   color_echo "Finished Install on switch $line"
   echo "===================================================="
   col_echo "Install ($line) : Done (nvOS Restarted)"
   echo ""
done <$inputfile

echo ""
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
