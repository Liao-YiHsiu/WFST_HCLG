#!/bin/bash -e

tmp=$(mktemp)
cpus=12

nbest=
G_scale=
C_scale=
prune=

PATH=$PATH:./utils

. parse_options.sh

if [ $# -ne 2 ]; then
   echo "Compute run.sh in parallel manner."
   echo "Usage: $0 Udir outdir"
fi

indir=$1
outdir=$2

rm -rf $outdir && mkdir -p $outdir

for file in $indir/*
do
   outname=$(basename $file)
   echo " echo $outname && ./run.sh  \
      ${nbest:+ --nbest $nbest} \
      ${G_scale:+ --G-scale $G_scale} \
      ${C_scale:+ --C-scale $nbest} \
      ${prune:+ --prune $prune} \
      $file > $outdir/$outname " >> $tmp
done 

cat $tmp | xargs -I CMD --max-procs=$cpus bash -c CMD

rm -rf $tmp
