CREATE KEYSPACE IF NOT EXISTS demo
  WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
  };

CREATE TABLE IF NOT EXISTS demo.users (
  user_id UUID PRIMARY KEY,
  name    TEXT,
  age     INT
);
