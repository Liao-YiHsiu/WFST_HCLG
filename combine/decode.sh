dir=~/local_home/nn_post
rm -rf $dir/decode;mkdir $dir/decode

for file in $dir/UHLG.fst/*.fst;
do
echo $file
  cat $file | fstshortestpath --nshortest=1 > $file.decode
  #fstprint --isymbols=isyms.txt --osymbols=words.txt $file.decode | cut -f4 | grep -v "<eps>" > $dir
done
