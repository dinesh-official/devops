#!/bin/bash
set -e

# ============================================
# CONFIGURATION - EDIT THESE
# ============================================
DOMAIN="sonar.meradhan.co"  # Your domain
ADMIN_PASSWORD="Meradhan123@sonarqube"
# ============================================

echo "🚀 Setting up SonarQube for $DOMAIN"

# Get server IP
PUBLIC_IP=$(curl -sf http://checkip.amazonaws.com || echo "YOUR_IP")
echo "📍 Server IP: $PUBLIC_IP"
echo "📍 Domain: $DOMAIN"

echo "🚀 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🐳 Installing Docker + dependencies..."
sudo apt install -y docker.io nginx curl ca-certificates gnupg lsb-release

echo "🐳 Adding Docker official repo for Compose V2..."
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-compose-plugin

echo "✅ Docker Compose version: $(docker compose version)"

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "⚙️ Setting kernel parameters..."
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
sudo sed -i '/vm.max_map_count/d' /etc/sysctl.conf
sudo sed -i '/fs.file-max/d' /etc/sysctl.conf
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf

echo "🧹 Cleaning up old containers and volumes..."
sudo docker stop sonarqube sonarqube-db 2>/dev/null || true
sudo docker rm sonarqube sonarqube-db 2>/dev/null || true
sudo docker volume rm postgres_data sonarqube_data sonarqube_logs sonarqube_extensions 2>/dev/null || true
sudo docker network rm sonarnet 2>/dev/null || true

echo "📦 Creating Docker network..."
sudo docker network create sonarnet 2>/dev/null || true

echo "📦 Pulling latest images..."
sudo docker pull sonarqube:10-community
sudo docker pull postgres:15

echo "📦 Writing docker-compose.yml..."
cat > ~/docker-compose.yml << EOF
services:
  postgres:
    image: postgres:15
    container_name: sonarqube-db
    restart: always
    networks:
      - sonarnet
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: ${ADMIN_PASSWORD}
      POSTGRES_DB: sonar
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar -d sonar"]
      interval: 10s
      timeout: 5s
      retries: 5

  sonarqube:
    image: sonarqube:10-community
    container_name: sonarqube
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - sonarnet
    ports:
      - "127.0.0.1:9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: ${ADMIN_PASSWORD}
      SONAR_WEB_JAVAOPTS: "-Xmx2048m -Xms1024m"
      SONAR_CE_JAVAOPTS: "-Xmx2048m -Xms1024m"
      SONAR_SEARCH_JAVAOPTS: "-Xmx1024m -Xms512m"
      SONAR_ES_BOOTSTRAP_CHECKS_DISABLE: "true"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    ulimits:
      nofile:
        soft: 131072
        hard: 131072
    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://localhost:9000/api/system/status | grep -q 'UP'"]
      interval: 30s
      timeout: 10s
      retries: 10
      start_period: 120s

volumes:
  postgres_data:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:

networks:
  sonarnet:
    external: true
    name: sonarnet
EOF

echo "▶️ Starting containers..."
cd ~
docker compose up -d

echo "🌐 Configuring Nginx for domain $DOMAIN..."
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/sonarqube
sudo rm -f /etc/nginx/sites-available/sonarqube

# Create Nginx configuration for domain (HTTP only - works with Cloudflare)
sudo bash -c "cat > /etc/nginx/sites-available/sonarqube << 'NGINX'
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN} ${PUBLIC_IP} _;
    
    client_max_body_size 100M;
    
    # Logs
    access_log /var/log/nginx/sonarqube_access.log;
    error_log /var/log/nginx/sonarqube_error.log;
    
    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_read_timeout 300s;
        proxy_connect_timeout 300s;
        
        # Buffering off for better performance
        proxy_buffering off;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 \"healthy\\n\";
        add_header Content-Type text/plain;
    }
}
NGINX"

sudo ln -sf /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/

echo "🔍 Testing Nginx config..."
sudo nginx -t

echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow 80/tcp 2>/dev/null || true
sudo ufw allow 22/tcp 2>/dev/null || true
sudo ufw --force enable 2>/dev/null || true

echo ""
echo "⏳ Waiting for SonarQube to boot (takes ~2 minutes)..."
for i in $(seq 1 30); do
  STATUS=$(curl -sf http://127.0.0.1:9000/api/system/status 2>/dev/null \
    | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "starting")
  echo "  [$i/30] Status: $STATUS"
  if [ "$STATUS" = "UP" ]; then
    echo "✅ SonarQube is UP!"
    break
  fi
  sleep 10
done

# Change default admin password
echo "🔐 Changing default admin password..."
sleep 10
curl -X POST "http://127.0.0.1:9000/api/users/change_password" \
  -u admin:admin \
  -d "login=admin&previousPassword=admin&password=${ADMIN_PASSWORD}" 2>/dev/null || \
  echo "⚠️  Password change failed. Change manually at first login"

echo ""
echo "🎉 ════════════════════════════════════════════════════════════"
echo "   SONARQUBE PRODUCTION SETUP COMPLETE"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📍 Access URLs:"
echo "   IP Access:   http://$PUBLIC_IP"
echo "   Domain:      http://$DOMAIN"
echo ""
echo "🔑 Login Credentials:"
echo "   Username:    admin"
echo "   Password:    $ADMIN_PASSWORD"
echo ""
echo "📦 Version:     SonarQube 10-community"
echo "🗄️  DB:          PostgreSQL 15"
echo ""
echo "⚠️  IMPORTANT - For Domain to Work:"
echo "   You MUST configure Cloudflare DNS:"
echo "   1. Login to Cloudflare → meradhan.co"
echo "   2. DNS → Records → Add/Edit:"
echo "      Type: A | Name: sonar | Value: $PUBLIC_IP"
echo "      Proxy status: DNS ONLY (gray cloud) ← CRITICAL!"
echo "   3. SSL/TLS → Overview → Set to 'Off' or 'Flexible'"
echo ""
echo "📋 Useful commands:"
echo "   docker compose logs -f sonarqube    # live logs"
echo "   docker compose ps                   # status"
echo "   docker compose down                 # stop"
echo "   docker compose up -d                # start"
echo "   sudo tail -f /var/log/nginx/sonarqube_access.log  # nginx logs"
echo ""
echo "✅ Test domain after Cloudflare fix:"
echo "   curl http://$DOMAIN/api/system/status"
echo ""
