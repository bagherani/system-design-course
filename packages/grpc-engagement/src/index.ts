import path from "path";
import { fileURLToPath } from "url";
import * as grpc from "@grpc/grpc-js";
import * as protoLoader from "@grpc/proto-loader";

import type { ProtoGrpcType } from "./generated/engagement.js";
import type {
  EngagementServiceClient,
  EngagementServiceHandlers,
} from "./types.js";

export type {
  GetLikeCountsRequest,
  GetLikeCountsRequest__Output,
  GetLikeCountsResponse,
  GetLikeCountsResponse__Output,
  PostLikes,
  PostLikesOutput,
  GetLikeCountsCallback,
  EngagementServiceClient,
  EngagementServiceDefinition,
  EngagementServiceHandlers,
  ProtoGrpcType,
} from "./types.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROTO_PATH = path.join(__dirname, "..", "proto", "engagement.proto");

const packageDefinition = protoLoader.loadSync(PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
});

const proto = grpc.loadPackageDefinition(packageDefinition) as unknown as ProtoGrpcType;

/** Engagement gRPC service definition for registering server handlers */
export const engagementServiceDefinition =
  proto.engagement.EngagementService.service;

/** Create a gRPC client for EngagementService */
export function createEngagementClient(
  address: string,
  credentials?: grpc.ChannelCredentials
): EngagementServiceClient {
  const ClientConstructor = proto.engagement.EngagementService;
  return new ClientConstructor(
    address,
    credentials ?? grpc.credentials.createInsecure(),
    {}
  ) as EngagementServiceClient;
}

/** Server handler type for GetLikeCounts (use with EngagementServiceHandlers) */
export type GetLikeCountsHandler = EngagementServiceHandlers["GetLikeCounts"];
