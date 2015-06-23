#!/bin/bash

# generating Lexicon fst

   cut -f3 phones.60-48-39.map | grep -v "q" | sort | uniq > phone_list

   echo "<eps> 0" > phones_num
   awk '{ print $0 " " FNR }' phone_list >> phones_num

   grep -v -E "^;" timitdic.txt | sed -e 's/\///g' -e 's/[0-9]//g' -e 's/\~[a-zA-Z_\~]* / /g' > lexicon.txt
   echo "<s> sil" >> lexicon.txt
   echo "</s> sil" >> lexicon.txt
   echo "SIL sil" >> lexicon.txt
   #paste phone_list phone_list >> lexicon.txt

   ./timit_norm_trans.pl -ignore -i lexicon.txt -m phones.60-48-39.map -from 60 -to 39 > lexicon.39.txt

   cut -f1 -d ' ' lexicon.39.txt | \
      cat - <(echo "#0") | \
      awk '{ print $0 " " FNR }' | \
      cat <(echo "<eps> 0") - > words.txt

   # add disambig
   ndisambig=`./add_lex_disambig.pl lexicon.39.txt lexicon_disambig.txt` 
   ndisambig=$[$ndisambig+1];

   ./add_disambig.pl --include-zero phones_num $ndisambig  > phones_disambig.txt 

   phone_disambig_symbol=`grep \#0 phones_disambig.txt | awk '{print $2}'`
   word_disambig_symbol=`grep \#0 words.txt | awk '{print $2}'`

   ./make_lexicon_fst.pl lexicon.39.txt 0.5 "sil" \
      | sed -E 's/[0-9]*.?[0-9]+$//g' \
      | fstcompile --isymbols=phones_disambig.txt --osymbols=words.txt \
      --keep_isymbols=false --keep_osymbols=false \
      | fstarcsort --sort_type=olabel > Lexicon.fst 
    #  | ./fstaddselfloops  "echo $phone_disambig_symbol |" \
    #  "echo $word_disambig_symbol |" \
