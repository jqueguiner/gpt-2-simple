model=$1
for l in $(ls languages); 
do 
  sh process_language.sh $l $model
done
