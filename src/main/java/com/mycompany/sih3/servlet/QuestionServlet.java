package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.QuestionBank;
import com.mycompany.sih3.repository.QuestionBankRepository;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/question")
public class QuestionServlet extends HttpServlet {
    
    private QuestionBankRepository questionRepository;
    
    @Override
    public void init() throws ServletException {
        questionRepository = new QuestionBankRepository();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Fetch a random question from the database
            List<QuestionBank> questions = questionRepository.findAll(1);
            
            if (questions != null && !questions.isEmpty()) {
                QuestionBank question = questions.get(0);
                
                // Convert to JSON and send response
                Gson gson = new Gson();
                String jsonResponse = gson.toJson(question);
                response.getWriter().write(jsonResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"No questions available\"}");
            }
        } catch (SQLException e) {
            // Log the full stack trace for debugging
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            // Log the full stack trace for debugging
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unexpected error: " + e.getMessage() + "\"}");
        }
    }
}