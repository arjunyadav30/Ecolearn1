package com.mycompany.sih3.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updatePosition")
public class UpdatePositionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Log request for debugging
            System.out.println("UpdatePositionServlet called with position: " + request.getParameter("position"));
            
            // Get position parameter
            String positionParam = request.getParameter("position");
            
            if (positionParam != null && !positionParam.isEmpty()) {
                int position = Integer.parseInt(positionParam);
                
                // Validate position range
                if (position < 1 || position > 100) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Position must be between 1 and 100");
                    return;
                }
                
                // Update session
                request.getSession().setAttribute("playerPosition", position);
                
                // Send success response
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("Position updated successfully to " + position);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Position parameter is required");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid position format: " + e.getMessage());
        } catch (Exception e) {
            // Log the full stack trace for debugging
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error updating position: " + e.getMessage());
        }
    }
}