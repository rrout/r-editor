#!/bin/sh

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

color_echo () 
{
    tput setaf 3
    echo "INFO : $@"
    tput sgr0
}

col_echo () 
{
    tput setaf 2
    echo " $@"
    tput sgr0
}


color_echo "Command : $0 $1 $2 $3"
color_echo "Switch List"
color_echo "--------------------------------"
while read line
do
    col_echo "      $line"
done <$inputfile
color_echo "--------------------------------"
color_echo "Build path"
col_echo "      $2\n"

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
   echo "==============================================="
   color_echo "Logging in to switch $line"
   echo "==============================================="

   expect -f sshcpnvos.expect $line root test123 $2

   echo "\n\r"
   echo "_________________________________________________________"
   color_echo "Finished nvOS Install on switch $line"
   echo "_________________________________________________________\n\n"
done <$inputfile

echo "\n\n"
color_echo "Instalation Complete"
color_echo "Installed Image from loc : $2"
color_echo "On Target switch(s)"
while read line
do
    col_echo "$line "
done <$inputfile

color_echo "Thanks Happy Debug"


#echo "test" | sed "s,.*,$(tput setaf 1)&$(tput sgr0),"
#tput setaf 1
#ls -alt
#tput sgr0



