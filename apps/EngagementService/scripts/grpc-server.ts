import * as grpc from "@grpc/grpc-js";
import {
  engagementServiceDefinition,
  type GetLikeCountsHandler,
  type GetLikeCountsResponse,
} from "@repo/grpc-engagement";

const PORT = process.env.ENGAGEMENT_GRPC_PORT ?? "50051";

const GetLikeCounts: GetLikeCountsHandler = (call, callback) => {
  const postIds = call.request.post_ids ?? [];
  const response: GetLikeCountsResponse = {
    posts: postIds.map((post_id) => ({ post_id, count: 0 })),
  };
  callback(null, response);
};

function main() {
  const server = new grpc.Server();
  server.addService(engagementServiceDefinition, {
    GetLikeCounts,
  });
  server.bindAsync(
    `0.0.0.0:${PORT}`,
    grpc.ServerCredentials.createInsecure(),
    (err, boundPort) => {
      if (err) {
        console.error("gRPC server bind error:", err);
        process.exit(1);
      }
      console.log(`Engagement gRPC server listening on 0.0.0.0:${boundPort}`);
    }
  );
}

main();
