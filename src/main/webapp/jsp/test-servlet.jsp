<%@ page import="java.net.*, java.io.*" %>
<%
    try {
        // Test if the question servlet is accessible
        URL url = new URL(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/question");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        
        int responseCode = connection.getResponseCode();
        out.println("<h2>Servlet Test Results:</h2>");
        out.println("<p>URL: " + url.toString() + "</p>");
        out.println("<p>Response Code: " + responseCode + "</p>");
        
        if (responseCode == 200) {
            out.println("<p style='color: green;'>✓ Servlet is accessible</p>");
            
            // Read response
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();
            
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            
            out.println("<p>Response: " + response.toString() + "</p>");
        } else {
            out.println("<p style='color: red;'>✗ Servlet is not accessible</p>");
            
            // Try to read error response
            try {
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
                String inputLine;
                StringBuffer response = new StringBuffer();
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                out.println("<p>Error Response: " + response.toString() + "</p>");
            } catch (Exception e) {
                out.println("<p>Could not read error response: " + e.getMessage() + "</p>");
            }
        }
    } catch (Exception e) {
        out.println("<h2 style='color: red;'>Servlet Test Error:</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>