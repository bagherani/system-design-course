# Redis Cluster demo

Redis Cluster with **3 master nodes** (no replicas), plus **LikeServiceWithDB** running in Docker. LikeServiceWithDB uses `@repo/cache-util` and reads Redis cluster endpoints from the `REDIS_CLUSTER_NODES` environment variable set by Terraform.

## Architecture

- **3 Redis containers** (redis-node-1, redis-node-2, redis-node-3) with `cluster-enabled yes`, forming a cluster of 3 masters
- **1 LikeServiceWithDB container** on the same Docker network, with `REDIS_CLUSTER_NODES=redis-node-1:6379,redis-node-2:6379,redis-node-3:6379`
- All services use a single Docker network

## Prerequisites

- Docker
- Terraform >= 1.0
- pnpm (for building LikeServiceWithDB)

## Quick start

```bash
cd infrastructure/redis-cluster
terraform init
terraform apply -auto-approve
```

Allow 1–2 minutes for Redis nodes to start and the cluster to be created, then for LikeServiceWithDB to build and start.

## Outputs

After apply:

- **like_service_with_db_url** – HTTP API of LikeServiceWithDB (e.g. http://localhost:3012)
- **redis_cluster_nodes** – Comma-separated list of Redis nodes (for apps on the same network)
- **redis_node1_url** … **redis_node3_url** – Host-side addresses for debugging (e.g. localhost:6379)

## Test the API

```bash
# Health
curl http://localhost:3012/health

# Get like count (no likes yet)
curl http://localhost:3012/api/like/post-123

# Like a post
curl -X POST http://localhost:3012/api/like/post-123

# Get count and isLiked
curl http://localhost:3012/api/like/post-123

# Unlike
curl -X DELETE http://localhost:3012/api/like/post-123
```

## Configuration

Terraform variables (with defaults):

| Variable | Description | Default |
|----------|-------------|---------|
| `redis_version` | Redis image tag | `7-alpine` |
| `redis_node1_port` … `redis_node3_port` | Host ports for Redis nodes | 6379, 6380, 6381 |
| `like_service_with_db_port` | LikeServiceWithDB HTTP port | 3012 |
| `like_service_with_db_image_tag` | LikeServiceWithDB image tag | `1.0.0` |

Example custom ports via `terraform.tfvars`:

```hcl
redis_node1_port            = 6379
redis_node2_port            = 6380
redis_node3_port            = 6381
like_service_with_db_port   = 3012
```

## cache-util and environment variables

The `@repo/cache-util` package builds the Redis Cluster client from:

- **REDIS_CLUSTER_NODES** – Comma-separated `host:port` list (e.g. `redis-node-1:6379,redis-node-2:6379,...`). Set by Terraform for the LikeServiceWithDB container. For local dev without Docker, set this or leave unset to use `localhost:6379`, `localhost:6380`, `localhost:6381`.
- **REDIS_CLUSTER_NAT_MAP** (optional) – JSON map of internal addresses to external `host:port` for NAT environments.

## Destroy

```bash
terraform destroy -auto-approve
```

This removes the Redis containers, LikeServiceWithDB, volumes, and the Docker network.
