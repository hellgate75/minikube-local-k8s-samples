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

if [ "--delete" = "$1" ]; then
	if [ "" != "$(kubectl get namespaces kubernetes-dashboard|grep -v NAME)" ]; then
		echo "Deleting kubernetes dashboard ..."
		kubectl delete namespaces kubernetes-dashboard
	else
		echo "No dashboard found."
	fi
	exit 0
fi

if [ "" = "$(kubectl get namespaces kubernetes-dashboard|grep -v NAME)" ]; then
	echo "Creating kubernetes dashboard ..."
	LATEST="$(curl -s https://github.com/kubernetes/dashboard/releases|grep dashboard|grep releases|grep tag|grep '/v'|head -1|awk 'BEGIN {FS=OFS=" "}{print $NF}'|tail -1|awk 'BEGIN {FS=OFS="<"}{print $1}'|awk 'BEGIN {FS=OFS=">"}{print $NF}')"
	if [ "" == "$LATEST" ]; then
		LATEST="v2.0.0-beta8"
	fi
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/$LATEST/aio/deploy/recommended.yaml
elif [ "" = "$(kubectl get namespaces kubernetes-dashboard|grep -v NAME|grep -i active)" ]; then
	echo "Removing and creating kubernetes dashboard ..."
	kubectl delete namespaces kubernetes-dashboard
	bash -c "$FOLDER/install-show-dashboard.sh"
	exit 0
fi

echo "Showing kubernetes dashboard ..."

sh -c "python -m webbrowser  http://localhost:8081/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/" &
kubectl proxy --port=8081
