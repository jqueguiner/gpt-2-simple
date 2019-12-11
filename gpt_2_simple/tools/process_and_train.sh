language=$1
model=$2
source 
./process_language.sh $language $model && ./train.sh $language $model
