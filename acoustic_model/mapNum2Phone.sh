[ "$#" -ne 3 ] && echo "Usage : $0 <input> <map> <output>" && exit 1
dir=~/local_home/nn_post

cut -d ' ' -f1-2 $1 > tmp1
cut -d ' ' -f3- $1 | sed '/^$/d' > tmp2

rm -f tmp3
while read tok1 tok2 tok3
do
  a=$(head -n $tok1 $2 | tail -n 1 | cut -d '	' -f 2)

  if [ "$tok2" == "<eps>" ]
  then
    b=$tok2
  else
    b=$(head -n $tok2 $2 | tail -n 1 | cut -d '	' -f 2)
  fi
  echo "$a $b $tok3" >> tmp3
done < tmp2

paste -d ' ' tmp1 tmp3 > $3
rm -f tmp1 tmp2 tmp3
