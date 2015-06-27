dir=~/local_home/nn_post


# U.text
for file in $dir/U.text.fst/*.fst;
do
  echo $file;
  cut -d ' ' -f5 $file > score
  $dir/U.text.fst/inverse score
  cut -d ' ' -f1-4 $file > tmp 
  paste tmp score_inv > $file'_inv'
done

# H.text
file=$dir/H.text.fst 
cut -d ' ' -f5 $file > score
$dir/U.text.fst/inverse score
cut -d ' ' -f1-4 $file > tmp 
paste tmp score_inv > $file'_inv'
rm -f tmp score score_inv
