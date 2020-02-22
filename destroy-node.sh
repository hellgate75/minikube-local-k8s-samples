#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

function lookupEnv() {
	if [ -e $FOLDER/.profile ]; then
	   source $FOLDER/env.sh
	elif [ -e ./.profile ]; then    
	   source ./env.sh
	fi
}

lookupEnv

sh $FOLDER/install.sh
RES="$?"
if [ "0" != "$RES" ]; then
	exit $RES
fi

sh $FOLDER/check-profile.sh

PROFILE="$(lookupProfile)"
PROFILE_TAG=""
if [ "" != "$PROFILE" ] && [ "minikube" != "$PROFILE" ]; then
	PROFILE_TAG="-p $PROFILE"
fi

if [ "" == "$(echo $PATH|grep $FOLDER/bin)" ]; then
	PATH=$PATH:$FOLDER/bin
fi

if [ "" = "$(which kubectl)" ]; then
	echo "Unable to locate kubectl, please install it ..."
fi

if [ "" = "$(which minikube)" ]; then
	echo "Unable to locate mini-kube, please install it ..."
	exit 1
fi

STATUS="$(minikube status $PROFILE_TAG)"
if [ "" = "$(echo $STATUS|grep -i nonexistent)" ]; then
	if [ "" != "$(echo $STATUS|grep -i running)" ]; then
		$FOLDER/stop-node.sh
	fi
	echo "Destroying Minikube ..."
	sh -c "minikube delete $PROFILE_TAG"
	if [ -e $FOLDER/.profile ]; then
		rm -f $FOLDER/.profile
	fi
	if [ -e $FOLDER/.version ]; then
		rm -f $FOLDER/.version
	fi
	echo "Minikube destroyed ..."
else
	echo "Minikube already destroyed ..."
fi