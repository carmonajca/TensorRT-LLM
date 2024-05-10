FROM nvidia/cuda:12.1.0-devel-ubuntu22.04 AS dev

ENV USERNAME "python"
ENV APP_HOME "/home/$USERNAME"
ENV APP_PATH "$APP_HOME/code"
ARG uid
ARG gid
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y \
    && apt-get install -y python3-pip git python3.10 openmpi-bin libopenmpi-dev sudo git-lfs screen
RUN groupadd -g "$gid" "$USERNAME" \
    && useradd -u "$uid" -g "$gid" "$USERNAME" \
    && mkhomedir_helper "$USERNAME"

USER "$USERNAME"
ENV PATH="${PATH}:$APP_HOME/.local/bin"
RUN pip3 install tensorrt_llm -U --pre --extra-index-url https://pypi.nvidia.com

# Check installation
# ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH"
# RUN python3 -c "import tensorrt_llm"

WORKDIR "$APP_HOME"
RUN git clone https://github.com/NVIDIA/TensorRT-LLM.git

RUN pip install -r TensorRT-LLM/examples/bloom/requirements.txt
RUN git-lfs install
RUT apt-get install screen