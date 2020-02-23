#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"
if [ "/usr/bin" = "$FOLDER" ]; then
	FOLDER="$(dirname "$(pwd)")"
fi
function lookupEnv() {
	if [ -e $FOLDER/../env.sh ]; then
	   source $FOLDER/../env.sh
	elif [ -e $FOLDER/.profile ]; then
	   source $FOLDER/env.sh
	elif [ -e ../.profile ]; then
	   source ../env.sh
	elif [ -e ./.profile ]; then    
	   source ./env.sh
	fi
}

function lookupProfile() {
	if [ -e $FOLDER/../.profile ]; then
	   echo "$(cat $FOLDER/../.profile 2> /dev/null)"
	elif [ -e $FOLDER/.profile ]; then
	   echo "$(cat $FOLDER/.profile 2> /dev/null)" 
	elif [ -e ../.profile ]; then
	   echo "$(cat ../.profile 2> /dev/null)"
	elif [ -e ./.profile ]; then    
	   echo "$(cat ./.profile 2> /dev/null)"
	fi
}
lookupEnv
PROFILE="$(lookupProfile)"

echo "Profile: $PROFILE"
if [ "" = "$PROFILE" ]; then
	PROFILE="minikube"
fi
CMD="minikube -p $PROFILE $@"
bash -c "$CMD"
