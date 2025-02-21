# Define the arguments that are used in the Dockerfile.
ARG PYTORCH_IMG_VERSION
ARG COMFYUI_VERSION
ARG COMFYUI_MANAGER_VERSION

# This image is based on the PyTorch image, because it already contains CUDA, CuDNN, and PyTorch.
FROM pytorch/pytorch:${PYTORCH_IMG_VERSION}-runtime

# Need to define the (relevant) arguments again in the scope of the build stage.
ARG COMFYUI_VERSION
ARG COMFYUI_MANAGER_VERSION

# Install all additional dependencies.
#   git: because ComfyUI and the ComfyUI Manager are installed by cloning their respective Git repositories.
#   sudo: required for custom user.
#   ffmpeg: is very useful if doing video work.
#   build-essential: is useful if you need something like sageattention and triton.
RUN apt update --assume-yes && \
    apt install --assume-yes \
    git \
    sudo \
    ffmpeg \
    build-essential && \
    # Clones the ComfyUI repository and checks out the specified release.
    git clone --branch ${COMFYUI_VERSION} https://github.com/comfyanonymous/ComfyUI.git /opt/comfyui && \
    # Clones the ComfyUI Manager repository and checks out the specified release.
    # ComfyUI Manager is an extension for ComfyUI that enables users to install 
    # custom nodes and download models directly from the ComfyUI interface.
    # Instead of installing it to "/opt/comfyui/custom_nodes/ComfyUI-Manager", 
    # which is the directory it is meant to be installed in, it is installed to its own directory.
    # The entrypoint will symlink the directory to the correct location upon startup. 
    # The reason for this is that the ComfyUI Manager must be installed in the 
    # same directory that it installs custom nodes to, but this directory is mounted as a volume, 
    # so that the custom nodes are not installed inside of the container and are not lost 
    # when the container is removed. This way, the custom nodes are installed on the host machine.
    git clone --branch ${COMFYUI_MANAGER_VERSION} https://github.com/ltdrdata/ComfyUI-Manager.git /opt/comfyui-manager && \
    # Installs the required Python packages for both ComfyUI and the ComfyUI Manager.
    pip install --requirement /opt/comfyui/requirements.txt --requirement /opt/comfyui-manager/requirements.txt && \
    # Clean pip cache to reduce image size.
    pip cache purge && \
    # Clean apt cache to reduce image size.
    apt clean

# Sets the working directory to the ComfyUI directory.
WORKDIR /opt/comfyui

# Exposes the default port of ComfyUI. (Only metadata, not actually exposing the port to the host machine.)
EXPOSE 8188

# Set an env var for CLI_ARGS to be passed to the program.
ENV CLI_ARGS=""

# Adds the startup script to the container. 
# The startup script will create all necessary directories in the models and custom nodes volumes 
# that were mounted to the container and symlink the ComfyUI Manager to the correct directory. 
# It will also create a user with the same UID and GID as the user that started the container, 
# so that the files created by the container are owned by the user that started the container and not the root user.
COPY --chmod=0755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

# On startup, ComfyUI is started at its default port. 
# The IP address is changed from localhost to 0.0.0.0, because Docker is only forwarding traffic
# to the IP address it assigns to the container, which is unknown at build time. 
# Listening to 0.0.0.0 means that ComfyUI listens to all incoming traffic.
CMD ["/opt/conda/bin/python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
