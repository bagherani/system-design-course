# Users Service

Next.js API service that reads from the Cassandra `demo.users` table and returns rows as JSON.

## API

- **GET /api/users** – Returns all users from `demo.users` as JSON.

## Environment (optional)

- `CASSANDRA_CONTACT_POINTS` – Comma-separated hosts (default: `localhost`)
- `CASSANDRA_PORT` – CQL port (default: `9042`)
- `CASSANDRA_KEYSPACE` – Keyspace (default: `demo`)
- `CASSANDRA_USER` / `CASSANDRA_PASSWORD` – Default: `cassandra` / `cassandra`
- `CASSANDRA_DATACENTER` – Default: `datacenter1`

## Run

From repo root:

```bash
pnpm install
pnpm --filter users-service dev
```

Service runs at http://localhost:3005. Ensure Cassandra is up (e.g. `infrastructure/cassandra-demo` Terraform) and reachable at the configured contact points.

```bash
curl http://localhost:3005/api/users
```
