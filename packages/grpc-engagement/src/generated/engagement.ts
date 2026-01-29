import type * as grpc from '@grpc/grpc-js';
import type { MessageTypeDefinition } from '@grpc/proto-loader';

import type { EngagementServiceClient as _engagement_EngagementServiceClient, EngagementServiceDefinition as _engagement_EngagementServiceDefinition } from './engagement/EngagementService.js';

type SubtypeConstructor<Constructor extends new (...args: any) => any, Subtype> = {
  new(...args: ConstructorParameters<Constructor>): Subtype;
};

export interface ProtoGrpcType {
  engagement: {
    EngagementService: SubtypeConstructor<typeof grpc.Client, _engagement_EngagementServiceClient> & { service: _engagement_EngagementServiceDefinition }
    GetLikeCountsRequest: MessageTypeDefinition
    GetLikeCountsResponse: MessageTypeDefinition
  }
}

