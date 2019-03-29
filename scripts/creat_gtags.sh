#!bin/bash
echo "Listing all .c .h .ccp .pcl files"
find . -name '*.cpp' -o -name '*.h' -o -name '*.c' -o -name '*.pcl' > gtags.files
#gtags -v -f gtags.files
echo "Creating Gtags Data Base at ${PWD}"
gtags -c -f gtags.files
echo "Deleting file list"
rm gtags.files
echo "Created Gtags files"
ls -lh G*
echo "Gtags Build @ ${pwd} Successfully"
