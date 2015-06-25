dir=~/local_home/nn_post
fstcompile --isymbols=$dir/isyms.txt --osymbols=$dir/phones_disambig.txt $dir/H.text.fst_inv | fstarcsort --sort_type=olabel > $dir/H.fst

rm -rf $dir/U.fst;mkdir $dir/U.fst
rm -rf $dir/UH.fst;mkdir $dir/UH.fst

while read fname flen
do
echo $fname
fstcompile --isymbols=$dir/isyms.txt --osymbols=$dir/osyms.txt $dir/U.text.fst/U.$fname.fst_inv | fstarcsort --sort_type=olabel > $dir/U.fst/$fname.fst
fstcompose $dir/U.fst/$fname.fst $dir/H.fst $dir/UH.fst/$fname.fst
done < $dir/seq_info
