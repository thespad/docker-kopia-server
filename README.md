# [thespad/kopia-server](https://github.com/thespad/docker-kopia-server)

[![GitHub Release](https://img.shields.io/github/release/thespad/docker-kopia-server.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-kopia-server/releases)
![Commits](https://img.shields.io/github/commits-since/thespad/docker-kopia-server/latest?color=26689A&include_prereleases&logo=github&style=for-the-badge)
![Image Size](https://img.shields.io/docker/image-size/thespad/kopia-server/latest?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=Size)
[![Docker Pulls](https://img.shields.io/docker/pulls/thespad/kopia-server.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/thespad/kopia-server)
[![GitHub Stars](https://img.shields.io/github/stars/thespad/docker-kopia-server.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-kopia-server)
[![Docker Stars](https://img.shields.io/docker/stars/thespad/kopia-server.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/thespad/kopia-server)

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/thespad/docker-kopia-server/call-check-and-release.yml?branch=main&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Upstream%20Updates)](https://github.com/thespad/docker-kopia-server/actions/workflows/call-check-and-release.yml)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/thespad/docker-kopia-server/call-baseimage-update.yml?branch=main&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Baseimage%20Updates)](https://github.com/thespad/docker-kopia-server/actions/workflows/call-baseimage-update.yml)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/thespad/docker-kopia-server/call-build-image.yml?labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Build%20Image)](https://github.com/thespad/docker-kopia-server/actions/workflows/call-build-image.yml)

[Kopia](https://github.com/kopia/kopia) is a fast and secure open-source backup/restore tool that allows you to create encrypted snapshots of your data and save the snapshots to remote or cloud storage of your choice, to network-attached storage or server, or locally on your machine.

## Supported Architectures

Our images support multiple architectures and simply pulling `ghcr.io/thespad/kopia-server:latest` should retrieve the correct image for your arch.

The architectures supported by this image are:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| amd64 | ✅ | latest |
| arm64 | ✅ | latest |

## Application Setup

Web UI is accessible at `http://SERVERIP:PORT`

Image includes `rclone`, `sqlite` tools, and the `docker` CLI. To use docker mount the host socket into the container or use the `DOCKER_HOST` env to specify an alternative endpoint.

To mount backup snapshots as a local filesystem, a host FUSE device and `SYS_ADMIN` capability are required.

For more info see the docs for the [Kopia CLI](https://kopia.io/docs/reference/command-line/) and [Kopia Repository Server](https://kopia.io/docs/repository-server/).

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
services:
  kopia-server:
    image: ghcr.io/thespad/kopia-server:latest
    hostname: kopia-server
    container_name: kopia-server
    cap_add:
      - SYS_ADMIN # Optional
    environment:
      - PUID=0
      - PGID=0
      - TZ=Europe/London
      - KOPIA_HTTPS=true # Optional
      - KOPIA_UI_USERNAME=${KOPIA_USERNAME}
      - KOPIA_UI_PASSWORD=${KOPIA_PASSWORD}
      - KOPIA_SERVER_USERNAME=${KOPIA_SERVER_USERNAME}
      - KOPIA_SERVER_PASSWORD=${KOPIA_SERVER_USERNAME}
      - KOPIA_PASSWORD=${KOPIA_REPO_PASSWORD}
      - REFRESH_INTERVAL= # Optional
    volumes:
      - /path/to/appdata/config:/config
      - /home/user:/backups/home:ro # Optional
      - /var/lib/docker/volumes:/backups/docker:ro # Optional
      - /mnt/backup/kopia:/repository # Optional
      - /tmp:/tmp:shared # Optional
      - /var/run/docker.sock:/var/run/docker.sock:ro # Optional
    devices:
      - /dev/fuse:/dev/fuse:rwm # Optional
    ports:
      - 51515:51515
    restart: unless-stopped
```

### docker cli

```shell
docker run -d \
  --name=kopia-server \
  --hostname=kopia-server \
  --cap-add=SYS_ADMIN `#Optional` \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Europe/London \
  -e KOPIA_HTTPS=true `#Optional` \
  -e KOPIA_UI_USERNAME=${KOPIA_USERNAME} \
  -e KOPIA_UI_PASSWORD=${KOPIA_PASSWORD} \
  -e KOPIA_SERVER_USERNAME=${KOPIA_SERVER_USERNAME}
  -e KOPIA_SERVER_PASSWORD=${KOPIA_SERVER_USERNAME}
  -e KOPIA_PASSWORD=${KOPIA_REPO_PASSWORD} \
  -e REFRESH_INTERVAL= `#optional` \
  -p 51515:51515 \
  -v /path/to/appdata/config:/config \
  -v /home/user:/backups/home:ro `#Optional` \
  -v /var/lib/docker/volumes:/backups/docker:ro `#Optional` \
  -v /mnt/backup/kopia:/repository `#Optional` \
  -v /tmp:/tmp:shared `#Optional` \
  -v /var/run/docker.sock:/var/run/docker.sock:ro `#Optional` \
  --devices /dev/fuse:/dev/fuse:rwm `#Optional` \
  --restart unless-stopped \
  ghcr.io/thespad/kopia-server
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 51515` | Web UI. |
| `--cap-add=SYS_ADMIN` | Required for mounting snapshots via FUSE. |
| `-e PUID=0` | for UserID - see below for explanation. |
| `-e PGID=0` | for GroupID - see below for explanation. |
| `-e TZ=Europe/London` | Specify a timezone to use e.g. Europe/London. |
| `-e KOPIA_HTTPS=` | Set to `true` to enable self-signed TLS for Web UI (required for remote client connections). |
| `-e KOPIA_UI_USERNAME=` | Web UI username. |
| `-e KOPIA_UI_PASSWORD=` | Web UI password. |
| `-e KOPIA_SERVER_USERNAME=` | Server control username. |
| `-e KOPIA_SERVER_PASSWORD=` | Server control password. |
| `-e KOPIA_PASSWORD=` | Password for connecting to backup repository. |
| `-e REFRESH_INTERVAL=` | Repository refesh interval. Increase if using metered cloud storage. Specify in h/m/s. Defaults to `300s`. |
| `-v /config` | Contains all relevant configuration files. |
| `-v /backups:ro` | Path(s) to files you want to back up. |
| `-v /repository` | Backup repository location if using local/NFS repository. |
| `-v /tmp:shared` | Temp path for mounting snapshots. Requires FUSE device and SYS_ADMIN capability. |
| `-v /var/run/docker.sock:ro` | Path to docker socket if interacting with other containers. |
| `--devices /dev/fuse:rwm` | Host FUSE device if using snapshot mounts. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```shell
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```shell
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Support Info

* Shell access whilst the container is running: `docker exec -it kopia-server /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f kopia-server`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. We do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull kopia-server`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d kopia-server`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/thespad/kopia-server`
* Stop the running container: `docker stop kopia-server`
* Delete the container: `docker rm kopia-server`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Image Update Notifications - Diun (Docker Image Update Notifier)

>[!TIP]
>We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```shell
git clone https://github.com/thespad/docker-kopia-server.git
cd docker-kopia-server
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/thespad/kopia-server:latest .
```

The arm variants can be built on x86_64 hardware and vice versa using `lscr.io/linuxserver/qemu-static`

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

## Versions

* **06.12.25:** - Rebase to Alpine 3.22.
* **25.07.25:** - Rebase to Alpine 3.22.
* **24.01.25:** - Rebase to Alpine 3.21.
* **26.05.24:** - Rebase to Alpine 3.20.
* **30.12.23:** - Rebase to Alpine 3.19.
* **01.07.23:** - Add GNU findutils.
* **12.06.23:** - Fix arm64 build.
* **03.05.23:** - Initial Release.
