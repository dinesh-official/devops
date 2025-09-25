# 🐳 Docker Commands Cheat Sheet

---

## 📦 Basic Docker Commands

```bash
docker ps             # Show only running containers
docker ps -a          # Show all containers (running + stopped)
docker images         # List all Docker images
docker search <name>  # Search images in Docker Hub
docker pull <name>    # Download image from Docker Hub
docker inspect <name> # Detailed info of a container/image
docker commit <container> <image>  # Create a new image from a container
docker save -o <file>.tar <image> # Export image to file
docker load -i <file>.tar         # Import image from file
```

---

## 🏷️ Common Docker Flags

| Flag     | Description                                          |
| -------- | ---------------------------------------------------- |
| `-p`     | Port mapping → `-p host_port:container_port`         |
| `-v`     | Volume → `-v /host:/container`                       |
| `-d`     | Detached mode (run in background)                    |
| `-it`    | Interactive terminal (`-i` for STDIN + `-t` for TTY) |
| `--name` | Custom container name                                |
| `-f`     | Force (used with `rm`, `rmi`, etc.)                  |
| `-a`     | Show all (commonly used with `ps`, `logs`)           |
| `-o`     | Output format (used with `inspect`, `save`, etc.)    |
| `-i`     | STDIN (input stream)                                 |

---

### 🔁 Example: Run Container with Port, Volume, Name

```bash
docker run -itd -p 8080:80 -v /data:/app/data --name my_container ubuntu
```

---

## 🌐 How to Share Docker Images

### ✅ With Internet (Docker Hub)

```bash
# Step 1: Tag your image
docker tag myimage:v1 dinesh/myimage:v1

# Step 2: Login to Docker Hub
docker login

# Step 3: Push image
docker push dinesh/myimage:v1

# Step 4: (Optional) Pull from another machine
docker pull dinesh/myimage:v1
```

---

### ❌ Without Internet (Offline Transfer)

```bash
# Step 1: Save image to tar file
docker save -o my_image_backup.tar myimage:v1

# Step 2: Transfer to target machine
scp my_image_backup.tar user@target:/path/

# Step 3: Load image on the new machine
docker load -i my_image_backup.tar

# Step 4: Verify
docker images
```

---

## 💾 Docker Storage Types

| Type           | Description                            |
| -------------- | -------------------------------------- |
| **Bind Mount** | Maps a host folder directly (manual)   |
| **Volumes**    | Docker-managed storage (recommended)   |
| **tmpfs**      | In-memory storage (lost after restart) |

### 🔹 Examples

```bash
# Bind Mount
docker run -v /host/data:/container/data ubuntu

# Named Volume
docker volume create myvol
docker run -v myvol:/data ubuntu

# tmpfs Volume (in-memory only, lost after container stops)
docker run --tmpfs /app/tmp:rw,size=64m ubuntu
```
## 📷 Reference Image

![Docker Storage](https://github.com/user-attachments/assets/f01ab261-a2a8-4e03-af29-a46d2037ffe9)


---

## 🧠 Docker Interview Tips

### 🔎 Q: How to find OS of an EC2 instance without logging in?

```bash
cat /etc/os-release
```

### 🏗️ Q: Docker Architecture (Basic Overview)

1. **Docker Client**: CLI tool (`docker`) that sends commands.
2. **Docker Daemon**: Background service that manages images and containers.
3. **Docker Images**: Read-only templates for containers.
4. **Docker Containers**: Lightweight, runnable instance of images.
5. **Docker Registries**: Repositories for images (e.g., Docker Hub).
6. **Docker Storage & Network**: Volumes, mounts, bridges, overlays.

