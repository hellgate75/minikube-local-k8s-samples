#!/bin/sh

FOLDER="$(realpath "$(dirname "$0")")"

if [ -e $FOLDER/help ]; then
	rm -Rf $FOLDER/help
fi
mkdir $FOLDER/help
INDEX=""
echo "Creating help for api versions ..."
echo -e "$(kubectl api-versions)" > $FOLDER/help/_api-versions.txt 2> /dev/null
echo "Help for for api versions creation complete"
INDEX="${INDEX}api-versions $FOLDER/help/_api-versions.txt\n"
for apiRef in $(kubectl  api-resources|grep -v NAME|awk 'BEGIN {FS=OFS=" "}{print $1}')
do
echo "Creating help for element: $apiRef ..."
echo -e "$(kubectl explain $apiRef --recursive=true)" > $FOLDER/help/$apiRef-tmp.txt 2> /dev/null
LINE=$(grep -n 'FIELDS:' $FOLDER/help/$apiRef-tmp.txt | cut -d : -f 1)
LINES="$(wc -l $FOLDER/help/$apiRef-tmp.txt|awk 'BEGIN {FS=OFS=" "}{print $1}')"
VAL=$(( $LINES - $LINE ))
EXTENDED="$(sh -c "tail -$VAL $FOLDER/help/$apiRef-tmp.txt")"
rm -f $FOLDER/help/$apiRef-tmp.txt
echo -e "API:\n$(kubectl explain $apiRef)\nDETAILS:\n$EXTENDED\n" > $FOLDER/help/$apiRef.txt 2> /dev/null
INDEX="${INDEX}$apiRef $FOLDER/help/$apiRef.txt\n"
echo "Help for element: $apiRef creation complete"
done
echo "Creating help index ..."
echo -e "$INDEX" > $FOLDER/help/_index 2> /dev/null
echo "Help index creation complete"
