# 🐳 Docker CLI Cheat Sheet

A complete **Docker Command Line Reference** with usage, commands, and global options.  
Perfect for beginners, DevOps engineers, and anyone working with containers.  

---

## 📑 Table of Contents
- [Usage](#-usage)
- [Common Commands](#-common-commands)
- [Management Commands](#-management-commands)
- [Swarm & Orchestration](#-swarm--orchestration)
- [Other Useful Commands](#-other-useful-commands)
- [Global Options](#-global-options)
- [Subcommand References](#-subcommand-references)
  - [docker container](#docker-container)
  - [docker image](#docker-image)
  - [docker volume](#docker-volume)
  - [docker network](#docker-network)
- [More Help](#-more-help)

---

## 📌 Usage

```bash
docker [OPTIONS] COMMAND [ARG...]
```

A self-sufficient runtime for containers.

---

## 🚀 Common Commands

| Command          | Description                                  |
| ---------------- | -------------------------------------------- |
| `docker run`     | Create and run a new container from an image |
| `docker exec`    | Execute a command inside a running container |
| `docker ps`      | List running containers                      |
| `docker build`   | Build an image from a Dockerfile             |
| `docker pull`    | Download an image from a registry            |
| `docker push`    | Upload an image to a registry                |
| `docker images`  | List images on the host                      |
| `docker login`   | Authenticate to a registry                   |
| `docker logout`  | Log out from a registry                      |
| `docker search`  | Search Docker Hub for images                 |
| `docker version` | Show Docker version information              |
| `docker info`    | Display detailed system information          |

---

## ⚙️ Management Commands

| Command            | Description                                   |
| ------------------ | --------------------------------------------- |
| `docker builder`   | Manage builds                                 |
| `docker container` | Manage containers (start, stop, ls, rm, etc.) |
| `docker context`   | Manage contexts                               |
| `docker image`     | Manage images (ls, rm, prune, etc.)           |
| `docker manifest`  | Manage Docker image manifests and lists       |
| `docker network`   | Manage networks                               |
| `docker plugin`    | Manage plugins                                |
| `docker system`    | Manage Docker (prune, df, events, etc.)       |
| `docker trust`     | Manage trust on Docker images                 |
| `docker volume`    | Manage volumes                                |

---

## 🐝 Swarm & Orchestration

| Command          | Description               |
| ---------------- | ------------------------- |
| `docker swarm`   | Manage swarm              |
| `docker service` | Manage services           |
| `docker node`    | Manage swarm nodes        |
| `docker stack`   | Manage stacks of services |

---

## 🔧 Other Useful Commands

<details>
<summary>📂 Click to expand</summary>

| Command          | Description                                         |
| ---------------- | --------------------------------------------------- |
| `docker attach`  | Attach to a running container                       |
| `docker commit`  | Create a new image from a container’s changes       |
| `docker cp`      | Copy files/folders between a container and the host |
| `docker create`  | Create a new container (without starting it)        |
| `docker diff`    | Inspect changes to a container’s filesystem         |
| `docker events`  | Get real-time events from the daemon                |
| `docker export`  | Export a container’s filesystem as a tar archive    |
| `docker history` | Show history of an image                            |
| `docker import`  | Create an image from a tarball                      |
| `docker inspect` | Return low-level details on Docker objects          |
| `docker kill`    | Kill one or more running containers                 |
| `docker load`    | Load an image from a tar archive                    |
| `docker logs`    | Fetch logs of a container                           |
| `docker pause`   | Pause processes in a container                      |
| `docker port`    | Show port mappings                                  |
| `docker rename`  | Rename a container                                  |
| `docker restart` | Restart containers                                  |
| `docker rm`      | Remove one or more containers                       |
| `docker rmi`     | Remove one or more images                           |
| `docker save`    | Save an image as a tar archive                      |
| `docker start`   | Start stopped containers                            |
| `docker stats`   | Show live resource usage                            |
| `docker stop`    | Stop running containers                             |
| `docker tag`     | Tag an image                                        |
| `docker top`     | Show running processes inside a container           |
| `docker unpause` | Resume paused containers                            |
| `docker update`  | Update container configs                            |
| `docker wait`    | Wait until containers stop, then print exit codes   |

</details>

---

## 🌍 Global Options

```text
      --config string      Location of client config files (default "/root/.docker")
  -c, --context string     Name of the context to use to connect to the daemon 
                           (overrides DOCKER_HOST env var and default context set with 
                           "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal")
                           (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default: "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default: "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default: "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit
```

---

## 📦 Subcommand References

### `docker container`
```bash
docker container ls         # List containers
docker container run        # Run a new container
docker container stop       # Stop containers
docker container rm         # Remove containers
```

### `docker image`
```bash
docker image ls             # List images
docker image build          # Build from Dockerfile
docker image rm             # Remove image
docker image prune          # Remove unused images
```

### `docker volume`
```bash
docker volume ls            # List volumes
docker volume create        # Create a new volume
docker volume inspect       # Inspect volume details
docker volume rm            # Remove volume
```

### `docker network`
```bash
docker network ls           # List networks
docker network create       # Create a network
docker network inspect      # Inspect network details
docker network rm           # Remove a network
```

---

## 📖 More Help
- Official Docs: [https://docs.docker.com/go/guides/](https://docs.docker.com/go/guides/)  
- CLI Reference: [https://docs.docker.com/engine/reference/commandline/docker/](https://docs.docker.com/engine/reference/commandline/docker/)  


