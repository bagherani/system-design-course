import { NextRequest, NextResponse } from 'next/server';
import { redisCluster } from '@repo/cache-util';
import { getUserId } from '../../../utils/_user';

const likeKey = (postid: string) => `like:${postid}`;

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  return await getResponse(postid, userId);
}

export async function POST(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  await redisCluster.sadd(likeKey(postid), userId);

  return await getResponse(postid, userId);
}

export async function DELETE(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  await redisCluster.srem(likeKey(postid), userId);

  return await getResponse(postid, userId);
}

async function getResponse(postid: string, userId: string) {
  const key = likeKey(postid);
  const [count, isLiked] = await Promise.all([
    redisCluster.scard(key),
    redisCluster.sismember(key, userId),
  ]);

  return NextResponse.json({
    count,
    isLiked: isLiked === 1,
  });
}
