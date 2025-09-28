-- SQL script to add video_url column to lessons table
ALTER TABLE lessons ADD COLUMN video_url VARCHAR(500) NULL DEFAULT NULL AFTER category;
CREATE INDEX idx_lessons_video_url ON lessons (video_url);