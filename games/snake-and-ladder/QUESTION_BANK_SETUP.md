# Question Bank Setup Guide

## Overview
This guide explains how to set up the question bank for the Snake and Ladder Quiz Game.

## Prerequisites
- MySQL database server
- Database named `ecolearn`
- User with appropriate permissions (typically `root` with password `1234`)

## Database Setup

### 1. Create the question_bank Table
The table is automatically created when you run the application, but you can manually create it using:

```sql
CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_question_bank_category (category),
    INDEX idx_question_bank_difficulty (difficulty_level)
);
```

### 2. Sample Data
The application automatically inserts sample questions on first run. You can also manually insert questions:

```sql
INSERT INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) 
VALUES ('Environmental Science', 'What is the primary greenhouse gas?', 'Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Methane', 'c', 'easy');
```

## Question Format

### Required Fields
- **category**: Subject area (e.g., "Environmental Science", "Mathematics")
- **question_text**: The actual question
- **option_a** to **option_d**: Four answer choices
- **correct_option**: Single letter (a, b, c, or d) indicating correct answer
- **difficulty_level**: One of: 'easy', 'medium', 'hard'

### Example
```sql
INSERT INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) 
VALUES (
    'Computer Science', 
    'What does CPU stand for?', 
    'Central Processing Unit', 
    'Computer Processing Unit', 
    'Central Processor Unit', 
    'Computer Processor Unit', 
    'a', 
    'easy'
);
```

## Verification

### Check Table Creation
```sql
DESCRIBE question_bank;
```

### Count Questions
```sql
SELECT COUNT(*) as total_questions FROM question_bank;
```

### View Sample Questions
```sql
SELECT category, question_text, correct_option FROM question_bank LIMIT 5;
```

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Verify MySQL server is running
   - Check database credentials in repository files
   - Ensure `ecolearn` database exists

2. **No Questions Displayed**
   - Verify question_bank table has data
   - Check correct_option values are lowercase letters
   - Confirm database connection in QuestionBankRepository

3. **Database Lock Errors**
   - Check for concurrent access issues
   - Verify table permissions
   - Restart MySQL service if needed

### Logs
Check Tomcat logs for detailed error messages:
- `$TOMCAT_HOME/logs/catalina.out`
- Application-specific error messages in browser console

## Maintenance

### Adding Questions
Use the same INSERT format as sample data, ensuring:
- correct_option is a single lowercase letter (a-d)
- All text fields are properly escaped
- Category names are consistent

### Updating Questions
```sql
UPDATE question_bank 
SET question_text = 'New question text', 
    option_a = 'New option A'
WHERE id = 123;
```

### Removing Questions
```sql
DELETE FROM question_bank WHERE id = 123;
```

## Best Practices

1. **Data Quality**
   - Use clear, unambiguous questions
   - Ensure exactly one correct answer
   - Provide plausible distractors for incorrect options
   - Categorize questions appropriately

2. **Performance**
   - Index frequently queried columns
   - Keep question text reasonably concise
   - Regular database maintenance

3. **Security**
   - Sanitize input data
   - Use parameterized queries
   - Limit database user permissions