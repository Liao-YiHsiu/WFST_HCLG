dir=~/local_home/nn_post

for file in $dir/U.text.fst/*.fst;
do
echo $file;
cut -d ' ' -f5 $file > score
$dir/U.text.fst/inverse score
cut -d ' ' -f1-4 $file > tmp 
paste tmp score_inv > $file'_inv'
done

file=$dir/H.text.fst 
cut -d ' ' -f5 $file > score
$dir/U.text.fst/inverse score
cut -d ' ' -f1-4 $file > tmp 
paste tmp score_inv > $file'_inv'

rm -f tmp score score_inv
