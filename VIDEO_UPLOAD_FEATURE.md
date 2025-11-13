# Video Upload Feature Implementation

## Overview
This document describes the implementation of the video upload feature that allows teachers to add lessons as videos from their local folders rather than using external links.

## Components Implemented

### 1. Backend Components

#### Lesson Entity (`Lesson.java`)
- Added `videoUrl` field to store the path to uploaded videos
- Added getter and setter methods for the `videoUrl` field

#### Lesson Repository (`LessonRepository.java`)
- Added methods to save, find, update, and delete lessons with video URLs
- Implemented database operations for the new `video_url` column

#### Database Schema (`update_lessons_table.sql`)
- Added `video_url` column to the `lessons` table
- Added index for better performance when querying by video_url

### 2. Frontend Components

#### Video Upload Form (`upload-video-lesson.jsp`)
- Created a form for teachers to upload video lessons
- Implemented file validation for size (max 100MB) and type (video formats)
- Added form fields for lesson title, description, category, and points

#### Video Upload Handler (`handleVideoUpload.jsp`)
- Processes multipart form data for video file uploads
- Saves files to server with unique names
- Stores lesson information in database using LessonRepository

#### Video Lessons Display (`video-lessons.jsp`)
- Created page to display video lessons to users
- Fetches all lessons with video URLs from database
- Shows video lessons in a grid layout with play buttons

#### Video Lesson Viewer (`view-video-lesson.jsp`)
- Created page to view/play individual video lessons
- Displays video player with lesson details
- Shows lesson metadata (title, description, category, points)

#### Teacher Dashboard Update (`teacher-dashboard.jsp`)
- Added "Upload Video Lesson" option to the teacher dashboard
- Provides easy access to the video upload functionality

#### Main Lessons Page Update (`lessons.jsp`)
- Added "View Video Lessons" button to the main lessons page
- Provides easy access to all video lessons

## How It Works

1. **Teacher Uploads Video:**
   - Teacher navigates to "Upload Video Lesson" from the teacher dashboard
   - Teacher fills in lesson details (title, description, category, points)
   - Teacher selects a video file from their local device
   - Teacher submits the form
   - System validates the file (size and type)
   - System saves the video file to the server in `uploads/videos/` directory
   - System stores lesson information in the database with the video file path

2. **Student Views Video Lessons:**
   - Student navigates to "Video Lessons" from the main lessons page or navigation menu
   - Student sees a grid of all available video lessons
   - Student clicks "Watch Lesson" on any video lesson
   - Student is taken to the video player page to watch the lesson

## File Storage
- Videos are stored in `uploads/videos/` directory within the web application
- Files are saved with unique names to prevent conflicts
- Maximum file size is limited to 100MB
- Supported video formats: MP4, AVI, MOV, WMV

## Security Features
- File type validation to ensure only video files are uploaded
- File size validation to prevent excessive storage usage
- Unique file naming to prevent conflicts
- Server-side validation of all form inputs

## Database Schema Changes
```sql
ALTER TABLE lessons ADD COLUMN video_url VARCHAR(500) NULL DEFAULT NULL AFTER category;
CREATE INDEX idx_lessons_video_url ON lessons (video_url);
```

## Testing
A test page (`test-video-upload.jsp`) is available to verify the functionality:
- Check teacher dashboard for "Upload Video Lesson" option
- Test video upload form
- Verify video lessons display correctly
- Test video playback functionality

## Access Points
- **Teacher Dashboard:** "Upload Video Lesson" button
- **Main Navigation:** "Video Lessons" link
- **Main Lessons Page:** "View Video Lessons" button
- **Direct URLs:**
  - `/jsp/upload-video-lesson.jsp` (requires teacher authentication)
  - `/jsp/video-lessons.jsp`
  - `/jsp/view-video-lesson.jsp?id=[lesson_id]`

## Error Handling
- File size validation with user-friendly error messages
- File type validation with supported format information
- Database operation error handling
- User authentication checks for teacher-only features