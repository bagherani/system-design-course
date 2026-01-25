# Infrastructure as Code - LikeService Load Balancer

This directory contains Terraform configuration to deploy the LikeService application with nginx as a load balancer.

## Architecture

- **2 instances** of LikeService running on ports 3001 and 3002
- **1 nginx container** acting as a load balancer on port 8080
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

#### Windows

```powershell
choco install terraform
```

**Verify Installation:**
```powershell
terraform version
```

### Verifying Your Setup

After installing both Docker and Terraform, verify everything is working:

```bash
# Check Docker
docker --version
docker ps

# Check Terraform
terraform version

# Ensure Docker is running
docker info
```

If Docker is not running, start Docker Desktop and wait for it to fully start before proceeding.

## Usage

### Initialize Terraform

```bash
cd infrastructure
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
1. Build the LikeService Docker image
2. Create a Docker network
3. Start 2 instances of LikeService (ports 3001 and 3002)
4. Start nginx load balancer (port 8080)

### Access the application

- **Through load balancer**: http://localhost:8080
- **Direct access to instance 1**: http://localhost:3001
- **Direct access to instance 2**: http://localhost:3002

### Destroy the infrastructure

```bash
terraform destroy
```

## Configuration

You can customize the ports by creating a `terraform.tfvars` file:

```hcl
nginx_port          = 8080
like_service_port_1 = 3001
like_service_port_2 = 3002
```

## Load Balancing

The nginx configuration uses **round-robin** load balancing by default, distributing requests evenly across both LikeService instances.

## Health Checks

- Nginx health check endpoint: http://localhost:8080/health
