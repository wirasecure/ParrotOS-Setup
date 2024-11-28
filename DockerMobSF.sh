#!/bin/bash

# Ensure script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

# Step 1: Update and Install Dependencies
echo "Updating package list and installing dependencies..."
apt update -y
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Step 2: Add Docker GPG Key and Repository
echo "Adding Docker's official GPG key and repository..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 3: Install Docker
echo "Installing Docker..."
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io || {
    echo "Failed to install Docker. Please check your setup."
    exit 1
}

# Step 4: Start Docker Service
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Step 5: Pull the MobSF Docker Image
echo "Pulling the MobSF Docker image..."
docker pull opensecurity/mobile-security-framework-mobsf:latest || {
    echo "Failed to pull the MobSF image."
    exit 1
}

# Step 6: Run MobSF Container
echo "Running the MobSF container..."
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest || {
    echo "Failed to run the MobSF container. Please ensure Docker is installed correctly."
    exit 1
}

echo "MobSF is now running on http://localhost:8000"
