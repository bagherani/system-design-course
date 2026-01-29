# gRPC Demo – FeedService & EngagementService (Docker)

Terraform config to run **FeedService** and **EngagementService** in Docker on your machine. FeedService calls EngagementService over gRPC.

## Architecture

- **EngagementService** container: Next.js on port 3004 (HTTP), gRPC on port 50051
- **FeedService** container: Next.js on port 3003 (HTTP), calls EngagementService at `engagement-service:50051` over the Docker network
- One Docker network so containers resolve each other by name

## Prerequisites

1. **Docker** installed and running
2. **Terraform** >= 1.0
3. **pnpm** (monorepo package manager)

## Usage

### Init and plan

```bash
cd infrastructure/grpc-demo
terraform init
terraform plan
```

### Apply

```bash
terraform apply
```

This will:

1. Build the FeedService Docker image (app is built inside the Dockerfile)
2. Build the EngagementService Docker image (app is built inside the Dockerfile)
3. Create the Docker network
4. Start EngagementService (HTTP + gRPC)
5. Start FeedService (uses gRPC to call EngagementService)

### Endpoints

- **FeedService (calls Engagement via gRPC):** http://localhost:3003  
  - e.g. http://localhost:3003/api/feed
- **EngagementService HTTP:** http://localhost:3004  
  - e.g. http://localhost:3004/health
- **EngagementService gRPC (from host):** localhost:50051

### Destroy

```bash
terraform destroy
```

## Configuration

Optional `terraform.tfvars`:

```hcl
feed_service_port         = 3003
engagement_http_port      = 3004
engagement_grpc_port      = 50051
feed_service_image_tag    = "1.0.0"
engagement_service_image_tag = "1.0.0"
```

## Updating the apps

After code changes:

```bash
cd infrastructure/grpc-demo
terraform apply
```

Both services are built inside their Dockerfiles; no local pre-build step is required.
