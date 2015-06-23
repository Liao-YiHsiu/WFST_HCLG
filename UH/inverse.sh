dir=~/local_home/nn_post

#rm -rf $dir/U.text.inv
#mkdir $dir/U.text.inv

#for file in $dir/U.text.fst/*.fst;
#do
#echo $file;
#cut -d ' ' -f5 $file > score
#$dir/U.text.fst/inverse score
#cut -d ' ' -f1-4 $file > tmp 
#paste tmp score > $file'_inv'
#done

file=$dir/H.text.fst 
cut -d ' ' -f5 $file > score
$dir/U.text.fst/inverse score
cut -d ' ' -f1-4 $file > tmp 
paste tmp score > $file'_inv'
