#!/bin/bash

if [ "$#" -ne "2" ]
then
	echo -e "\033[1;33m  Usage:$0 [Results Directory] [Rescoring Factor]\033[0m"
	exit
fi

U=$1
factor=$2
ls $U >tmpL

while read line
do
	rnnscore=$(cut -f2- -d ',' $U/$line |./rescoring_rnnlm+srilm.sh)
	uhclgscore=$(cut -f1 -d ',' $U/$line)
	paste <(bc <<< "scale=2; $(paste <(echo -e "$rnnscore") <(echo -e "$uhclgscore")|sed "s%\t%+%g")*$factor ")\
	<(cat $U/$line|cut -f2- -d ',') |sort -n|head -n 1|cut -f2-
	if [[ -s $U/$line ]]
	then
		true
	else
		echo ""
	fi
done <tmpL

rm tmpL
