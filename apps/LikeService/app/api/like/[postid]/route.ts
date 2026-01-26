import { NextRequest, NextResponse } from 'next/server';
import { getUserId } from '../../../utils/_user';

const DB = {
  likes: new Map<string, Set<string>>()
}

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  return getResponse(postid, userId);
}

export async function POST(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  const likes = DB.likes.get(postid) ?? new Set<string>();
  likes.add(userId);
  DB.likes.set(postid, likes);

  return getResponse(postid, userId);
}

export async function DELETE(
  _request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();

  const likes = DB.likes.get(postid) ?? new Set<string>();
  likes.delete(userId);
  DB.likes.set(postid, likes);

  return getResponse(postid, userId);
}

function getResponse(postid: string, userId: string) {
  return NextResponse.json({
    count: DB.likes.get(postid)?.size ?? 0,
    isLiked: DB.likes.get(postid)?.has(userId) ?? false
  });
}