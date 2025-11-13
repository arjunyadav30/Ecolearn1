-- SQL script to create lessons table
CREATE TABLE IF NOT EXISTS lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    video_url VARCHAR(500) NULL DEFAULT NULL,
    points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_lessons_category (category),
    INDEX idx_lessons_video_url (video_url)
);