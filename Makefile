.PHONY: docker-build

docker-build:
	docker build --build-arg uid=$$(id -u) --build-arg gid=$$(id -g) -t tensorrt-llm:latest .

docker-run:
	export $$(cat .env | xargs) && \
		docker run -d -it --runtime nvidia --gpus all \
			--ipc=host \
			--env-file $${WORKING_DIR}/.env \
			-v $${HUGGING_FACE_DIR}:/home/python/.cache/huggingface \
			-v $${HUGGING_FACE_HUB_DIR}:/home/python/.cache/huggingface/hub \
			tensorrt-llm
run:
	docker exec -it tensorrt-llm mpirun -n 8 --allow-run-as-root \
		python3 /home/python/TensorRT-LLM/examples/run.py \
		--max_output_len 128 \
		--max_input_length 32768 \
		--engine_dir /home/python/.cache/huggingface/hub/Meta-Llama-3-70B-Instruct-tensorrt_ckpt \
		--tokenizer_dir /home/python/.cache/huggingface/hub/Meta-Llama-3-70B-Instruct