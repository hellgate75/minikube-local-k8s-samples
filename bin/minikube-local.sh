#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

PROFILE="$(cat $FOLDER/.profile 2> /dev/null)"

if [ "" = "$PROFILE" ]; then
	PROFILE="minikube"
fi

bash -c "minikube -p $PROFILE $@"