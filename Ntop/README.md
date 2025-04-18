# Set up **NTopng** with a **ClickHouse** database

---

### **Prerequisites:**
1. **Ubuntu 22.x** (or similar Linux distributions)
2. **ClickHouse** installed and running
3. **ntopng** installed

---

### **Step 1: Install ClickHouse**

1. **Install the required dependencies:**
   ```bash
   sudo apt update
   sudo apt install -y apt-transport-https ca-certificates curl
   ```

2. **Add ClickHouse repository:**
   ```bash
   sudo curl -s https://repo.clickhouse.tech/deb/rpm/clickhouse-archive.key | sudo tee /etc/apt/trusted.gpg.d/clickhouse.asc
   sudo curl -s https://repo.clickhouse.tech/deb/stable/main/ubuntu/$(lsb_release -c | awk '{print $2}')/clickhouse-server.list | sudo tee /etc/apt/sources.list.d/clickhouse-server.list
   ```

3. **Install ClickHouse:**
   ```bash
   sudo apt update
   sudo apt install -y clickhouse-server clickhouse-client
   ```

4. **Start ClickHouse service:**
   ```bash
   sudo systemctl start clickhouse-server
   sudo systemctl enable clickhouse-server
   ```

5. **Verify installation:**
   ```bash
   clickhouse-client
   ```

---

### **Step 2: Install ntopng**

1. **Download and install ntopng:**
   ```bash
   sudo apt update
   sudo apt install -y gnupg2
   sudo curl -s https://packages.ntop.org/ntop.key | sudo apt-key add -
   sudo add-apt-repository "deb https://packages.ntop.org/apt/ubuntu/$(lsb_release -c | awk '{print $2}')/stable $(lsb_release -c | awk '{print $2}') main"
   sudo apt update
   sudo apt install -y ntopng
   ```

2. **Start ntopng:**
   ```bash
   sudo systemctl start ntopng
   sudo systemctl enable ntopng
   ```

---

### **Step 3: Install ClickHouse Adapter for ntopng**

1. **Install the ClickHouse adapter:**
   ntopng can store its data in **ClickHouse** by installing the required adapter.

   ```bash
   sudo apt install -y libntopng-clickhouse
   ```

2. **Configure ntopng to use ClickHouse**:
   You will need to modify the **ntopng configuration file** to point to the ClickHouse database.

   - Open the **ntopng configuration file**:
     ```bash
     sudo nano /etc/ntopng/ntopng.conf
     ```

   - Add or update the following parameters:
     ```bash
     --clickhouse-enabled
     --clickhouse-host=127.0.0.1  # or your ClickHouse server IP
     --clickhouse-port=9000
     --clickhouse-database=ntopng
     --clickhouse-user=default  # ClickHouse username
     --clickhouse-password=your_password  # ClickHouse password
     ```

3. **Create a ClickHouse database for ntopng:**
   Log in to the ClickHouse client and create a database:
   ```bash
   clickhouse-client
   CREATE DATABASE IF NOT EXISTS ntopng;
   ```

---

### **Step 4: Restart ntopng and Verify Configuration**

1. **Restart ntopng to apply the changes:**
   ```bash
   sudo systemctl restart ntopng
   ```

2. **Verify that ntopng is using ClickHouse**:
   You should now see that ntopng is sending data to ClickHouse. You can check the ntopng dashboard to see if data is flowing.

---

### **Step 5: Access ntopng Web Interface**

- By default, ntopng listens on port **3000** for the web interface.
  Open a browser and go to:
  ```
  http://<your_server_ip>:3000
  ```
  Use the default login (`admin` / `admin`) or the credentials you have set.

---

### **Optional: Configuring Data Retention**

To optimize performance, you can configure **ClickHouse** to retain data for a certain period and periodically clean up old data. This can be done through ClickHouse's **TTL (Time-to-Live)** features.

---

Let me know if you need further assistance with any of these steps!
