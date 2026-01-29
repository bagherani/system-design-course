# Engagement Service

Next.js app that serves engagement (e.g. like counts) via gRPC and exposes a minimal HTTP API.

- **HTTP port:** 3004
- **gRPC port:** 50051 (set `ENGAGEMENT_GRPC_PORT` to override)

## APIs

- `GET /health` – health check
- **gRPC:** `EngagementService.GetLikeCounts` – returns like counts for given post IDs

## Run

```bash
# From repo root (starts both Next.js and gRPC server)
pnpm --filter engagement-service dev
```

The gRPC server runs on port 50051. FeedService uses it to fetch engagement when building the feed.
