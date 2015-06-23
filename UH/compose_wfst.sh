dir=~/local_home/nn_post
fstcompile --isymbols=isyms.txt --osymbols=osyms.txt $dir/H.text.fst | fstarcsort --sort_type=olabel > $dir/H.fst
fstcompile --isymbols=isyms.txt --osymbols=osyms.txt $dir/U.fst/U.fdhc0_si1559.fst | fstarcsort --sort_type=olabel > $dir/U.fst/fdhc0_si1559.fst
fstcompose $dir/H.fst $dir/U.fst/fdhc0_si1559.fst $dir/UH.fst
