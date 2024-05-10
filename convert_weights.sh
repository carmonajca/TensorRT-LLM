#!/usr/bin/env bash

MODEL=Meta-Llama-3-70B-Instruct
N_GPUS=8

# las V100 no soportan bfloat16
python3 TensorRT-LLM/examples/llama/convert_checkpoint.py \
	--model_dir meta-llama/${MODEL} \
	--output_dir .cache/huggingface/hub/${MODEL}-tllm_checkpoint  \
	--dtype float16 \
	--tp_size ${N_GPUS}

	
trtllm-build --checkpoint_dir .cache/huggingface/hub/${MODEL}-tllm_checkpoint \
            --output_dir .cache/huggingface/hub/${MODEL}-tllm_checkpoint/${N_GPUS}-gpus \
            --gpt_attention_plugin float16 \
            --gemm_plugin float16 \
            --multi_block_mode enable \
            --cluster_key V100-PCIe-32GB