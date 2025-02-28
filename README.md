# ComfyUI Docker

This is a Docker image for [ComfyUI](https://www.comfy.org/), which makes it extremely easy to run ComfyUI on Linux and Windows WSL2. The image also includes the [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager) extension.

## Getting Started

To get started, you have to install [Docker](https://www.docker.com/). This can be either Docker Engine, which can be installed by following the [Docker Engine Installation Manual](https://docs.docker.com/engine/install/) or Docker Desktop, which can be installed by [downloading the installer](https://www.docker.com/products/docker-desktop/) for your operating system.

To enable the usage of NVIDIA GPUs, the NVIDIA Container Toolkit must be installed. The installation process is detailed in the [official documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Installation

### Docker Compose

Simply run `docker compose build` to build the ComfyUI image locally.

#### Volumes

| Folder             | Description                                          |
|--------------------|------------------------------------------------------|
| models             | Where your _model_ files are stored.                 |
| custom_nodes       | Where your _custom nodes_ are stored.                |
| workflows          | Where your _workflow_ files are stored.              |
| output             | Where your _output files_ are stored.                |
| input              | Where any _input files_ are saved by ComfyUI.        |
| manager            | Where the _ComfyUI Manager_ configuration is stored. |
| customrequirements | ComfyUI Manager's "Install PIP Module" option doesn't work properly in this container. Instead, you can place your requested modules in a _requirements.txt_ file in this folder, matching the [pip requirements file format](https://pip.pypa.io/en/stable/reference/requirements-file-format/) (typically just the name of the module, one per line), and the container will install it for you as it boots up. |
| pipcache           | Caches saved Python PIP Modules to disk to speed up restarts. |

#### Environment Variables (Optional)

| Env Variable   | Description                                             |
|----------------|---------------------------------------------------------|
| CLI_ARGS       | Any arguments you want to pass to ComfyUI when it runs. |
| PUID           | For Linux users. The _user id_ of your host machine, if you want the container to attempt to use your user so the files in volumes are owned by your user. You can find this by running `id -u`. |
| PGID           | For Linux users. The _group id_ of your host machine, if you want the container to attempt to use your user so the files in volumes are owned by your user's group. You can find this by running `id -g`. |

## Usage
After the container has started, you can navigate to [localhost:8188](http://localhost:8188) to access ComfyUI.

### Commands

| Action  | Command                  | Description                          |
|---------|--------------------------|--------------------------------------|
| Start   | `docker compose up -d`   | Start the ComfyUI container.         |
| Stop    | `docker compose stop`    | Stops the container, but does not remove it. |
| Down    | `docker compose down`   | Stops the container, and remove it. (Only data stored in the volumes will be persisted.) |
| Build   | `docker compose build` | Build a new local image. Use this when the Dockerfile has been changed. |

## Update

Set desired version numbers in the `docker-compose.yml` file's `args` section:
- `PYTORCH_IMG_VERSION`
- `COMFYUI_VERSION`
- `COMFYUI_MANAGER_VERSION`

Then run `docker compose build` to rebuild the image.

# Krita

Follow the steps:
- https://docs.interstice.cloud/installation/
- https://docs.interstice.cloud/comfyui-setup/
- https://docs.interstice.cloud/basics/
