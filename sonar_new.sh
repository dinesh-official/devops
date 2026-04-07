#!/bin/bash
set -e

echo "🚀 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🐳 Removing old docker-compose v1 if present..."
sudo apt remove -y docker-compose 2>/dev/null || true

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
echo "fs.file-max=131072"      | sudo tee -a /etc/sysctl.conf

echo "⚙️ Setting ulimits..."
sudo sed -i '/sonarqube/d' /etc/security/limits.conf
cat <<EOF | sudo tee -a /etc/security/limits.conf
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
EOF

echo "🧹 Cleaning up old containers and volumes..."
sudo docker stop sonarqube sonarqube-db 2>/dev/null || true
sudo docker rm   sonarqube sonarqube-db 2>/dev/null || true
sudo docker volume rm ubuntu_postgres_data \
                       ubuntu_sonarqube_data \
                       ubuntu_sonarqube_logs \
                       ubuntu_sonarqube_extensions 2>/dev/null || true
sudo docker network rm sonarnet        2>/dev/null || true
sudo docker network rm ubuntu_sonarnet 2>/dev/null || true

echo "📦 Creating Docker network..."
sudo docker network create sonarnet

echo "📦 Pulling latest images..."
sudo docker pull sonarqube:10-community
sudo docker pull postgres:15

echo "📦 Writing docker-compose.yml..."
cat > ~/docker-compose.yml << 'COMPOSEFILE'
version: "3.8"

services:

  postgres:
    image: postgres:15
    container_name: sonarqube-db
    restart: always
    networks:
      - sonarnet
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: StrongPass123!
      POSTGRES_DB: sonarqube
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar -d sonarqube"]
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
      - "0.0.0.0:9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: StrongPass123!
      SONAR_WEB_JAVAOPTS: "-Xmx512m -Xms128m"
      SONAR_CE_JAVAOPTS: "-Xmx512m -Xms128m"
      SONAR_SEARCH_JAVAOPTS: "-Xmx512m -Xms512m"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    ulimits:
      nofile:
        soft: 131072
        hard: 131072
    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://localhost:9000/api/system/status | grep -q '\"status\":\"UP\"'"]
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
COMPOSEFILE

echo "▶️ Starting containers..."
cd ~
docker compose up -d

echo "🌐 Cleaning old Nginx configs..."
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/sonarqube
sudo rm -f /etc/nginx/sites-available/sonarqube

echo "🌐 Configuring Nginx reverse proxy..."
sudo bash -c 'cat > /etc/nginx/sites-available/sonarqube << NGINX
server {
    listen 80 default_server;
    server_name _;

    client_max_body_size 64M;

    location / {
        proxy_pass         http://127.0.0.1:9000;
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
        proxy_read_timeout    300s;
        proxy_connect_timeout 300s;
    }
}
NGINX'

sudo ln -sf /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/

echo "🔍 Testing Nginx config..."
sudo nginx -t

echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

echo ""
echo "⏳ Waiting for SonarQube to boot (takes ~2 minutes)..."
for i in $(seq 1 24); do
  STATUS=$(curl -sf http://127.0.0.1:9000/api/system/status 2>/dev/null \
    | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "starting")
  echo "  [$i/24] Status: $STATUS"
  if [ "$STATUS" = "UP" ]; then
    echo "✅ SonarQube is UP!"
    break
  fi
  sleep 10
done

PUBLIC_IP=$(curl -sf http://checkip.amazonaws.com || echo "<YOUR-EC2-PUBLIC-IP>")

echo ""
echo "🎉 ════════════════════════════════════════════"
echo "   SONARQUBE 10.x PRODUCTION SETUP COMPLETE"
echo "════════════════════════════════════════════════"
echo ""
echo "👉 Access:   http://$PUBLIC_IP"
echo "🔑 Login:    admin / admin"
echo "📦 Version:  SonarQube 10-community (active)"
echo "🗄️  DB:       PostgreSQL 15"
echo ""
echo "⚠️  NEXT STEPS:"
echo "  1. Change admin password immediately"
echo "  2. My Account → Security → Generate Token"
echo "  3. Update SONAR_TOKEN in GitHub Actions"
echo "  4. Update SONAR_HOST_URL to: http://$PUBLIC_IP"
echo ""
echo "📋 Useful commands:"
echo "  docker compose logs -f sonarqube    # live logs"
echo "  docker compose ps                   # status"
echo "  docker compose down                 # stop"
echo "  docker compose up -d                # start"
