# Feed Service

Next.js app that builds the feed and enriches it with engagement data from EngagementService via gRPC.

- **HTTP port:** 3003
- **gRPC client:** calls `ENGAGEMENT_GRPC_ADDRESS` (default `localhost:50051`)

## APIs

- `GET /health` – health check
- `GET /api/feed` – minimal feed API that fetches like counts from EngagementService over gRPC

## Run

```bash
# From repo root (start EngagementService gRPC server first, then)
pnpm --filter feed-service dev
```

For a full flow, start EngagementService first (it runs both Next.js and the gRPC server), then start FeedService and call `GET http://localhost:3003/api/feed`.
