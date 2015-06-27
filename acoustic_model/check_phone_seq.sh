dir=~/local_home/nn_post
n=$1
fname=fadg0_si1279
echo $n
cd $dir

#while read fname flen
#do
  fstshortestpath --nshortest=$n UH.fst/$fname'.fst' > $n'_best'
  echo -e '\tphone sequence'
  fstprint --isymbols=isyms.txt --osymbols=phones_disambig.txt $n'_best' | cut -f4 | grep -v eps
  fstcompose $n'_best' L.fst > UHL.fst
  #fstshortestpath --nshortest=1 UHL.fst > 1_best_UHL
  echo -e '\tword sequence'
  fstprint --isymbols=isyms.txt --osymbols=words.txt UHL.fst | cut -f4 | grep -v eps
#done < $dir/seq_info
