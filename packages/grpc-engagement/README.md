# @repo/grpc-engagement

Shared gRPC contract between FeedService and EngagementService.

- **Proto:** `proto/engagement.proto` – defines `EngagementService.GetLikeCounts`
- **Types:** TypeScript types for requests/responses and client/server usage (generated from proto)
- **Helpers:** `createEngagementClient()`, `engagementServiceDefinition` for server

## Regenerating types after proto changes

When you change `proto/engagement.proto`, regenerate the TypeScript types and fix imports:

```bash
pnpm run generate
```

This runs `proto-loader-gen-types` (from `@grpc/proto-loader`) to write `src/generated/`, then a small script to add `.js` extensions to relative imports for NodeNext. You do **not** need to edit `index.ts` or `types.ts` by hand—they import and re-export from the generated files.

Used by:

- **feed-service** – gRPC client to fetch like counts
- **engagement-service** – gRPC server implementing the service

## Usage

**Client (e.g. FeedService):**

```ts
import { createEngagementClient } from "@repo/grpc-engagement";
import * as grpc from "@grpc/grpc-js";

const client = createEngagementClient("localhost:50051");
client.getLikeCounts(
  { post_ids: ["id1", "id2"] },
  new grpc.Metadata(),
  (err, response) => { /* ... */ }
);
```

**Server (e.g. EngagementService):**

```ts
import * as grpc from "@grpc/grpc-js";
import { engagementServiceDefinition } from "@repo/grpc-engagement";

const server = new grpc.Server();
server.addService(engagementServiceDefinition, {
  GetLikeCounts: (call, callback) => {
    callback(null, { posts: call.request.post_ids.map(id => ({ post_id: id, count: 0 })) });
  },
});
server.bindAsync("0.0.0.0:50051", grpc.ServerCredentials.createInsecure(), () => {});
```
