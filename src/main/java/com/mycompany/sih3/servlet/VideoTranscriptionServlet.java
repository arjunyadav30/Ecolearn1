package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.Lesson;
import com.mycompany.sih3.repository.LessonRepository;
import com.mycompany.sih3.util.VideoTranscriptionUtil;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/transcribe-video")
public class VideoTranscriptionServlet extends HttpServlet {
    
    // Simulated transcription service executor
    private ExecutorService transcriptionExecutor;
    
    @Override
    public void init() throws ServletException {
        super.init();
        transcriptionExecutor = Executors.newFixedThreadPool(3);
    }
    
    @Override
    public void destroy() {
        if (transcriptionExecutor != null) {
            transcriptionExecutor.shutdown();
        }
        super.destroy();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is authenticated as teacher
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../jsp/login.jsp");
            return;
        }
        
        String lessonIdParam = request.getParameter("lessonId");
        if (lessonIdParam == null || lessonIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lesson ID is required");
            return;
        }
        
        try {
            int lessonId = Integer.parseInt(lessonIdParam);
            LessonRepository lessonRepository = new LessonRepository();
            Lesson lesson = lessonRepository.findById(lessonId);
            
            if (lesson == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Lesson not found");
                return;
            }
            
            // Check if lesson has a video
            if (lesson.getVideoUrl() == null || lesson.getVideoUrl().isEmpty()) {
                request.setAttribute("errorMessage", "This lesson does not have a video.");
                request.getRequestDispatcher("/Teacher/video-transcript.jsp").forward(request, response);
                return;
            }
            
            // Get the real path to the video file
            String videoPath = getServletContext().getRealPath("/") + lesson.getVideoUrl();
            File videoFile = new File(videoPath);
            
            if (!videoFile.exists()) {
                request.setAttribute("errorMessage", "Video file not found on server.");
                request.getRequestDispatcher("/Teacher/video-transcript.jsp").forward(request, response);
                return;
            }
            
            // Check if transcript already exists
            String transcriptPath = getServletContext().getRealPath("/") + "uploads/transcripts/" + lessonId + ".txt";
            File transcriptFile = new File(transcriptPath);
            
            String transcript = "";
            boolean isProcessing = false;
            
            if (transcriptFile.exists()) {
                // Read existing transcript
                transcript = new String(Files.readAllBytes(transcriptFile.toPath()));
            } else {
                // Check if transcript is currently being processed
                String processingFlagPath = transcriptPath + ".processing";
                File processingFlagFile = new File(processingFlagPath);
                
                if (processingFlagFile.exists()) {
                    isProcessing = true;
                    transcript = "Transcript generation in progress... Please refresh this page in a few minutes.";
                } else {
                    // Start asynchronous transcription process
                    startTranscriptionProcess(videoFile, lesson, transcriptPath, processingFlagPath);
                    isProcessing = true;
                    transcript = "Transcript generation has started. Please refresh this page in a few minutes.";
                }
            }
            
            request.setAttribute("lesson", lesson);
            request.setAttribute("transcript", transcript);
            request.setAttribute("isProcessing", isProcessing);
            request.getRequestDispatcher("/Teacher/video-transcript.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID format");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing video: " + e.getMessage());
            request.getRequestDispatcher("/Teacher/video-transcript.jsp").forward(request, response);
        }
    }
    
    /**
     * Start the asynchronous transcription process
     */
    private void startTranscriptionProcess(File videoFile, Lesson lesson, String transcriptPath, String processingFlagPath) {
        transcriptionExecutor.submit(() -> {
            try {
                // Create processing flag file
                File processingFlagFile = new File(processingFlagPath);
                processingFlagFile.createNewFile();
                
                // Extract audio from video using utility method
                File audioFile = VideoTranscriptionUtil.extractAudioFromVideo(videoFile, lesson);
                
                // Transcribe audio to text using utility method
                String transcript = VideoTranscriptionUtil.transcribeAudio(audioFile, lesson);
                
                // Save transcript to file using utility method
                try {
                    VideoTranscriptionUtil.saveTranscriptToFile(transcript, transcriptPath);
                } catch (IOException e) {
                    e.printStackTrace();
                    // Log error but continue to clean up
                }
                
                // Remove processing flag file
                processingFlagFile.delete();
                
            } catch (Exception e) {
                e.printStackTrace();
                try {
                    // Save error message as transcript
                    String errorTranscript = "Error generating transcript: " + e.getMessage() + 
                                           "\n\nThis transcript could not be generated automatically. " +
                                           "Please try again later or contact support.";
                    VideoTranscriptionUtil.saveTranscriptToFile(errorTranscript, transcriptPath);
                    
                    // Remove processing flag file
                    new File(processingFlagPath).delete();
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
            }
        });
    }
}