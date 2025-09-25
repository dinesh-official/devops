# 🐳 Dockerfile Commands Cheat Sheet

> Use this as a quick reference to Dockerfile instructions when building custom Docker images.

---

## 🧱 Basic Dockerfile Commands

| Command       | Description                                                            | Example |
|---------------|------------------------------------------------------------------------|---------|
| `FROM`        | Sets the base image                                                    | `FROM ubuntu:20.04` |
| `LABEL`       | Adds metadata to an image                                              | `LABEL maintainer="you@example.com"` |
| `RUN`         | Executes a command in the shell during build                           | `RUN apt-get update && apt-get install -y nano` |
| `CMD`         | Sets default command to run when container starts                      | `CMD ["nginx", "-g", "daemon off;"]` |
| `ENTRYPOINT`  | Configures a container to run as an executable                         | `ENTRYPOINT ["python3"]` |
| `COPY`        | Copies files from host to container                                    | `COPY . /app` |
| `ADD`         | Like `COPY` but supports remote URLs and unpacking archives            | `ADD https://example.com/app.tar.gz /app/` |
| `ENV`         | Sets environment variables                                              | `ENV PORT=3000` |
| `EXPOSE`      | Documents which port the container listens on                          | `EXPOSE 80` |
| `WORKDIR`     | Sets working directory for RUN, CMD, ENTRYPOINT                        | `WORKDIR /app` |
| `VOLUME`      | Creates mount point for a volume                                       | `VOLUME /data` |
| `USER`        | Sets user for running container commands                               | `USER node` |
| `ARG`         | Defines build-time variables                                           | `ARG VERSION=1.0` |
| `HEALTHCHECK` | Defines how to check container health                                  | `HEALTHCHECK CMD curl --fail http://localhost || exit 1` |
| `SHELL`       | Changes the default shell used for `RUN` commands                      | `SHELL ["/bin/bash", "-c"]` |
| `ONBUILD`     | Adds a trigger instruction to be executed when image is used as base   | `ONBUILD COPY . /app` |
| `STOPSIGNAL`  | Sets system call signal to stop the container                          | `STOPSIGNAL SIGTERM` |

---

## 📌 Example: Simple Dockerfile

```Dockerfile
FROM ubuntu:20.04

LABEL maintainer="admin@example.com"

RUN apt-get update && apt-get install -y nginx nano

COPY ./index.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

## ⚙️ Build Docker Image

```bash
docker build -t my-nginx-image:v1 .
```


