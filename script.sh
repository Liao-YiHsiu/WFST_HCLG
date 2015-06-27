#!/bin/bash

U=$1

fstcompose H.fst L.fst >HL.fst
fstcompose HL.fst G.fst |  fstminimizeencoded |fstarcsort --sort_type=olabel > HLG.fst
fstprune --weight="1" $U >$U'_prune'
fstcompose $U'_prune' HLG.fst >$U'_pruneUHLG'
time cat $U'_pruneUHLG' |fstshortestpath --nshortest=1000 |tee $U'_pruneUHLG_fstshortestpath1000'| ./fstprintallpath - words.txt > $U'_pruneUHLG.result'
