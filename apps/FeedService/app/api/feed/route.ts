import * as grpc from "@grpc/grpc-js";
import { NextResponse } from "next/server";
import {
  createEngagementClient,
  type GetLikeCountsResponse,
} from "@repo/grpc-engagement";

const ENGAGEMENT_GRPC_ADDRESS =
  process.env.ENGAGEMENT_GRPC_ADDRESS ?? "localhost:50051";

function getLikeCounts(
  client: ReturnType<typeof createEngagementClient>,
  postIds: string[]
): Promise<GetLikeCountsResponse> {
  return new Promise((resolve, reject) => {
    client.getLikeCounts(
      { post_ids: postIds },
      new grpc.Metadata(),
      (err, response) => {
        if (err) reject(err);
        else resolve(response ?? { posts: [] });
      }
    );
  });
}

export async function GET() {
  const client = createEngagementClient(ENGAGEMENT_GRPC_ADDRESS);
  try {
    const response = await getLikeCounts(client, ["post-1", "post-2"]);
    return NextResponse.json({ engagement: response });
  } catch (err) {
    console.error("gRPC call failed:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "gRPC call failed" },
      { status: 502 }
    );
  }
}
