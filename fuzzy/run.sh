#!/bin/bash -e

# generating C.fst
tmp=$(mktemp)

value=0.1

[ $# -eq 1 ] && value=$1

echo "0 1 <eps> <eps> 0" > $tmp

while read phone;
do
   echo "1 1 $phone $phone 0" >> $tmp
done <../lexicon/phone_list

while read line;
do 
   array=($line)
   target=${array[0]}

   for phone in $line;
   do
      [ "$target" != "$phone" ] && \
         echo "1 1 $phone $target $value" >> $tmp
   done
done < rule.out

echo "1 0" >> $tmp

fstcompile --isymbols=../lexicon/phones_num --osymbols=../lexicon/phones_num $tmp | \
   fstarcsort --sort_type=olabel > ../data/C${value}.fst


rm -rf $tmp
exit 0;
