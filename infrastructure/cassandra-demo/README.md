# Cassandra demo

Three-node cluster (RF=3), keyspace `demo`, table `users`. Schema and sample data are applied during `terraform apply`. UsersService is built and run by Terraform; it reads with QUORUM so the app stays available when one node is down.

**Prerequisites:** Docker, Terraform >= 1.0, pnpm (for building UsersService)

**Run**

```bash
cd infrastructure/cassandra-demo
terraform init
terraform apply -auto-approve
```

Allow several minutes for Cassandra to start. Init waits for all 3 nodes to show UN before creating schema and inserting data, then builds/deploys UsersService.

**Test**

Open or curl the UsersService route (see Terraform output `users_service_url`):

```bash
curl http://localhost:3005/api/users
```

**Fault tolerance:** With RF=3 and QUORUM reads, one node can be down and the app still works. Ensure all 3 nodes are UN (`docker exec cassandra-node-1 nodetool status`). Then stop one node and call the route again:

```bash
docker stop cassandra-node-2
curl http://localhost:3005/api/users
```

**Destroy**

```bash
terraform destroy -auto-approve
```
