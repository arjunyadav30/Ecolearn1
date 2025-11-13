-- SQL script to create students table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    student_id VARCHAR(50) UNIQUE,
    grade_level INT,
    section VARCHAR(10),
    enrollment_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_student_user_id (user_id),
    INDEX idx_student_grade_section (grade_level, section)
);

-- Sample data for testing
-- INSERT INTO students (user_id, student_id, grade_level, section, enrollment_date) 
-- VALUES (1, 'STU001', 6, 'A', '2025-09-01');