#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"
if [ "/usr/bin" = "$FOLDER" ]; then
	FOLDER="$(dirname "$(pwd)")"
fi

function lookupEnv() {
	if [ -e $FOLDER/env.sh ]; then
	   source $FOLDER/env.sh
	elif [ -e ./env.sh ]; then    
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
VM_DRIVER="virtualbox"
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
			VM_DRIVER="$OPTION"
			echo "Using vm driver: $OPTION"
			OPTION="--vm-driver=$OPTION"
		else
			echo "Using vm driver: <auto-detect>"
		fi
		if [ "" == "$KUBEVER" ]; then
			echo "Please provide kubernetes version :"
			echo "options: $(curl -sL https://github.com/kubernetes/kubernetes/releases |grep releases|grep tag|grep '/kubernetes/kubernetes/'|awk 'BEGIN {FS=OFS="/tag/"}{print $NF}'|awk 'BEGIN {FS=OFS="\""}{print $1}'|xargs echo) ..."
			echo "( see here for more details: https://minikube.sigs.k8s.io/docs/reference/configuration/kubernetes/)"
			printf "Choice [default: v1.17.0]: "
			read VER
			if [ "" = "$VER" ]; then
				VER="v1.17.0"
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
	if [ "" != "$PROFILE" ]; then
		sh -c "kubectl config use-context $PROFILE"
	fi
	sh -c "cat $FOLDER/files/install-x.sh | minikube $PROFILE_TAG ssh"  2>&1 1> /dev/null
	sh -c "minikube $PROFILE_TAG config set vm-driver $VM_DRIVER"
	echo "Minikube started ..."
else
	echo "Minikube already running ..."
fi
