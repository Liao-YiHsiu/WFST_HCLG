fname=fsem0_si1198
$dir=~/local_home/nn_post
cd $dir
#cat UH.fst/$fname.fst | fstdraw --isymbols=isyms.txt --osymbols=phones_disambig.txt -portrait - | dot -Tsvg > $fname.UH.svg

cat UH.fst/$fname.fst | fstshortestpath --nshortest=1 | tee 1_best_$fname.UH | fstdraw --isymbols=isyms.txt --osymbols=phones_disambig.txt -portrait - | dot -Tsvg > 1_best.$fname.UH.svg
#cat 1_best_fsem0_si1198.UH | fstprint --isymbols=isyms.txt --osymbols=phones_disambig.txt
cd ~/WFST_HCLG/UH

#head -n 1 $(ls) | tr -d '\n' | sed 's/==> /\n/g' | sed 's/ <==/,/g' | cut -d, -f1,3 > ../G_1_C_10000.transcription
# test
