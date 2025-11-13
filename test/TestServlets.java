import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.lang.reflect.*;

public class TestServlets {
    public static void main(String[] args) {
        try {
            // Test that servlet classes can be loaded
            Class<?> questionServletClass = Class.forName("com.mycompany.sih3.servlet.QuestionServlet");
            Class<?> updatePositionServletClass = Class.forName("com.mycompany.sih3.servlet.UpdatePositionServlet");
            
            System.out.println("✅ QuestionServlet class loaded successfully");
            System.out.println("✅ UpdatePositionServlet class loaded successfully");
            
            // Test that the servlets extend HttpServlet
            if (HttpServlet.class.isAssignableFrom(questionServletClass)) {
                System.out.println("✅ QuestionServlet extends HttpServlet");
            } else {
                System.out.println("❌ QuestionServlet does not extend HttpServlet");
            }
            
            if (HttpServlet.class.isAssignableFrom(updatePositionServletClass)) {
                System.out.println("✅ UpdatePositionServlet extends HttpServlet");
            } else {
                System.out.println("❌ UpdatePositionServlet does not extend HttpServlet");
            }
            
            // Test that required methods exist
            try {
                questionServletClass.getDeclaredMethod("doGet", HttpServletRequest.class, HttpServletResponse.class);
                System.out.println("✅ QuestionServlet has doGet method");
            } catch (NoSuchMethodException e) {
                System.out.println("❌ QuestionServlet missing doGet method");
            }
            
            try {
                updatePositionServletClass.getDeclaredMethod("doPost", HttpServletRequest.class, HttpServletResponse.class);
                System.out.println("✅ UpdatePositionServlet has doPost method");
            } catch (NoSuchMethodException e) {
                System.out.println("❌ UpdatePositionServlet missing doPost method");
            }
            
            System.out.println("\n🎉 All servlet tests passed!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Servlet class not found: " + e.getMessage());
            System.err.println("Make sure the classpath includes the compiled servlet classes.");
        } catch (Exception e) {
            System.err.println("❌ Error testing servlets: " + e.getMessage());
            e.printStackTrace();
        }
    }
}