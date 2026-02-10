import { Client, types, policies } from 'cassandra-driver';

// Multiple contact points: driver discovers the ring and load-balances requests across nodes.
// port is the CQL port (same for all nodes).
const contactPoints = (process.env.CASSANDRA_CONTACT_POINTS ?? 'localhost').split(',').map((h) => h.trim());
const port = parseInt(process.env.CASSANDRA_PORT ?? '9042', 10);
const keyspace = process.env.CASSANDRA_KEYSPACE ?? 'demo';
const username = process.env.CASSANDRA_USER ?? 'cassandra';
const password = process.env.CASSANDRA_PASSWORD ?? 'cassandra';
const localDc = process.env.CASSANDRA_DATACENTER ?? 'datacenter1';

let client: Client | null = null;

export function getCassandraClient(): Client {
  if (!client) {
    client = new Client({
      contactPoints,
      keyspace,
      credentials: { username, password },
      localDataCenter: localDc,
      protocolOptions: { port },
      socketOptions: { connectTimeout: 3000 },
      policies: {
        loadBalancing: new policies.loadBalancing.RoundRobinPolicy(),
      },
    });
  }
  return client;
}

export type UserRow = {
  user_id: string;
  name: string | null;
  age: number | null;
};

export async function getUsers(): Promise<UserRow[]> {
  const c = getCassandraClient();
  const result = await c.execute('SELECT user_id, name, age FROM users', [], {
    consistency: types.consistencies.quorum,
  });
  return result.rows.map((row) => {
    const userId = row.get('user_id');
    return {
      user_id: userId != null ? String(userId) : '',
      name: row.get('name') ?? null,
      age: row.get('age') ?? null,
    };
  });
}
