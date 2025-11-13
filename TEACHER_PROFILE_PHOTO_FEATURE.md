# Teacher Profile Photo Feature Implementation

## Overview
This document describes the implementation of the profile photo feature for teachers in the EcoLearn Platform.

## Implementation Details

### 1. File Structure
- Profile photo uploads are stored in: `/uploads/avatars/`
- Each file is named with the pattern: `{userId}_{timestamp}_{originalFileName}`
- Teacher-specific pages are located in: `/Teacher/` directory

### 2. Key Files Modified/Added

1. **Teacher Profile Page** (`/Teacher/profile.jsp`)
   - Added profile photo display functionality
   - Added profile photo upload interface in the edit modal
   - Added JavaScript for image preview
   - Updated form action to use teacher-specific update handler

2. **Teacher Profile Update Handler** (`/Teacher/updateProfile.jsp`)
   - Handles multipart form data for file uploads
   - Saves uploaded images to `/uploads/avatars/` directory
   - Updates user's avatar path in the database
   - Updates user session with new information

3. **Database Schema** (`update_users_table_avatar.sql`)
   - Ensures `avatar` column exists in the `users` table
   - Column type: `VARCHAR(255)` to store file paths

### 3. Features Implemented

- **Profile Photo Display**: Shows current profile photo or default user icon
- **Photo Upload**: Allows teachers to upload new profile photos
- **Image Preview**: Shows preview of selected image before saving
- **File Naming**: Uses unique naming to prevent conflicts
- **Session Management**: Updates user session with new avatar information

### 4. Technical Details

#### File Upload Process
1. User selects a new profile photo in the edit modal
2. JavaScript provides immediate preview of the selected image
3. On form submission, multipart data is sent to updateProfile.jsp
4. Server-side code:
   - Validates file upload
   - Saves file to `/uploads/avatars/` with unique name
   - Updates database with new avatar path
   - Updates user session
   - Redirects back to profile page

#### Security Considerations
- File type validation (image files only)
- Unique file naming prevents overwrites
- Files stored outside web-accessible directories (if needed)
- Session validation ensures only logged-in teachers can update profiles

### 5. Usage Instructions

1. Teachers navigate to their profile page
2. Click "Edit Profile" button
3. Click on the camera icon to select a new profile photo
4. Select an image file from their device
5. See preview of the selected image
6. Click "Save Changes" to update profile

### 6. Error Handling

- Validation for required fields
- File upload size limits (50MB maximum)
- Error redirection with appropriate messages
- Graceful handling of missing avatar (shows default icon)

## Testing

A test page is available at `/Teacher/test-avatar.jsp` to verify avatar functionality.

## Future Enhancements

- Image resizing/compression for better performance
- Support for different image formats
- Avatar cropping functionality
- Integration with third-party avatar services