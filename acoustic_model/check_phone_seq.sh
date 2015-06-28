dir=~/local_home/nn_post
fname=$1
w=$2
n=$3
cd $dir

while read fname flen
do
  ww=$(echo "$w*$flen*0.002" | bc)
  echo $fname $flen $ww
	# U
  echo -e '\tU 48_phone sequence'
  #fstshortestpath --nshortest=100 UH.fst/$fname'.fst' | ~/WFST_HCLG/fstprintallpath - isyms.txt | sort -u

	# UH
  fstinfo UH.fst/$fname'.fst' | grep "# of arcs"
  fstprune --weight=$ww UH.fst/$fname'.fst' UH_prune.fst
  fstinfo UH_prune.fst | grep "# of arcs"
  #echo -e '\tUH 39_phone sequence'
  #fstshortestpath --nshortest=100 UH_prune.fst | ~/WFST_HCLG/fstprintallpath - phones_disambig.txt | sort -u

	# UHL
  time fstcompose UH_prune.fst L.fst > UHL.fst
  echo -e "\tUHL compose done"
  echo -e "\t$n_best word sequence"
  fstshortestpath --nshortest=$n UHL.fst | ~/WFST_HCLG/fstprintallpath - words.txt | sort -u

	# UHLG

done < $dir/seq_info

  #fstdeterminize  UH.fst/$fname'.fst' dm_UH.fst
  #fstshortestpath --nshortest=$n --weight="1.4" UH.fst/$fname'.fst' > $n'_best'
  #fstshortestpath --nshortest=$n --unique=true dm_UH.fst > $n'_best'
  #fstprint --isymbols=isyms.txt --osymbols=phones_disambig.txt $n'_best' | cut -f4 | grep -v eps
  #fstprint --isymbols=isyms.txt --osymbols=phones_disambig.txt UH_prune.fst | cut -f4 | grep -v eps
  #fstshortestpath --nshortest=1 UHL.fst > 1_best_UHL
  #fstprint --isymbols=isyms.txt --osymbols=words.txt UHL.fst | cut -f4 | grep -v eps | uniq
