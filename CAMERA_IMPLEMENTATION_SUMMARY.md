# Camera Implementation for Plant a Tree Challenge

## Overview
This implementation adds camera functionality to the "Plant a Tree" challenge in the EcoLearn platform. When users select this challenge, they will be directed to a new page where they can use their device's camera to document their tree planting activity.

## Files Created/Modified

### 1. New File: `plant-tree-challenge.jsp`
- **Location**: `src/main/webapp/jsp/plant-tree-challenge.jsp`
- **Purpose**: Dedicated page for the tree planting challenge with camera functionality
- **Features**:
  - Camera access using WebRTC API
  - Photo capture capability
  - Photo preview before submission
  - Camera switching (front/rear)
  - Responsive design with Bootstrap
  - Challenge instructions and information

### 2. Modified File: `challenges.jsp`
- **Location**: `src/main/webapp/jsp/challenges.jsp`
- **Change**: Updated the "Plant a Tree" challenge button to link to the new camera page
- **Before**: `<button class="btn btn-primary btn-challenge">`
- **After**: `<a href="plant-tree-challenge.jsp" class="btn btn-primary btn-challenge">`

## Camera Functionality Details

### Features Implemented:
1. **Camera Access**: Uses `navigator.mediaDevices.getUserMedia()` to access the device camera
2. **Photo Capture**: Captures still images from the video stream using HTML5 Canvas
3. **Camera Switching**: Allows users to switch between front and rear cameras
4. **Photo Preview**: Shows captured image before submission
5. **Retake Option**: Allows users to retake photos if not satisfied
6. **Error Handling**: Gracefully handles camera access denials and unsupported browsers

### Technical Implementation:
- Uses modern WebRTC APIs for camera access
- Implements responsive design for mobile and desktop
- Follows progressive enhancement principles
- Includes proper error handling and user feedback

## How to Test

### Prerequisites:
1. A web server to serve the JSP files (Apache Tomcat, Jetty, etc.)
2. A device with a camera (webcam, smartphone camera)
3. A modern browser that supports WebRTC (Chrome, Firefox, Safari, Edge)

### Deployment Steps:
1. Build the WAR file using Maven:
   ```bash
   mvn clean package
   ```
2. Deploy the WAR file to your application server (e.g., Tomcat)
3. Access the application through your browser

### Testing the Camera Feature:
1. Navigate to the Challenges page
2. Find the "Plant a Tree" challenge
3. Click the "Complete Challenge" button
4. Click "Start Camera" to access your device camera
5. Position your camera to show the planted tree
6. Click the camera button to capture a photo
7. Review the photo in the preview
8. Click "Submit Challenge" to complete the challenge

## Browser Support
The camera functionality works in all modern browsers that support the MediaDevices API:
- Chrome 53+
- Firefox 36+
- Safari 11+
- Edge 12+

Internet Explorer is not supported.

## Security Considerations
- Camera access requires HTTPS in production environments
- Users must explicitly grant permission to access the camera
- No images are stored on the server without explicit user submission
- All processing happens client-side until submission

## Future Enhancements
1. Server-side image storage and processing
2. Image validation to ensure it's actually a tree
3. Geolocation tagging of planted trees
4. Social sharing features
5. Progress tracking for tree growth