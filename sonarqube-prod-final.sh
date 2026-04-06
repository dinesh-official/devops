#!/bin/bash

set -e

echo "🚀 Updating system..."
sudo apt update -y

echo "🐳 Installing dependencies..."
sudo apt install -y docker.io docker-compose nginx

sudo systemctl enable docker
sudo systemctl start docker

echo "⚙️ Setting kernel parameters..."
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536

sudo sed -i '/vm.max_map_count/d' /etc/sysctl.conf
sudo sed -i '/fs.file-max/d' /etc/sysctl.conf

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=65536" | sudo tee -a /etc/sysctl.conf

echo "📦 Creating Docker network (safe)..."
sudo docker network inspect sonarnet >/dev/null 2>&1 || sudo docker network create sonarnet

echo "📦 Creating docker-compose.yml..."

cat <<EOF > docker-compose.yml
version: "3.8"

services:
  postgres:
    image: postgres:13
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

  sonarqube:
    image: sonarqube:lts-community
    container_name: sonarqube
    restart: always
    depends_on:
      - postgres
    networks:
      - sonarnet
    ports:
      - "127.0.0.1:9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: StrongPass123!
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions

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

echo "🌐 Configuring Nginx..."

sudo bash -c 'cat > /etc/nginx/sites-available/sonarqube <<NGINX
server {
    listen 80 default_server;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:9000;

        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
NGINX'

sudo ln -sf /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/

echo "🔍 Testing Nginx..."
sudo nginx -t

echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

echo "🎉 SONARQUBE FULL PRODUCTION SETUP COMPLETE!"
echo ""
echo "👉 Access:"
echo "http://<YOUR-EC2-PUBLIC-IP>"
echo ""
echo "🔑 Default login:"
echo "admin / admin"
echo ""
echo "⚠️ NEXT STEPS:"
echo "- Change admin password"
echo "- Generate token"
echo "- Add GitHub Actions"
echo "- Later enable HTTPS"
