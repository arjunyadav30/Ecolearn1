-- Create users table (Postgres)
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  username VARCHAR(100) UNIQUE,
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255),
  user_type VARCHAR(50),
  school_id INTEGER REFERENCES schools(id) ON DELETE SET NULL,
  age INTEGER,
  class_grade VARCHAR(100),
  avatar VARCHAR(255),
  registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
