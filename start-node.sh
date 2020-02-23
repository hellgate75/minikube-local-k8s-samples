#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"
if [ "/usr/bin" = "$FOLDER" ]; then
	FOLDER="$(dirname "$(pwd)")"
fi

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
KUBEVER="$(lookupVersion)"
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
if [ "" = "$(echo $STATUS|grep -i running)" ]; then
	OPTION=""
	if [ "" != "$(echo $STATUS|grep -i nonexistent)" ]; then
		echo "Creating Minikube environment ..."
		LIST="$(minikube.exe start --help|grep vm-driver|grep virtualbox|awk 'BEGIN {FS=OFS=":"}{print $NF}')"
		echo "Please provide the driver type or leave blank for auto-detect : "
		echo "options: $LIST"
		printf "Choice [default: auto-detect]: "
		read OPTION
		if [ "" != "$OPTION" ]; then
			echo "Using vm driver: $OPTION"
			OPTION="--vm-driver=$OPTION"
		else
			echo "Using vm driver: <auto-detect>"
		fi
		if [ "" == "$KUBEVER" ]; then
			echo "Please provide kubernetes version :"
			echo "options: v1.5.0-alpha.0, v1.4.3, v1.4.2, v1.4.1, v1.4.0, v1.3.7, v1.3.6, v1.3.5, v1.3.4, v1.3.3, v1.3.0"
			echo "( see here for more details: https://minikube.sigs.k8s.io/docs/reference/configuration/kubernetes/)"
			printf "Choice [default: v1.17.3]: "
			read VER
			if [ "" = "$VER" ]; then
				VER="v1.4.3"
			fi
			KUBEVER="$VER"
			echo "$KUBEVER" > $FOLDER/.version
		fi
		OPTION="$OPTION --kubernetes-version=\"$KUBEVER\""
	fi
	OPTION="$PROFILE_TAG $OPTION"
	echo "Starting Minikube ..."
	echo "Running: <minikube start $OPTION>"
	sh -c "minikube start $OPTION"
	echo "Minikube started ..."
else
	echo "Minikube already running ..."
fi
