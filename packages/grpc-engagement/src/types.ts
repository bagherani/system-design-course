/**
 * Re-exports of TypeScript types generated from engagement.proto.
 * Run `pnpm run generate` after changing the proto file to regenerate src/generated/.
 */

export type {
  GetLikeCountsRequest,
  GetLikeCountsRequest__Output,
} from "./generated/engagement/GetLikeCountsRequest.js";
export type {
  GetLikeCountsResponse,
  GetLikeCountsResponse__Output,
  _engagement_GetLikeCountsResponse_PostLikes as PostLikes,
  _engagement_GetLikeCountsResponse_PostLikes__Output as PostLikesOutput,
} from "./generated/engagement/GetLikeCountsResponse.js";
export type {
  EngagementServiceClient,
  EngagementServiceDefinition,
  EngagementServiceHandlers,
} from "./generated/engagement/EngagementService.js";
export type { ProtoGrpcType } from "./generated/engagement.js";

import type * as grpc from "@grpc/grpc-js";
import type { GetLikeCountsResponse__Output } from "./generated/engagement/GetLikeCountsResponse.js";

/** Callback for unary RPC responses (alias for requestCallback) */
export type GetLikeCountsCallback = grpc.requestCallback<GetLikeCountsResponse__Output>;
