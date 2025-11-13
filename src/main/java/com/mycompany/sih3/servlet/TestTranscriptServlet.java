package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.Lesson;
import com.mycompany.sih3.util.VideoTranscriptionUtil;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/test-transcript")
public class TestTranscriptServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Create a test lesson
            Lesson lesson = new Lesson();
            lesson.setId(1);
            lesson.setTitle("Test Environmental Science Lesson");
            lesson.setCategory("Environmental Science");
            lesson.setDescription("This is a test lesson about environmental science concepts.");
            
            // Generate transcript
            String transcript = VideoTranscriptionUtil.transcribeAudio(null, lesson);
            
            // Set response content type
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            
            // Write transcript to response
            PrintWriter out = response.getWriter();
            out.println("Transcript Generation Test");
            out.println("==========================");
            out.println();
            out.println(transcript);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                              "Error generating transcript: " + e.getMessage());
        }
    }
}