model=$1

if [ ! -d languages/models/$model ]
then
  mkdir -p languages/models/$model
  for file in encoder.json vocab.bpe checkpoint hparams.json model.ckpt.index model.ckpt.meta model.ckpt.data-00000-of-00001
  do
    echo $file
    wget -O /data/gpt2/languages/models/$model/$file "https://storage.googleapis.com/gpt-2/models/$model/$file"
  done
   
fi
