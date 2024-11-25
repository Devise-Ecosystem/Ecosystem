#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Load environment variables
source .env

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo -e "${RED}Error: certbot is required but not installed.${NC}"
    echo "Install with: apt-get install certbot python3-certbot-nginx"
    exit 1
fi

# Get SSL certificates for both domains
echo "Getting SSL certificates..."

for domain in "auth.$BASE_DOMAIN" "cloud.$BASE_DOMAIN"; do
    echo "Setting up SSL for $domain"
    certbot certonly --standalone \
        -d "$domain" \
        --agree-tos \
        --non-interactive \
        --email "admin@$BASE_DOMAIN"
    
    # Create directory if it doesn't exist
    mkdir -p "configs/nginx/ssl/live/$domain"
    
    # Copy certificates to nginx ssl directory
    cp "/etc/letsencrypt/live/$domain/fullchain.pem" "configs/nginx/ssl/live/$domain/"
    cp "/etc/letsencrypt/live/$domain/privkey.pem" "configs/nginx/ssl/live/$domain/"
done

echo -e "${GREEN}SSL certificates have been set up successfully${NC}"