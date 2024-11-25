#!/bin/bash

# Update the package database
sudo apt-get update

# Install prerequisite packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker APT repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database again
sudo apt-get update

# Install Docker
sudo apt-get install -y docker-ce

# Start Docker service
sudo systemctl start docker

# Enable Docker service to start on boot
sudo systemctl enable docker

# Verify Docker installation
docker --version

echo "Docker installation completed successfully."