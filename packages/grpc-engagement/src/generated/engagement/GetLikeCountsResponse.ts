// Original file: proto/engagement.proto


export interface _engagement_GetLikeCountsResponse_PostLikes {
  'post_id'?: (string);
  'count'?: (number);
}

export interface _engagement_GetLikeCountsResponse_PostLikes__Output {
  'post_id': (string);
  'count': (number);
}

export interface GetLikeCountsResponse {
  'posts'?: (_engagement_GetLikeCountsResponse_PostLikes)[];
}

export interface GetLikeCountsResponse__Output {
  'posts': (_engagement_GetLikeCountsResponse_PostLikes__Output)[];
}
