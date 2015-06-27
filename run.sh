#!/bin/bash -e

tmpdir=$(mktemp -d)
nbest=1000
G_scale=1
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

graph=data/HCLG${G_scale}.fst

if [ ! -f $graph ]; then

   [ ! -f L.fst ] && (cd lexicon && ./run.sh) > /dev/null 
#[ ! -f G.fst ] && (cd language_model && ./run.sh)

   [ ! -f data/HC.fst  ] && fstcompose H.fst  C.fst > data/HC.fst
   [ ! -f data/HCL.fst ] && fstcompose data/HC.fst L.fst > data/HCL.fst

   [ ! -f data/G${G_scale}.fst ] && fstscale G.fst $G_scale data/G${G_scale}.fst

   fstcompose data/HCL.fst data/G${G_scale}.fst | fstminimizeencoded | fstarcsort --sort_type=olabel > $graph
fi

fsttrim $U 1 $tmpdir/prune.fst
fstcompose $tmpdir/prune.fst $graph > $tmpdir/result.fst
              
fstshortestpath --nshortest=$nbest $tmpdir/result.fst | \
        fstprintallpath - ./lexicon/words.txt  | \
        sort -u

rm -r $tmpdir
