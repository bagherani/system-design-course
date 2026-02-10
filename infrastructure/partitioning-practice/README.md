# PostgreSQL Partitioning Practice

Terraform setup for the **PostgreSQL Partitioning Lab (Users by Continent)** described in the main [infrastructure readme](../readme.md).

## What this creates

- A PostgreSQL 16 container (Docker) on port `5432` (configurable)
- A `demo` database with a **partitioned** `users` table using **LIST partitioning** by `continent`
- Partitions: `users_africa`, `users_antarctica`, `users_asia`, `users_europe`, `users_north_america`, `users_south_america`, `users_oceania`, and `users_other` (default)
- Sample rows inserted so you can verify which partition each row lives in

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Docker](https://docs.docker.com/get-docker/) installed and running

## Usage

```bash
cd infrastructure/partitioning-practice
terraform init
terraform apply
```

When port 5432 is already in use, set a different host port:

```bash
terraform apply -var="host_port=5433"
```

## Connect

Open the PostgreSQL shell in the `demo` database:

```bash
docker exec -it pg psql -U postgres -d demo
```

Or use the output:

```bash
terraform output -raw connection_command
# then run the printed command
```

In `psql`:

- `\dt` — list tables (you’ll see `users` and the partition tables)
- `\d+ users` — show partition layout
- Use the [SQLTools](https://open-vsx.org/extension/mtxr/sqltools) extension in Cursor as in the main readme to browse tables and “Show Records” per partition

## Lab steps

For the full lab (validating partitions, default partition, etc.), follow the steps in [../readme.md](../readme.md) from **step 4** onward; the database and partitioned table are already created by Terraform.

## Cleanup

```bash
terraform destroy
```

This removes the container and its volume.
