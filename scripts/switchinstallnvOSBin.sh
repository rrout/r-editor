#!/bin/bash

PWD=$(pwd)

echo "Workspace : $PWD $0 $1 $2"

bash /build/rrout/dbg/installnvOSBin.sh $1 $PWD

