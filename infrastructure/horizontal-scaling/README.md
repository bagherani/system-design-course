# Infrastructure as Code - LikeService Load Balancer

This directory contains Terraform configuration to deploy the LikeService application with nginx as a load balancer.

## Architecture

- **2 instances** of LikeService running on ports 3001 and 3002
- **1 nginx container** acting as a load balancer on port 3003
- All containers connected via a Docker network

## Prerequisites

1. **Docker** installed and running
2. **Terraform** installed (>= 1.0)

## Installation

### Installing Docker

#### macOS

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop
brew install --cask docker

# Start Docker Desktop (or open it from Applications)
open -a Docker
```

**Verify Installation:**

```bash
docker --version
docker ps
```

#### Linux

**Ubuntu/Debian:**

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group (optional, to run docker without sudo)
sudo usermod -aG docker $USER
```

**Fedora/RHEL/CentOS:**

```bash
# Install prerequisites
sudo dnf install -y dnf-plugins-core

# Add Docker repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker Engine
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group (optional, to run docker without sudo)
sudo usermod -aG docker $USER
```

#### Windows

```powershell
# Install Chocolatey if you don't have it
# Run PowerShell as Administrator and execute:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Docker Desktop
choco install docker-desktop
```

**Verify Installation:**

```powershell
docker --version
docker ps
```

**Note:** On Windows, you may need to enable WSL 2 (Windows Subsystem for Linux) if prompted. Docker Desktop will guide you through this process.

### Installing Terraform

#### macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Verify Installation:**

```bash
terraform version
```

#### Linux

**Using package manager (Ubuntu/Debian):**

```bash
# Install prerequisites
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt-get update && sudo apt-get install terraform
```

**Using package manager (Fedora/RHEL/CentOS):**

```bash
# Install prerequisites
sudo dnf install -y dnf-plugins-core

# Add HashiCorp repository
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

# Install Terraform
sudo dnf install -y terraform
```

**Using direct download (any Linux distribution):**

```bash
# Download latest version (check https://www.terraform.io/downloads for latest)
TERRAFORM_VERSION="1.6.0"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip and install
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
```

#### Windows

```powershell
choco install terraform
```

## Usage

### Initialize Terraform

```bash
cd infrastructure/horizontal-scaling
terraform init
```

### Plan the deployment

```bash
terraform plan
```

### Apply the configuration

```bash
terraform apply
```

This will:

1. **Build the LikeService application** (Terraform runs `pnpm build --filter=like-service` as a prerequisite so the Dockerfile has a pre-built `.next/standalone`)
2. Build the LikeService Docker image
3. Create a Docker network
4. Start 2 instances of LikeService (ports 3001 and 3002)
5. Start nginx load balancer (port 3003)

### Access the application

- **Through load balancer**: http://localhost:3003
- **Direct access to instance 1**: http://localhost:3001
- **Direct access to instance 2**: http://localhost:3002

### Destroy the infrastructure

```bash
terraform destroy
```

## Configuration

You can customize the ports by creating a `terraform.tfvars` file:

```hcl
nginx_port          = 3003
like_service_port_1 = 3001
like_service_port_2 = 3002
```

## Load Balancing

The nginx configuration uses **round-robin** load balancing by default, distributing requests evenly across both LikeService instances.

## Health Checks

- Nginx health check endpoint: http://localhost:3003/health

## Updating Configuration

### Updating nginx.conf

After editing `nginx.conf`, apply changes:

**Option 1: Reload nginx (no downtime)**
```bash
docker exec nginx-load-balancer nginx -s reload
```

**Option 2: Recreate container with Terraform**
```bash
cd infrastructure/horizontal-scaling
terraform apply
```

### Updating LikeService Source Code

After making changes to `apps/LikeService/`, redeploy:

```bash
cd infrastructure/horizontal-scaling
terraform apply
```

**What happens:**
- Terraform runs the build step (`pnpm build --filter=like-service`) so the app is built before the Docker image
- The Docker image is built using the new `.next/standalone` output
- Containers are recreated with the new image

**Note:** The build runs on every `terraform apply`. To force a rebuild without other changes, run `terraform apply` again (the build step uses a timestamp trigger).

