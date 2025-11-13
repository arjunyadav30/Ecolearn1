package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.Lesson;
import com.mycompany.sih3.util.VideoTranscriptionUtil;
import java.io.*;

public class ManualTranscriptTest {
    public static void main(String[] args) {
        try {
            // Create a test lesson
            Lesson lesson = new Lesson();
            lesson.setId(999);
            lesson.setTitle("Manual Test Lesson");
            lesson.setCategory("Test Category");
            lesson.setDescription("This is a manual test lesson.");
            
            // Generate transcript
            System.out.println("Generating transcript...");
            String transcript = VideoTranscriptionUtil.transcribeAudio(null, lesson);
            
            // Save transcript to file with absolute path
            String transcriptPath = System.getProperty("user.dir") + "/test-transcript.txt";
            System.out.println("Saving transcript to: " + transcriptPath);
            VideoTranscriptionUtil.saveTranscriptToFile(transcript, transcriptPath);
            
            System.out.println("Transcript saved successfully!");
            System.out.println("Transcript content:");
            System.out.println(transcript);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}