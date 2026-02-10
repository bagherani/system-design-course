import { NextResponse } from 'next/server';
import { getUsers } from '../../lib/cassandra';

export async function GET() {
  try {
    const users = await getUsers();
    return NextResponse.json(users);
  } catch (error) {
    console.error('Cassandra error:', error);
    return NextResponse.json(
      { error: 'Failed to read users' },
      { status: 500 }
    );
  }
}
