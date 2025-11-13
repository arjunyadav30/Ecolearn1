-- SQL script to create tree_submissions table
CREATE TABLE IF NOT EXISTS tree_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    photo_path VARCHAR(500) NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    teacher_comment TEXT,
    points_awarded INT DEFAULT 0,
    approval_date TIMESTAMP NULL,
    teacher_id INT NULL,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_tree_submissions_student (student_id),
    INDEX idx_tree_submissions_status (status),
    INDEX idx_tree_submissions_date (submission_date)
);

-- Sample data for testing
-- INSERT INTO tree_submissions (student_id, student_name, photo_path, status, points_awarded) 
-- VALUES 
-- (1, 'John Doe', 'uploads/trees/tree1.jpg', 'pending', 0),
-- (2, 'Jane Smith', 'uploads/trees/tree2.jpg', 'approved', 100);