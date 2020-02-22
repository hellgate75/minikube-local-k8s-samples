#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

function lookupEnv() {
	if [ -e $FOLDER/.profile ]; then
	   source $FOLDER/env.sh
	elif [ -e ./.profile ]; then    
	   source ./env.sh
	fi
}

if [ "--destroy" = "$1" ]; then
	if [ -e $FOLDER/.profile ]; then
		rm -f $FOLDER/.profile
	fi
fi
TRACE="N"
if [ "--trace" = "$1" ] || [ "--trace" = "$2" ]; then
	TRACE="Y"
fi

lookupEnv

PROFILE="$(lookupProfile)"
CURRENT_PROFILE="$(minikube profile 2> /dev/null|awk 'BEGIN {FS=OFS="* "}{print $NF}')"
echo "Active profile: $CURRENT_PROFILE"
choose="N"
if [ "" = "$PROFILE" ]; then
	printf "Please provide a suitable profile [default: minikube] : "
	read OPTION
	if [ "" != "$OPTION" ]; then
		echo "$OPTION" > $FOLDER/.profile
	else
		if [ ! -e $FOLDER/.profile ]; then
			touch $FOLDER/.profile
		fi
		echo "minikube" > $FOLDER/.profile
	fi
	PROFILE="$(cat $FOLDER/.profile 2> /dev/null)"
else
	choose="Y"
fi
if [ "" != "$PROFILE" ] && [ "minikube" != "$PROFILE" ]; then
	echo "Current Profile: < $PROFILE >"
	if [ "Y" = "$choose" ] && [ "Y" = "$TRACE" ]; then
		echo "If you want to clear the profile and recreate one please type ./check-profile.sh --destroy"
	fi
	if [ "" != "$(minikube profile list 2> /dev/null | grep $PROFILE)" ] && [ "$PROFILE" != "$CURRENT_PROFILE" ]; then
		echo "Changing profile from: <$CURRENT_PROFILE> to: <$PROFILE>"
		sh -c "minikube profile $PROFILE" *> /dev/null
	fi
else
	if [ "" != "$PROFILE" ] && [ "" != "$(minikube profile list 2> /dev/null)" ] && [ "$PROFILE" != "$CURRENT_PROFILE" ]; then
		echo "Changing profile from: <$CURRENT_PROFILE> to: <$PROFILE>"
		sh -c "minikube profile $PROFILE" *> /dev/null
	fi
	echo "Default <minikube> profile has been detected!!"
fi
