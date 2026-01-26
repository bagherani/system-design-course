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

**Important:** Before running `terraform apply`, you must manually build the LikeService application first:

```bash
# From the monorepo root directory
pnpm build --filter=like-service
```

Then apply the Terraform configuration:

```bash
terraform apply
```

This will:

1. Build the LikeService Docker image (requires pre-built `.next/standalone` directory)
2. Create a Docker network
3. Start 2 instances of LikeService (ports 3001 and 3002)
4. Start nginx load balancer (port 3003)

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

After making changes to `apps/LikeService/`, rebuild and redeploy:

**Step 1: Build the LikeService application**
```bash
# From the monorepo root directory
pnpm build --filter=like-service
```

**Step 2: Apply Terraform configuration**
```bash
cd infrastructure/horizontal-scaling
terraform apply
```

**What happens:**
- Terraform will rebuild the Docker image using `apps/LikeService/Dockerfile`
- The Dockerfile copies the pre-built `.next/standalone` directory from your local build
- The new image will be built from your updated source code
- Containers will be recreated with the new image

**Note:** If Terraform doesn't detect your source code changes, force a rebuild by updating the image tag in `variables.tf` or `terraform.tfvars`:

```hcl
like_service_image_tag = "v1.1.0"  # Change this to trigger rebuild
```

