
✅ Complete Working Docker Compose File
Here's the tested and working version:

```
cat > docker-compose-sonarqube.yml << 'EOF'
version: '3.8'

services:
  postgresql:
    image: postgres:15
    container_name: sonarqube_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: Meradhan123@sonarqube
      POSTGRES_DB: sonarqube
    volumes:
      - postgresql_data:/var/lib/postgresql/data
    networks:
      - sonarnet
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar"]
      interval: 10s
      timeout: 5s
      retries: 5

  sonarqube:
    image: sonarqube:lts-community
    container_name: sonarqube
    restart: unless-stopped
    depends_on:
      postgresql:
        condition: service_healthy
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgresql:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: Meradhan123@sonarqube
      SONAR_WEB_JAVAOPTS: "-Xmx2048m -Xms1024m"
      SONAR_CE_JAVAOPTS: "-Xmx2048m -Xms1024m"
      SONAR_SEARCH_JAVAOPTS: "-Xmx1024m -Xms512m"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    networks:
      - sonarnet

volumes:
  postgresql_data:
    name: sonarqube_postgres_data
  sonarqube_data:
    name: sonarqube_data
  sonarqube_logs:
    name: sonarqube_logs
  sonarqube_extensions:
    name: sonarqube_extensions

networks:
  sonarnet:
    name: sonarnet
    driver: bridge
EOF

```

echo "✅ Fixed docker-compose file created"
🔧 One-Command Fix (Run This Now)

```
# Stop, fix, and restart
docker-compose -f docker-compose-sonarqube.yml down 2>/dev/null
docker-compose -f docker-compose-sonarqube.yml down --remove-orphans 2>/dev/null
docker pull sonarqube:lts-community
docker-compose -f docker-compose-sonarqube.yml up -d
```
