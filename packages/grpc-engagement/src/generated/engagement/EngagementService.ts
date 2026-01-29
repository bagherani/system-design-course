// Original file: proto/engagement.proto

import type * as grpc from '@grpc/grpc-js'
import type { MethodDefinition } from '@grpc/proto-loader'
import type { GetLikeCountsRequest as _engagement_GetLikeCountsRequest, GetLikeCountsRequest__Output as _engagement_GetLikeCountsRequest__Output } from '../engagement/GetLikeCountsRequest.js';
import type { GetLikeCountsResponse as _engagement_GetLikeCountsResponse, GetLikeCountsResponse__Output as _engagement_GetLikeCountsResponse__Output } from '../engagement/GetLikeCountsResponse.js';

export interface EngagementServiceClient extends grpc.Client {
  GetLikeCounts(argument: _engagement_GetLikeCountsRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  GetLikeCounts(argument: _engagement_GetLikeCountsRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  GetLikeCounts(argument: _engagement_GetLikeCountsRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  GetLikeCounts(argument: _engagement_GetLikeCountsRequest, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  getLikeCounts(argument: _engagement_GetLikeCountsRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  getLikeCounts(argument: _engagement_GetLikeCountsRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  getLikeCounts(argument: _engagement_GetLikeCountsRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  getLikeCounts(argument: _engagement_GetLikeCountsRequest, callback: grpc.requestCallback<_engagement_GetLikeCountsResponse__Output>): grpc.ClientUnaryCall;
  
}

export interface EngagementServiceHandlers extends grpc.UntypedServiceImplementation {
  GetLikeCounts: grpc.handleUnaryCall<_engagement_GetLikeCountsRequest__Output, _engagement_GetLikeCountsResponse>;
  
}

export interface EngagementServiceDefinition extends grpc.ServiceDefinition {
  GetLikeCounts: MethodDefinition<_engagement_GetLikeCountsRequest, _engagement_GetLikeCountsResponse, _engagement_GetLikeCountsRequest__Output, _engagement_GetLikeCountsResponse__Output>
}
