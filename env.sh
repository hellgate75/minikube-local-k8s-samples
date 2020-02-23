#!/bin/bash
FOLDER="$(realpath "$(dirname "$0")")"
if [ "/usr/bin" = "$FOLDER" ]; then
	FOLDER="$(dirname "$(pwd)")"
fi
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
function lookupVersion() {
	if [ -e $FOLDER/../.version ]; then
	   echo "$(cat $FOLDER/../.version 2> /dev/null)"
	elif [ -e $FOLDER/.version ]; then
	   echo "$(cat $FOLDER/.version 2> /dev/null)" 
	elif [ -e ../.version ]; then
	   echo "$(cat ../.version 2> /dev/null)"
	elif [ -e ./.version ]; then    
	   echo "$(cat ./.version 2> /dev/null)"
	fi
}

if [ "" == "$(echo $PATH|grep $FOLDER/bin)" ]; then
	export PATH="$PATH:$FOLDER/bin"
#	echo "FOLDER: $FOLDER/bin"
#	echo "Path: $PATH"
fi
export PROFILE="$(lookupProfile)"
export KUBEVER="$(lookupVersion)"

alias mk="./bin/minikube-local.sh"
alias kc=kubectl
#if [ ! -e ~/.kube/completion.bash.inc ]; then
#	echo "#!/bin/bash" > ~/.kube/completion.bash.inc
#	kubectl completion bash >> ~/.kube/completion.bash.inc
#	echo "alias kc=kubectl" >>  ~/.kube/completion.bash.inc
#	echo "complete -o default -o nospace -F __start_kubectl kc" >>  ~/.kube/completion.bash.inc
#	sed -i 's/_kubectl_api-resources/_kubectl_api_resources/' ~/.kube/completion.bash.inc
#	sed -i 's/_kubectl_api-versions/_kubectl_api_versions/' ~/.kube/completion.bash.inc
#fi
#if [ -e ~/.kube/completion.bash.inc ]; then
#	source ~/.kube/completion.bash.inc
#fi
if [ "" != "$PROFILE" ]; then
	kubectl config use-context $PROFILE
fi
