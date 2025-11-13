package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.Lesson;
import com.mycompany.sih3.util.VideoTranscriptionUtil;
import java.io.*;

public class TranscriptPathTest {
    public static void main(String[] args) {
        try {
            // Create a test lesson
            Lesson lesson = new Lesson();
            lesson.setId(1);
            lesson.setTitle("Path Test Lesson");
            lesson.setCategory("Path Testing");
            lesson.setDescription("This is a test to verify file paths.");
            
            // Generate transcript
            System.out.println("Generating transcript...");
            String transcript = VideoTranscriptionUtil.transcribeAudio(null, lesson);
            
            // Test saving to the web app directory structure
            String userDir = System.getProperty("user.dir");
            String transcriptPath = userDir + "/src/main/webapp/uploads/transcripts/1.txt";
            System.out.println("Saving transcript to: " + transcriptPath);
            
            VideoTranscriptionUtil.saveTranscriptToFile(transcript, transcriptPath);
            
            System.out.println("Transcript saved successfully!");
            
            // Verify the file was created
            File transcriptFile = new File(transcriptPath);
            if (transcriptFile.exists()) {
                System.out.println("File verification: SUCCESS");
                System.out.println("File size: " + transcriptFile.length() + " bytes");
            } else {
                System.out.println("File verification: FAILED");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}