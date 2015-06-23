#!/bin/bash

cat timit+Holmes_featTimitVocab.LM.2gram | egrep -v '<s> <s>|</s> <s>|</s> </s>'| arpa2fst - | fstprint | fstcompile --isymbols=words.txt --osymbols=words.txt >../G.fst
#fstcompose Lexicon.fst LM.fst |fstprint --isymbols=phones_disambig.txt --osymbols=words.txt
