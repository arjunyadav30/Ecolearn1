# Snake and Ladder Quiz Game - Troubleshooting Guide

## Common Issues and Solutions

### 1. "Error fetching question. Please try again."

This error typically occurs due to one of the following reasons:

#### A. Database Connection Issues
**Symptoms**: 
- Error message appears immediately when the game loads
- No questions are displayed

**Solutions**:
1. **Check if MySQL is running**:
   - Make sure the MySQL service is started on your system
   - On Windows, check Services for "MySQL" or "MySQL80"

2. **Verify database credentials**:
   - Check that the database username is "root" and password is "1234"
   - These are hardcoded in the repository files

3. **Verify database exists**:
   - Run [create-database.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/create-database.jsp) to create the ecolearn database and question_bank table
   - Access via: `http://localhost:8080/SIH3/jsp/create-database.jsp`

4. **Check database connection parameters**:
   - The connection URL is: `jdbc:mysql://localhost:3306/ecolearn`
   - Make sure MySQL is running on port 3306

#### B. Missing question_bank Table
**Symptoms**:
- Database connection works but no questions are found

**Solutions**:
1. **Create the table**:
   - Run [create-question-bank-table.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/create-question-bank-table.jsp)
   - Access via: `http://localhost:8080/SIH3/jsp/create-question-bank-table.jsp`

2. **Verify table creation**:
   - Run [test-database-connection.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/test-database-connection.jsp) to check if the table exists

#### C. Empty question_bank Table
**Symptoms**:
- Table exists but no questions are available

**Solutions**:
1. **Populate with sample data**:
   - The [create-question-bank-table.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/create-question-bank-table.jsp) script automatically adds sample questions
   - Or run [setup-question-bank.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/setup-question-bank.jsp)

### 2. Servlet Not Found (404 Error)

#### A. Check Servlet Mapping
**Symptoms**:
- Browser console shows 404 error for `/question` endpoint

**Solutions**:
1. **Verify servlet annotation**:
   ```java
   @WebServlet("/question")
   public class QuestionServlet extends HttpServlet {
   ```

2. **Check application deployment**:
   - Make sure the application is properly deployed to Tomcat
   - Restart Tomcat server if needed

3. **Verify URL path**:
   - The JavaScript fetch request uses `../question`
   - This should resolve to the correct servlet path

### 3. Database Driver Issues

#### A. ClassNotFoundException for MySQL Driver
**Symptoms**:
- Error message: "com.mysql.cj.jdbc.Driver not found"

**Solutions**:
1. **Check Maven dependencies**:
   - Verify that `mysql-connector-java` is in [pom.xml](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/pom.xml):
   ```xml
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <version>8.0.33</version>
   </dependency>
   ```

2. **Rebuild the project**:
   - Run `mvn clean install` to ensure dependencies are properly downloaded

### 4. JSON Processing Issues

#### A. Gson Library Missing
**Symptoms**:
- Errors related to JSON processing

**Solutions**:
1. **Check Maven dependencies**:
   - Verify that `gson` is in [pom.xml](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/pom.xml):
   ```xml
   <dependency>
       <groupId>com.google.code.gson</groupId>
       <artifactId>gson</artifactId>
       <version>2.8.9</version>
   </dependency>
   ```

## Diagnostic Tools

### 1. Database Connection Test
Run [test-database-connection.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/test-database-connection.jsp) to verify:
- Database connectivity
- Table existence
- Sample data availability

### 2. Servlet Test
Run [test-servlet.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/test-servlet.jsp) to verify:
- Servlet accessibility
- Response format

### 3. Database Setup
Run [create-database.jsp](file:///C:/Users/VICTUS/Documents/NetBeansProjects/SIH3/src/main/webapp/jsp/create-database.jsp) to:
- Create the ecolearn database
- Create the question_bank table
- Insert sample questions

## Step-by-Step Resolution Process

### Step 1: Verify MySQL Server
1. Ensure MySQL service is running
2. Test connection with MySQL command line or tools like MySQL Workbench

### Step 2: Check Database Setup
1. Access `http://localhost:8080/SIH3/jsp/create-database.jsp`
2. Verify successful creation of database and table

### Step 3: Test Database Connection
1. Access `http://localhost:8080/SIH3/jsp/test-database-connection.jsp`
2. Verify connection success and data availability

### Step 4: Test Servlet
1. Access `http://localhost:8080/SIH3/jsp/test-servlet.jsp`
2. Verify servlet response

### Step 5: Play the Game
1. Access `http://localhost:8080/SIH3/jsp/snake-ladder-quiz.jsp`
2. The game should now load questions properly

## Additional Notes

### Development Environment
- Ensure Tomcat server is properly configured
- Check that all Maven dependencies are resolved
- Verify that the application context path is correct

### Production Deployment
- Update database credentials in production environment
- Ensure proper security measures for database access
- Test all endpoints before deployment

If you continue to experience issues after following this guide, please check the Tomcat logs for more detailed error information.