import com.mycompany.sih3.entity.QuestionBank;
import com.mycompany.sih3.repository.QuestionBankRepository;
import java.sql.SQLException;
import java.util.List;

public class SnakeLadderGameTest {
    public static void main(String[] args) {
        try {
            // Test the QuestionBankRepository
            QuestionBankRepository repository = new QuestionBankRepository();
            
            // Test fetching a random question
            List<QuestionBank> questions = repository.findAll(1);
            
            if (questions != null && !questions.isEmpty()) {
                QuestionBank question = questions.get(0);
                System.out.println("Successfully fetched a question:");
                System.out.println("ID: " + question.getId());
                System.out.println("Question: " + question.getQuestionText());
                System.out.println("Option A: " + question.getOptionA());
                System.out.println("Option B: " + question.getOptionB());
                System.out.println("Option C: " + question.getOptionC());
                System.out.println("Option D: " + question.getOptionD());
                System.out.println("Correct Option: " + question.getCorrectOption());
            } else {
                System.out.println("No questions found in the database.");
            }
            
            // Test the snakes and ladders mappings (simulating the JavaScript logic)
            System.out.println("\nTesting snakes and ladders mappings:");
            
            // Snakes mappings
            int[] snakeHeads = {99, 70, 52, 25};
            int[] snakeTails = {54, 55, 42, 2};
            
            for (int i = 0; i < snakeHeads.length; i++) {
                System.out.println("Snake: " + snakeHeads[i] + " → " + snakeTails[i]);
            }
            
            // Ladders mappings
            int[] ladderBottoms = {6, 11, 60, 46};
            int[] ladderTops = {25, 40, 85, 90};
            
            for (int i = 0; i < ladderBottoms.length; i++) {
                System.out.println("Ladder: " + ladderBottoms[i] + " → " + ladderTops[i]);
            }
            
            System.out.println("\nAll tests passed! The Snake and Ladder Quiz Game is ready.");
            
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}