#!/bin/bash -e

tmpdir=$(mktemp -d)
nbest=1000
G_scale=1
C_scale=0.1
prune=1
PATH=$PATH:./utils

. parse_options.sh

if [ $# -ne 1 ]; then
   echo "Decode U.fst into word sequences."
   echo "Usage: $0 u.fst"
   echo 

   exit -1;
fi

U=$1

make -C utils >/dev/null 

graph=data/HC${C_scale}LG${G_scale}.fst

if [ ! -f $graph ]; then

   [ ! -d data ] && mkdir data

   [ ! -f L.fst ] && (cd lexicon && ./run.sh) > /dev/null 
#[ ! -f G.fst ] && (cd language_model && ./run.sh)

   [ ! -f data/C${C_scale}.fst ] && (cd fuzzy && ./run.sh $C_scale) 

   [ ! -f data/HC${C_scale}.fst  ] && fstcompose H.fst data/C${C_scale}.fst > data/HC${C_scale}.fst
   [ ! -f data/HC${C_scale}L.fst ] && fstcompose data/HC${C_scale}.fst L.fst > data/HC${C_scale}L.fst

   [ ! -f data/G${G_scale}.fst ] && fstscale G.fst $G_scale data/G${G_scale}.fst

   fstcompose data/HC${C_scale}L.fst data/G${G_scale}.fst | fstminimizeencoded 2>/dev/null | fstarcsort --sort_type=olabel > $graph
fi

fsttrim $U $prune $tmpdir/prune.fst
fstcompose $tmpdir/prune.fst $graph > $tmpdir/result.fst
              
fstshortestpath --nshortest=$nbest $tmpdir/result.fst | \
        fstprintallpath - ./lexicon/words.txt  | \
        sort -t, -g | sort -t, -k2 -u

rm -r $tmpdir
