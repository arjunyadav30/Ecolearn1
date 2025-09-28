-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option1 VARCHAR(500) NOT NULL,
    option2 VARCHAR(500) NOT NULL,
    option3 VARCHAR(500) NOT NULL,
    option4 VARCHAR(500) NOT NULL,
    correct_option INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);