dir=~/local_home/nn_post
rm -f $dir/UHLG.fst;mkdir $dir/UHLG.fst

while read fname flen
do
echo $fname
  fstcompose $dir/UH.fst/$fname.fst LG.fst $dir/UHLG.fst/$fname.fst
done < $dir/seq_info
