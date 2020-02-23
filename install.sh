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

if [ "" = "$(which minikube 2> /dev/null)" ]; then
    echo "Installing mini-kube ..."
	
	LATEST="$(curl -sL https://github.com/kubernetes/minikube/releases/latest 2> /dev/null |grep kubernetes|grep minikube|grep releases|grep tag|awk 'BEGIN {FS=OFS=" "}{print $NF}'|tail -1|awk 'BEGIN {FS=OFS="<"}{print $1}'|awk 'BEGIN {FS=OFS=">"}{print $NF}')"
	if [ "" = "$LATEST" ]; then
		LATEST="v1.7.3"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi

	curl -sL https://github.com/kubernetes/minikube/releases/download/$LATEST/minikube-$OS-amd64$EXT -o $FOLDER/bin/minikube$EXT
	if [ "" == "$(which minikube 2> /dev/null)" ]; then
		echo "Error: Unable to install mini-kube!!"
		exit 3
	fi
	echo "Tool mini-kube installed correctly!!"
fi

if [ "" = "$(which kubectl 2> /dev/null)" ]; then
	echo "Install mini-kube ..."
	LATEST="$(curl -sL https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
	if [ "" = "$LATEST" ]; then
		LATEST="v1.17.0"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi
	curl -sLO https://storage.googleapis.com/kubernetes-release/release/$LATEST/bin/$OS/amd64/kubectl$EXT -o $FOLDER/bin/kubectl$EXT
	if [ "" == "$(which kubectl 2> /dev/null)" ]; then
		echo "Error: Unable to install kubectl!!"
		exit 4
	fi
	echo "Tool kubectl installed correctly!!"
fi

if [ "" = "$(which helm 2> /dev/null)" ]; then
	echo "Install helm ..."
	LATEST="$(curl -sL https://github.com/helm/helm/releases |grep helm|grep releases|grep tag|grep Helm|head -1|awk 'BEGIN {FS=OFS=" "}{print $NF}'|tail -1|awk 'BEGIN {FS=OFS="<"}{print $1}'|awk 'BEGIN {FS=OFS=">"}{print $NF}')"
	if [ "" = "$LATEST" ]; then
		LATEST="v2.16.3"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi
	
	curl -sL https://raw.githubusercontent.com/helm/helm/master/scripts/get > $FOLDER/bin/get_helm.sh
	if [ -e $FOLDER/bin/get_helm.sh ]; then
		bash -c "export HELM_INSTALL_DIR="$FOLDER/bin"&& alias sudo=\"/bin/sh\" && $FOLDER/bin/get_helm.sh --no-sudo -v $LATEST"
		rm -f $FOLDER/bin/helm-*.tar.gz
		rm -f $FOLDER/bin/get_helm.sh
	fi
	if [ "" == "$(which helm 2> /dev/null)" ]; then
		echo "Error: Unable to install helm!!"
		exit 4
	fi
	echo "Tool helm installed correctly!!"
fi

if [ "" = "$(which kops 2> /dev/null)" ]; then
	echo "Install kops ..."
	LATEST="$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)"
	if [ "" = "$LATEST" ]; then
		LATEST="v1.15.2"
		echo "Unable to locate latest version using : $LATEST"
	else
		echo "Latest verion is : $LATEST"
	fi
	
	curl -sL  https://github.com/kubernetes/kops/releases/download/1.15.0/kops-windows-amd64 -o $FOLDER/bin/kops$EXT
	if [ "" == "$(which kops 2> /dev/null)" ]; then
		echo "Error: Unable to install kops!!"
		exit 4
	fi
	echo "Tool kops installed correctly!!"
fi



