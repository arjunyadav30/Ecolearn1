-- SQL script to create activity_log table
CREATE TABLE IF NOT EXISTS activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    points_earned INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_activity_log_user_id (user_id),
    INDEX idx_activity_log_type (activity_type),
    INDEX idx_activity_log_created_at (created_at)
);

-- Sample data for testing
-- INSERT INTO activity_log (user_id, activity_type, title, description, points_earned) 
-- VALUES 
-- (1, 'challenge', 'Completed Challenge: Plastic-Free Week', 'Successfully completed the Plastic-Free Week challenge', 150),
-- (1, 'lesson', 'Finished Lesson: Renewable Energy Sources', 'Completed all modules in the Renewable Energy Sources lesson', 100),
-- (1, 'game', 'Completed Game: Eco Sorting Challenge', 'Achieved high score in the Eco Sorting Challenge game', 50),
-- (1, 'achievement', 'Unlocked Achievement: Eco Warrior', 'Reached the Eco Warrior level', 75),
-- (1, 'challenge', 'Completed Daily Challenge: Plant a Tree', 'Planted and registered a tree in the community', 100);