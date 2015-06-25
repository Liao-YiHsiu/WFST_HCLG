dir=~/local_home/nn_post
rm -f $dir/UHL.fst;mkdir $dir/UHL.fst

while read fname flen
do
echo $fname
  fstcompose $dir/UH.fst/$fname.fst L.fst $dir/UHL.fst/$fname.fst
done < $dir/seq_info
