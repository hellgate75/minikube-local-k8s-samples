#!/bin/bash
FOLDER="$(realpath "$(dirname "$0")")"
if [ "" == "$(echo $PATH|grep $FOLDER/bin)" ]; then
	export PATH="$PATH:$FOLDER/bin"
#	echo "FOLDER: $FOLDER/bin"
#	echo "Path: $PATH"
fi
