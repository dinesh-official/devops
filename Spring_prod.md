Perfect! Let's go step-by-step to build your **Spring Boot `.jar`** into a **`.deb` package** that runs as a service on **Ubuntu**.

---

## ✅ STEP 1: Build your Spring Boot `.jar`

Make sure your `.jar` is ready.

```bash
./mvnw clean package
# or
./gradlew bootJar
```

Let's assume your output is:

```
target/hunter.jar
```

---

## ✅ STEP 2: Create the `.deb` Directory Structure

Create a working folder like `deb-pkg`:

```bash
mkdir -p hunter-deb/DEBIAN
mkdir -p hunter-deb/usr/lib/hunter
mkdir -p hunter-deb/etc/hunter
mkdir -p hunter-deb/var/log/hunter
mkdir -p hunter-deb/lib/systemd/system
```

---

## ✅ STEP 3: Add Required Files

### 🔹 1. `control` file (`hunter-deb/DEBIAN/control`)

```bash
cat <<EOF > hunter-deb/DEBIAN/control
Package: hunter
Version: 1.0.0
Section: base
Priority: optional
Architecture: all
Maintainer: Dinesh Kumar <dineshdb121careers@gmail.com>
Description: Hunter - SSH Network Alerting Service
EOF
```

### 🔹 2. Your `.jar` file

Copy your JAR:

```bash
cp target/hunter.jar hunter-deb/usr/lib/hunter/
```

### 🔹 3. Default config file (`/etc/hunter/hunter.conf`)

```bash
cp your_local_hunter.conf hunter-deb/etc/hunter/hunter.conf
```

### 🔹 4. Systemd service (`hunter-deb/lib/systemd/system/hunter.service`)

```ini
[Unit]
Description=Hunter Spring Boot Service
After=network.target

[Service]
User=hunter
WorkingDirectory=/usr/lib/hunter
ExecStart=/usr/bin/java -jar /usr/lib/hunter/hunter.jar --spring.config.location=/etc/hunter/hunter.properties
SuccessExitStatus=143
Restart=on-failure
RestartSec=5
StandardOutput=append:/var/log/hunter/hunter.log
StandardError=append:/var/log/hunter/hunter-error.log

[Install]
WantedBy=multi-user.target
```

---

## ✅ STEP 4: Add `postinst` Script (Optional but Recommended)

`hunter-deb/DEBIAN/postinst`:

```bash
#!/bin/bash

# Create hunter user if not exists
if ! id "hunter" >/dev/null 2>&1; then
    useradd --system --no-create-home --shell /usr/sbin/nologin hunter
fi

# Set permissions
chown -R hunter:hunter /usr/lib/hunter
chown -R hunter:hunter /etc/hunter
chown -R hunter:hunter /var/log/hunter

# Enable and start service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable hunter
```

Make it executable:

```bash
chmod +x hunter-deb/DEBIAN/postinst
```

---

## ✅ STEP 5: Build the `.deb` Package

```bash
dpkg-deb --build hunter-deb
mv hunter-deb.deb hunter_1.0.0_all.deb
```

---

## ✅ STEP 6: Install on Ubuntu Server

```bash
sudo dpkg -i hunter_1.0.0_all.deb
```

Check status:

```bash
sudo systemctl status hunter
```

Start if needed:

```bash
sudo systemctl start hunter
```

---

## ✅ Done!

Your Spring Boot app is now a `.deb` installable Linux service.

---

Would you like me to generate a script to automate all of this?
