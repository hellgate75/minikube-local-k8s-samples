#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

source $FOLDER/env.sh

if [ ! -e $FOLDER/bin ]; then
	mkdir $FOLDER/bin
fi

if [ "" == "$(echo $PATH|grep $FOLDER/bin)" ]; then
	export PATH=$PATH:$FOLDER/bin
fi

OS="$(sh ./os.sh)"
EXT=""
if [ "unknown" = "$OS" ]; then
	echo "Unable to detect you system..."
	exit 1
fi

if [ "windows" = "$OS" ]; then
	EXT=".exe"
fi


MACHINE="$(uname -m)"
if [ "x86_64" != "$MACHINE" ]; then 
	echo "Unable to run the project on a 32-bit machine.."
	exit 2
fi

if [ "" = "$(which minikube)" ]; then
    echo "Installing mini-kube ..."
	
	LATEST="$(curl -sL https://github.com/kubernetes/minikube/releases/latest 2> /dev/null |grep kubernetes|grep minikube|grep releases|grep tag|awk 'BEGIN {FS=OFS=" "}{print $NF}'|tail -1|awk 'BEGIN {FS=OFS="<"}{print $1}'|awk 'BEGIN {FS=OFS=">"}{print $NF}')"
	if [ "" = "$LATEST" ]; then
		LATEST="v1.7.3"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi

	curl -sL https://github.com/kubernetes/minikube/releases/download/$LATEST/minikube-$OS-amd64$EXT -o $FOLDER/bin/minikube$EXT
	if [ "" == "$(which minikube)" ]; then
		echo "Error: Unable to install mini-kube!!"
		exit 3
	fi
	echo "Tool mini-kube installed correctly!!"
fi

if [ "" = "$(which kubectl)" ]; then
	echo "Install mini-kube ..."
	LATEST="$(curl -sL https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
	if [ "" = "$LATEST" ]; then
		LATEST="v1.17.0"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi
	curl -sLO https://storage.googleapis.com/kubernetes-release/release/$LATEST/bin/windows/amd64/kubectl$EXT -o $FOLDER/bin/kubectl$EXT
	if [ "" == "$(which kubectl)" ]; then
		echo "Error: Unable to install kubectl!!"
		exit 4
	fi
	echo "Tool kubectl installed correctly!!"
fi
