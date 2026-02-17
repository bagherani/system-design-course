import Redis from 'ioredis';

/**
 * Parse Redis cluster nodes from REDIS_CLUSTER_NODES env var (comma-separated "host:port").
 * Example: REDIS_CLUSTER_NODES=redis-node-1:6379,redis-node-2:6379,localhost:6380
 * Falls back to localhost:6379,6380,6381 when unset (local dev).
 */
function getClusterStartupNodes(): { host: string; port: number }[] {
  const raw = process.env.REDIS_CLUSTER_NODES;
  if (raw && raw.trim()) {
    return raw.split(',').map((s) => {
      const trimmed = s.trim();
      const colon = trimmed.lastIndexOf(':');
      if (colon === -1) {
        return { host: trimmed, port: 6379 };
      }
      const host = trimmed.slice(0, colon);
      const port = parseInt(trimmed.slice(colon + 1), 10) || 6379;
      return { host, port };
    });
  }
  return [
    { host: 'localhost', port: 6379 },
    { host: 'localhost', port: 6380 },
    { host: 'localhost', port: 6381 },
  ];
}

const startupNodes = getClusterStartupNodes();

export const redisCluster = new Redis.Cluster(startupNodes, {
  redisOptions: {
    connectTimeout: 10000,
  },
  clusterRetryStrategy: (times) => {
    const delay = Math.min(100 + times * 2, 2000);
    return delay;
  },
  // Optional: map internal Docker IPs to host:port when running inside Docker
  // Set REDIS_CLUSTER_NAT_MAP as JSON: {"internalIp:port":"host:port",...}
  natMap: (() => {
    const raw = process.env.REDIS_CLUSTER_NAT_MAP;
    if (!raw || !raw.trim()) return undefined;
    try {
      const parsed = JSON.parse(raw) as Record<string, string>;
      const map: Record<string, { host: string; port: number }> = {};
      for (const [key, value] of Object.entries(parsed)) {
        const colon = value.lastIndexOf(':');
        map[key] =
          colon === -1
            ? { host: value, port: 6379 }
            : {
                host: value.slice(0, colon),
                port: parseInt(value.slice(colon + 1), 10) || 6379,
              };
      }
      return Object.keys(map).length ? map : undefined;
    } catch {
      return undefined;
    }
  })(),
});

redisCluster.on('connect', () => {
  console.log('✅ Redis Cluster connected');
});

redisCluster.on('ready', () => {
  console.log('✅ Redis Cluster ready');
});

redisCluster.on('error', (err) => {
  console.error('❌ Redis Cluster Error:', err.message);
});

redisCluster.on('close', () => {
  console.log('🔌 Redis Cluster connection closed');
});

export async function closeRedisCluster(): Promise<void> {
  try {
    await redisCluster.quit();
    console.log('✅ Redis cluster connection closed gracefully');
  } catch (error) {
    console.error('⚠️ Error closing Redis connection:', error);
    redisCluster.disconnect();
  }
}
