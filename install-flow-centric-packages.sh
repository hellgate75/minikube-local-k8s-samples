#!/bin/sh

for file in $(ls -l files/*-storage.yml | awk 'BEGIN {FS=OFS=" "}{print $NF}')
do
   NAME="$(echo "$file" | awk 'BEGIN {FS=OFS="statefulset-"}{print $NF}' | awk 'BEGIN {FS=OFS="."}{print $1}')"
   if [ "" != "$(kubectl get persistentvolume  $NAME)" ]; then
		echo "Deleting persistentvolume for: $NAME ..."
		kubectl delete persistentvolume  $NAME
   fi
   echo "Adding persistentvolume: $NAME ..."
   kubectl apply -f $file
   echo "Element: $NAME added!!"
done
kubectl get persistentvolume
for file in $(ls -l files/*-storage-claim.yml | awk 'BEGIN {FS=OFS=" "}{print $NF}')
do
   NAME="$(echo "$file" | awk 'BEGIN {FS=OFS="statefulset-"}{print $NF}' | awk 'BEGIN {FS=OFS="."}{print $1}')"
   if [ "" != "$(kubectl get persistentvolumeclaim  $NAME)" ]; then
		echo "Deleting persistentvolumeclaim for: $NAME ..."
		kubectl delete persistentvolumeclaim $NAME
	   fi
   echo "Adding persistentvolumeclaim: $NAME ..."
   kubectl apply -f $file
   echo "Element: $NAME added!!"
done
kubectl get persistentvolumeclaim

echo "Creating flow-centric POD ..."
kubectl delete pod flow-centric-pod
kubectl apply -f files/app-flow-centric-pod.yml
echo "flow-centric POD created"
kubectl get pods

echo "Creating flow-centric Service ..."
kubectl delete service flow-centric-service
kubectl apply -f files/app-flow-centric-service.yml
echo "flow-centric Service created"
kubectl get services

#echo "Creating flow-centric StatefulSet ..."
#kubectl apply -f files/app-flow-centric-statefullset-services.yml
#echo "flow-centric StatefulSet created"

#kubectl get statefulset
