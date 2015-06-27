dir=~/local_home/nn_post
# prepare files
# H.num.fst
# U.num.fst

# isyms.txt
echo -e "<eps>\t0" > $dir/isyms.txt
cat $dir/map.num2phone48 | awk '{print $2 "\t" $1}' >> $dir/isyms.txt

# U.text.fst
rm -r $dir/U.text.fst
mkdir $dir/U.text.fst

i=1
while read fname flen
do
  slen=$(($flen*48+1))
  echo -e "Text read from file - $fname\t$flen"
  head -n $(($i+$slen-1)) $dir/U.num.fst | tail -n $slen > tmp
  sh mapNum2Phone.sh tmp $dir/map.num2phone48 $dir/U.fst/U.$fname.fst
  i=$(($i+$slen))
done < $dir/seq_info

# H.text.fst
sh mapNum2Phone.sh $dir/H.num.fst $dir/map.num2phone48 tmpA
sh mapNum2Phone.sh $dir/H.num.fst $dir/map.num2phone39_no_sil tmpB
paste -d ' ' tmpA tmpB | cut -d ' ' -f1-3,9,10 > $dir/H.text.fst
rm tmp*

# inverse
sh inverse.sh
# compile
sh compile.sh
# prune
sh prune.sh
sh check_phone_seq.sh
