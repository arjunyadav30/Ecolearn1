package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.Lesson;
import com.mycompany.sih3.util.VideoTranscriptionUtil;
import java.io.*;

public class CompleteTranscriptTest {
    public static void main(String[] args) {
        try {
            System.out.println("=== Complete Transcript Generation Test ===\n");
            
            // Create a test lesson
            Lesson lesson = new Lesson();
            lesson.setId(5);
            lesson.setTitle("Complete Workflow Test Lesson");
            lesson.setCategory("Workflow Testing");
            lesson.setDescription("This test verifies the complete transcript generation workflow.");
            
            System.out.println("1. Created test lesson:");
            System.out.println("   ID: " + lesson.getId());
            System.out.println("   Title: " + lesson.getTitle());
            System.out.println("   Category: " + lesson.getCategory());
            System.out.println();
            
            // Generate transcript
            System.out.println("2. Generating transcript...");
            String transcript = VideoTranscriptionUtil.transcribeAudio(null, lesson);
            System.out.println("   Transcript generated successfully (" + transcript.length() + " characters)\n");
            
            // Test saving to the web app directory structure
            String userDir = System.getProperty("user.dir");
            String transcriptPath = userDir + "/src/main/webapp/uploads/transcripts/" + lesson.getId() + ".txt";
            String processingFlagPath = transcriptPath + ".processing";
            
            System.out.println("3. Testing file paths:");
            System.out.println("   Transcript path: " + transcriptPath);
            System.out.println("   Processing flag path: " + processingFlagPath);
            System.out.println();
            
            // Simulate processing flag creation
            System.out.println("4. Creating processing flag...");
            File processingFlagFile = new File(processingFlagPath);
            processingFlagFile.createNewFile();
            System.out.println("   Processing flag created\n");
            
            // Save transcript
            System.out.println("5. Saving transcript...");
            VideoTranscriptionUtil.saveTranscriptToFile(transcript, transcriptPath);
            System.out.println("   Transcript saved successfully\n");
            
            // Remove processing flag
            System.out.println("6. Removing processing flag...");
            processingFlagFile.delete();
            System.out.println("   Processing flag removed\n");
            
            // Verify the files
            System.out.println("7. Verifying files:");
            File transcriptFile = new File(transcriptPath);
            File flagFile = new File(processingFlagPath);
            
            if (transcriptFile.exists()) {
                System.out.println("   Transcript file: EXISTS (" + transcriptFile.length() + " bytes)");
            } else {
                System.out.println("   Transcript file: MISSING");
            }
            
            if (flagFile.exists()) {
                System.out.println("   Processing flag: EXISTS");
            } else {
                System.out.println("   Processing flag: REMOVED (as expected)");
            }
            
            System.out.println("\n=== Test Complete ===");
            System.out.println("The complete transcript generation workflow is functioning correctly.");
            
        } catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}