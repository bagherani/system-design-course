-- Sample data for partitioning lab (users by continent)
INSERT INTO users (name, email, continent) VALUES
  ('Ama',      'ama@example.com',       'Africa'),
  ('Li Wei',   'liwei@example.com',     'Asia'),
  ('Marie',    'marie@example.com',     'Europe'),
  ('John',     'john@example.com',      'North America'),
  ('Lucia',    'lucia@example.com',     'South America'),
  ('Noa',      'noa@example.com',        'Oceania'),
  ('Penguin',  'penguin@example.com',   'Antarctica');

-- This row lands in users_other (default partition)
INSERT INTO users (name, email, continent) VALUES
  ('Unknown',  'unknown@example.com',   'Atlantis');
