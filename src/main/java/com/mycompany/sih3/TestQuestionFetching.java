package com.mycompany.sih3;

import com.mycompany.sih3.repository.QuestionBankRepository;
import com.mycompany.sih3.entity.QuestionBank;
import java.util.List;

public class TestQuestionFetching {
    public static void main(String[] args) {
        try {
            QuestionBankRepository repository = new QuestionBankRepository();
            
            // Test fetching questions with partial match
            List<QuestionBank> questions = repository.findQuestionsByPartialMatch(
                "AI", 
                "Introduction to Artificial Intelligence", 
                "Computer Science", 
                5
            );
            
            System.out.println("Found " + questions.size() + " questions:");
            for (QuestionBank question : questions) {
                System.out.println("- " + question.getQuestionText());
            }
            
            // Test with another example
            questions = repository.findQuestionsByPartialMatch(
                "Math", 
                "Basic mathematics for beginners", 
                "Mathematics", 
                5
            );
            
            System.out.println("\nFound " + questions.size() + " questions for second example:");
            for (QuestionBank question : questions) {
                System.out.println("- " + question.getQuestionText());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}