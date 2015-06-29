

file=$(mktemp)
while read input
do
	echo -e "$input" >>$file
done
rnnlm/rnnlm -test $file -rnnlm rnnlm.model0 -nbest -debug 0 -lm-prob ngram.txt -lambda 0.5
