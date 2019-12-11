language=$1
l=$1
model=$2
cd languages

touch_file="$l/$model"
echo $touch_file
if [ ! -f  "$touch_file" ]
then
    echo "processing $l"
    cd $language
    swift list datasets | grep $l\_dedup.txt.gz
    if [ ! -z $(swift list datasets | grep $l\_dedup.txt.gz) ]
    then
      echo "original dataset already exists"
    else
      rm -rf original
      mkdir -p original
      cd original
      wget https://traces1.inria.fr/oscar/files/Compressed/$l\_dedup.txt.gz
    swift upload -S 1073741824  --object-name /languages/oscar/$l/original/$l\_dedup.txt.gz datasets $l\_dedup.txt.gz
      unpigz $l\_dedup.txt.gz
      cd ..
    fi

    if [ ! -d models ]
    then
      ln -s ../models models
    fi

    if [ ! -d split ]
    then
      mkdir -p split
      split -C 500M --additional-suffix=.txt --numeric-suffixes --suffix-length=3 original/$l\_dedup.txt split/$l\_; 
      swift upload --object-name /languages/oscar/$l/split datasets split
      rm -rf original
    fi

    mkdir -p split_$model\_BPE_encoded

    for f in $(ls split)
    do
      if [ ! -f split_$model\_BPE_encoded/$f.npz ]; 
      then
        python ../../tools/gpt-2/encode.py split/$f split_$model\_BPE_encoded/$f.npz --model_name $model
      fi
    done
    swift upload -S 1073741824 --object-name /languages/oscar/$l/split_$model\_BPE_encoded datasets split_$model\_BPE_encoded
    touch $model
else
  echo "$l already processed for model $model"
fi
