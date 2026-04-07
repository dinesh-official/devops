#!/bin/bash
set -e

# ─────────────────────────────────────────
# SonarQube 10.x — Full Production Setup
# ─────────────────────────────────────────

echo "🚀 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🐳 Installing dependencies..."
sudo apt install -y docker.io docker-compose nginx curl
sudo systemctl enable docker
sudo systemctl start docker

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

echo "📦 Creating Docker network (safe)..."
sudo docker network inspect sonarnet >/dev/null 2>&1 \
  || sudo docker network create sonarnet

# ── Backup existing volumes if upgrading ──
if sudo docker ps -a --format '{{.Names}}' | grep -q "sonarqube"; then
  echo "📦 Existing SonarQube detected — backing up before upgrade..."
  BACKUP_DIR="$HOME/sonarqube-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  sudo docker-compose down 2>/dev/null || true
  sudo docker run --rm \
    -v sonarqube_data:/data \
    -v "$BACKUP_DIR":/backup \
    alpine tar czf /backup/sonarqube_data.tar.gz -C /data . && \
    echo "✅ Backup saved to $BACKUP_DIR"
fi

echo "📦 Pulling latest images..."
sudo docker pull sonarqube:10-community
sudo docker pull postgres:15

echo "📦 Writing docker-compose.yml..."
cat <<EOF > docker-compose.yml
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
      - "127.0.0.1:9000:9000"
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
EOF

echo "▶️ Starting containers..."
sudo docker-compose up -d

echo "🌐 Cleaning old Nginx configs..."
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/sonarqube
sudo rm -f /etc/nginx/sites-available/sonarqube

echo "🌐 Configuring Nginx reverse proxy..."
sudo bash -c 'cat > /etc/nginx/sites-available/sonarqube <<NGINX
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
        proxy_read_timeout 300s;
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
echo "⏳ Waiting for SonarQube to boot (this takes ~2 minutes)..."
for i in $(seq 1 24); do
  STATUS=$(curl -sf http://127.0.0.1:9000/api/system/status 2>/dev/null | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || echo "waiting")
  echo "  [$i/24] Status: $STATUS"
  if [ "$STATUS" = "UP" ]; then
    echo "✅ SonarQube is UP!"
    break
  fi
  sleep 10
done

echo ""
echo "🎉 ═══════════════════════════════════════════"
echo "   SONARQUBE 10.x PRODUCTION SETUP COMPLETE"
echo "═══════════════════════════════════════════════"
echo ""
echo "👉 Access:        http://<YOUR-EC2-PUBLIC-IP>"
echo "🔑 Login:         admin / admin"
echo "📊 Version:       SonarQube 10-community (latest)"
echo "🗄️  Database:      PostgreSQL 15"
echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "  1. Change admin password immediately"
echo "  2. Go to: My Account → Security → Generate Token"
echo "  3. Update SONAR_TOKEN in GitHub Actions secrets"
echo "  4. Set up HTTPS with Let's Encrypt (certbot)"
echo ""
echo "📋 Useful commands:"
echo "  sudo docker-compose logs -f sonarqube   # live logs"
echo "  sudo docker-compose ps                  # container status"
echo "  sudo docker-compose down                # stop all"
echo "  sudo docker-compose up -d               # start all"
