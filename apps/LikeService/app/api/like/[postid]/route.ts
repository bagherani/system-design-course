import { NextRequest, NextResponse } from 'next/server';

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  
  // API endpoint that accepts postid and does nothing
  return NextResponse.json({ 
    message: 'Like endpoint called',
    postid: postid 
  });
}

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ postid: string }> }
) {
  const { postid } = await params;
  
  // API endpoint that accepts postid and does nothing
  return NextResponse.json({ 
    message: 'Like endpoint called',
    postid: postid 
  });
}
