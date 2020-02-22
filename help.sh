#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

function printUsage() {
	echo "help.sh <command|list>"
	echo "Show command help for required argument or list available help clauses"
}

if [ "" = "$1" ]; then
	echo "please provide an argument!!"
	echo "$(printUsage)"
	exit 1
fi

if [ "-h" = "$1" ] || [ "--help" = "$1" ] || [ "/?" = "$1" ]; then
	echo "$(printUsage)"
	exit 1
fi

if [ ! -e $FOLDER/help ] || [ ! -e $FOLDER/help/_index ]; then
	sh -c "$FOLDER/create-k8s-help.sh"
fi

COMMAND_LIST="$(cat $FOLDER/help/_index|awk 'BEGIN {FS=OFS=" "}{print $1}')"

if [ "list" = "$1" ]; then
	echo "List of help arguments:"
	echo "$COMMAND_LIST"
else
	if [ "" = "$(echo -e "$COMMAND_LIST"|grep $1)" ]; then
		echo "Argument: $1 NOT FOUND"
	else
		echo "Argument: $1"
		COMMAND_FILE="$(cat $FOLDER/help/_index|grep $1|head -1|awk 'BEGIN {FS=OFS=" "}{print $2}')"
		cat $COMMAND_FILE
	fi
fi
