#!/bin/bash -e

# generating C.fst

value=0.1

[ "$#" -eq 1 ] && value=$1

echo "0 1 <eps> <eps> 0" > C.tex

while read phone;
do
   echo "1 1 $phone $phone 0" >> C.tex
done <../lexicon/phone_list

while read line;
do 
   array=($line)
   target=${array[0]}

   for phone in $line;
   do
      [ "$target" != "$phone" ] && \
         echo "1 1 $phone $target $value" >> C.tex
   done
done < rule.out

echo "1 0" >> C.tex

fstcompile --isymbols=../lexicon/phones_num --osymbols=../lexicon/phones_num C.tex | \
   fstarcsort --sort_type=olabel > ../C.fst

exit 0;
