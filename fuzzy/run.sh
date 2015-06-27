#!/bin/bash -e

# generating C.fst

rm -f lexicon.39.txt

while read phone;
do
   echo "$phone $phone" >> lexicon.39.txt
done <../lexicon/phone_list

while read line;
do 
   array=($line)
   target=${array[0]}

   for phone in $line;
   do
      [ "$target" != "$phone" ] && echo "$phone $target" >> lexicon.39.txt
   done
done < rule.out

   cut -f1 -d ' ' lexicon.39.txt | \
      cat - <(echo "#0") | \
      awk '{ print $0 " " FNR }' | \
      cat <(echo "<eps> 0") - > words.txt

   # add disambig
   ndisambig=`../lexicon/add_lex_disambig.pl lexicon.39.txt lexicon_disambig.txt` 
   ndisambig=$[$ndisambig+1];

   ../lexicon/add_disambig.pl --include-zero ../lexicon/phones_num $ndisambig  > phones_disambig.txt 

   phone_disambig_symbol=`grep \#0 phones_disambig.txt | awk '{print $2}'`
   word_disambig_symbol=`grep \#0 words.txt | awk '{print $2}'`

  #    | sed -E 's/[0-9]*.?[0-9]+$//g' \


# ../lexicon/make_lexicon_fst.pl lexicon.39.txt 0.5 "sil" \
#      | tee tmp \
   cat tmp \
      | fstcompile --isymbols=phones_disambig.txt --osymbols=words.txt \
      --keep_isymbols=false --keep_osymbols=false \
      | ../lexicon/fstaddselfloops  "echo $phone_disambig_symbol |" \
      "echo $word_disambig_symbol |" \
      | fstarcsort --sort_type=olabel > ../C.fst 


#fstcompile --isymbols=../lexicon/phones_num --osymbols=../lexicon/phones_num C.tex > ../C.fst
