#!/bin/bash

job1(){
	sleep 3
	printf "\r${FUNCNAME[0]} ${FUNCNAME[2]} finished $?       \n"
}

job2(){
    sleep 4
	printf "\r${FUNCNAME[0]} finished $?        \n"
}

job3(){
    sleep 5
printf "\r${FUNCNAME[0]} finished $?        \n"
}

job4(){
    sleep 6
printf "\r${FUNCNAME[0]} finished $?        \n"
}
job5(){
   sleep 12
printf "\r${FUNCNAME[0]} finished $?        \n"
}
job6(){
    sleep 8
printf "\r${FUNCNAME[0]} finished $?        \n"
}

this_help() {
cat<<-EOL
https://stackoverflow.com/questions/9146623/in-bash-is-it-possible-to-get-the-function-name-in-function-body/9146641
https://linuxhint.com/wait_command_linux/
https://unix.stackexchange.com/questions/124106/shell-script-wait-for-background-command
https://arstechnica.com/civis/viewtopic.php?t=1221315

https://stackoverflow.com/questions/356100/how-to-wait-in-bash-for-several-subprocesses-to-finish-and-return-exit-code-0

https://unix.stackexchange.com/questions/348713/check-for-a-word-in-the-expect-output-and-add-it-to-a-text-file
https://www.unix.com/shell-programming-and-scripting/144812-expect-script-obtain-exit-code-remote-command.html
https://unix.stackexchange.com/questions/355618/match-a-string-with-a-substring-in-expect-scripting
https://unix.stackexchange.com/questions/259903/catching-the-last-returned-value-in-unix
https://stackoverflow.com/questions/44676348/expect-script-how-to-archive-and-delete-files-from-it

EOL
}



stop_progress()
{
    printf "\rActivity complete.....\n"
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
    printf "Activity start.......\n"
    sleep 2
    while [ $loopcount -le $loopmax  ]
    do
        #printf "\r-----------------$loopcount"
        sleep .1
        #printf "\r[Progress] : [ \ ]"
        #printf "\r[>>              ]"
		printf "\r[>>              >>              ]"
        sleep .1
        #printf "\r[pRogress] : [ | ]"
        #printf "\r[  >>            ]"
		printf "\r[  >>              >>            ]"
        sleep .1
        #printf "\r[prOgress] : [ / ]"
        #printf "\r[    >>          ]"
		printf "\r[    >>              >>          ]"
        sleep .1
        #printf "\r[proGress] : [ - ]"
        #printf "\r[      >>        ]"
		printf "\r[      >>              >>        ]"
        sleep .1
        #printf "\r[progRess] : [ \ ]"
        #printf "\r[        >>      ]"
		printf "\r[        >>              >>      ]"
        sleep .1
        #printf "\r[progrEss] : [ | ]"
        #printf "\r[          >>    ]"
		printf "\r[          >>              >>    ]"
        sleep .1
        #printf "\r[progreSs] : [ / ]"
        #printf "\r[            >>  ]"
		printf "\r[            >>              >>  ]"
        sleep .1
        #printf "\r[progresS] : [ - ]"
        #printf "\r[              >>]"
		printf "\r[              >>              >>]"
        #loopcount = `expr $loopcount + 1`
        #let lopcount = $loopcount++
        #printf "loop iteration:"
        ((loopcount++))
    done;
}

pids=""

printf "Starting jobs                \n"
job1&
#pids+="$! "
pids="$pids $! "
job2&
pids+="$! "
job3&
pids+="$! "
job4&
pids+="$! "
job5&
pids+="$! "
job6&
pids+="$! "

printf "$pids\n"

progressbar &
progress_id=$!
trap 'stop_progress $progress_id' SIGINT


for pid in $pids; do
    wait $pid
    if [ $? -eq 0 ]; then
        printf "\rSUCCESS - Job $pid exited with a status of $?\n"
    else
        printf "\rFAILED - Job $pid exited with a status of $?"
    fi
done

stop_progress $progress_id
#wait < <(jobs -p)

