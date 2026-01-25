import { NextRequest, NextResponse } from 'next/server';
import { getUserId } from '../../../utils/_user';
import { getLikeCount } from '../../../utils/_db';

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  const userId = getUserId();
  const count = getLikeCount(postid);
  
  return NextResponse.json({
    count: 0
  });
}

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  
  return NextResponse.json({
    count: 0
  });
}
