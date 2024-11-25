#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "=== Self-Hosted Suite Setup ==="
echo "Setting up Keycloak and Nextcloud..."

# Check for required commands
for cmd in docker docker-compose openssl; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}Error: $cmd is required but not installed.${NC}"
        exit 1
    fi
done

# Create required directories
mkdir -p configs/nginx/{conf.d,ssl}
mkdir -p services/{keycloak,nextcloud}/config

# Generate .env if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    read -p "Enter your domain (e.g., example.com): " DOMAIN
    
    # Generate random passwords
    POSTGRES_PASSWORD=$(openssl rand -base64 32)
    KEYCLOAK_PASSWORD=$(openssl rand -base64 32)
    NEXTCLOUD_PASSWORD=$(openssl rand -base64 32)
    
    cat > .env << EOF
POSTGRES_USER=admin
POSTGRES_PASSWORD=$POSTGRES_PASSWORD

KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_PASSWORD
KEYCLOAK_DOMAIN=auth.$DOMAIN

NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=$NEXTCLOUD_PASSWORD
NEXTCLOUD_DOMAIN=cloud.$DOMAIN

BASE_DOMAIN=$DOMAIN
EOF
    echo -e "${GREEN}Created .env file with secure passwords${NC}"
fi

# Generate Nginx configs
cat > configs/nginx/conf.d/keycloak.conf << EOF
server {
    listen 80;
    server_name auth.$DOMAIN;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name auth.$DOMAIN;

    ssl_certificate /etc/nginx/ssl/live/auth.$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/auth.$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://keycloak:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

cat > configs/nginx/conf.d/nextcloud.conf << EOF
server {
    listen 80;
    server_name cloud.$DOMAIN;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name cloud.$DOMAIN;

    ssl_certificate /etc/nginx/ssl/live/cloud.$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/cloud.$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://nextcloud:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

echo -e "${GREEN}Generated Nginx configurations${NC}"

# Setup SSL certificates
./scripts/ssl-setup.sh

echo -e "${GREEN}Setup complete!${NC}"
echo "Next steps:"
echo "1. Review the .env file and modify if needed"
echo "2. Start the services: docker-compose up -d"
echo "3. Access Keycloak at: https://auth.$DOMAIN"
echo "4. Access Nextcloud at: https://cloud.$DOMAIN"