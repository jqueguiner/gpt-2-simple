language=$1
model=$2
steps=$3
gpt_2_simple finetune languages/$language/split_$model\_BPE_encoded/ --checkpoint_dir $language/checkpoint --sample_every $steps --save_every $steps --model_name $model --run_name $language\_$model --multi_gpu True
