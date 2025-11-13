-- Add avatar column to users table if it doesn't exist
ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar VARCHAR(255) NULL DEFAULT NULL;

-- If the above doesn't work on your database system, you can use this alternative:
-- ALTER TABLE users ADD COLUMN avatar VARCHAR(255) NULL DEFAULT NULL;