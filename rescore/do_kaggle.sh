#!/bin/bash
if [ "$#" -ne "1" ]
then
	echo -e "\033[1;33m  Usage:$0 [Sentence]\033[0m"
	echo "  Output: [Sentence].kaggle"
	exit
fi

echo "id,sequence" >$1.kaggle
paste test.list <(./MapKaggle timit.chmap $1)|sed "s%\t%,%g" >>$1.kaggle

