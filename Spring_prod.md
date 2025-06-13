To run a **Spring Boot application** on **Ubuntu**, follow these clean, production-friendly steps. There are **two main approaches**:

---

## ✅ Option 1: Run Directly Using Java

### 1. **Install Java (e.g., JDK 17 or newer)**

```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

✅ Verify:

```bash
java -version
```

---

### 2. **Copy Your Spring Boot JAR to Ubuntu**

Let's assume your app is called `hunter.jar`.

```bash
scp hunter.jar user@your-server-ip:/home/user/
```

---

### 3. **Run the JAR**

```bash
java -jar hunter.jar
```

To specify external config:

```bash
java -jar hunter.jar --spring.config.location=file:/etc/hunter/application.properties
```

To run in background:

```bash
nohup java -jar hunter.jar > hunter.log 2>&1 &
```

---

## ✅ Option 2: Set It Up as a Linux Service (systemd)

This is **production recommended**.

---

### 📁 Recommended Directory Structure

| File            | Location                             |
| --------------- | ------------------------------------ |
| JAR file        | `/usr/share/hunter/hunter.jar`       |
| Config file     | `/etc/hunter/application.properties` |
| Systemd service | `/etc/systemd/system/hunter.service` |

---

### 1. **Create user**

```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin hunter
```

---

### 2. **Copy Files**

```bash
sudo mkdir -p /usr/share/hunter /etc/hunter
sudo cp hunter.jar /usr/share/hunter/
sudo cp application.properties /etc/hunter/
sudo chown -R hunter:hunter /usr/share/hunter /etc/hunter
```

---

### 3. **Create `hunter.service`**

```bash
sudo nano /etc/systemd/system/hunter.service
```

Paste:

```ini
[Unit]
Description=Hunter Spring Boot Application
After=network.target

[Service]
User=hunter
WorkingDirectory=/usr/share/hunter
ExecStart=/usr/bin/java -jar /usr/share/hunter/hunter.jar --spring.config.location=file:/etc/hunter/application.properties
SuccessExitStatus=143
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

### 4. **Enable & Start Service**

```bash
sudo systemctl daemon-reload
sudo systemctl enable hunter
sudo systemctl start hunter
```

✅ Check status:

```bash
sudo systemctl status hunter
```

📄 Logs:

```bash
journalctl -u hunter -f
```

---

## Bonus: Running from `.deb` Package

If you've built a `.deb` for your app:

```bash
sudo dpkg -i hunter.deb
```

Then:

```bash
sudo systemctl start hunter
```

---

Would you like help automating this with a `.deb` package that sets everything up in one go?
