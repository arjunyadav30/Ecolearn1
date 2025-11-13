# Camera Functionality Testing Guide

## Overview
This guide explains how to test the camera functionality implemented for the "Plant a Tree" challenge in the EcoLearn platform.

## Test Files Created
1. `plant-tree-challenge.jsp` - The main challenge page with full camera implementation
2. `camera-test.jsp` - A simplified test page for basic camera functionality
3. `CAMERA_IMPLEMENTATION_SUMMARY.md` - Detailed documentation of the implementation

## Prerequisites for Testing
1. A web server capable of serving JSP files (Apache Tomcat, Jetty, etc.)
2. A device with a camera (webcam, smartphone camera)
3. A modern browser that supports WebRTC (Chrome, Firefox, Safari, Edge)

## Quick Test Method (Without Server)

If you want to quickly test the camera functionality without setting up a full server:

1. Open `camera-test.html` (created below) in your browser
2. Click "Start Camera"
3. Allow camera access when prompted
4. Click "Capture Photo" to take a picture
5. Click "Switch Camera" to toggle between front and rear cameras

### Simple HTML Test File
Create a file named `camera-test.html` with the following content:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Camera Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .camera-container {
            position: relative;
            width: 100%;
            height: 400px;
            background: #000;
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
        }
        #videoElement {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .controls {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            background: #007bff;
            color: white;
        }
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        #photoPreview {
            width: 100%;
            max-width: 400px;
            display: none;
            margin: 20px auto;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <h1>Camera Test</h1>
    <p>Test the camera functionality for the Plant a Tree challenge.</p>
    
    <div class="camera-container">
        <video id="videoElement" autoplay playsinline></video>
    </div>
    
    <div class="controls">
        <button id="startCameraBtn">Start Camera</button>
        <button id="captureBtn" disabled>Capture Photo</button>
        <button id="switchCameraBtn" disabled>Switch Camera</button>
    </div>
    
    <img id="photoPreview" alt="Captured photo">
    
    <script>
        let video = document.getElementById('videoElement');
        let stream = null;
        let currentFacingMode = 'environment';
        
        const startCameraBtn = document.getElementById('startCameraBtn');
        const captureBtn = document.getElementById('captureBtn');
        const switchCameraBtn = document.getElementById('switchCameraBtn');
        const photoPreview = document.getElementById('photoPreview');
        
        startCameraBtn.addEventListener('click', startCamera);
        captureBtn.addEventListener('click', capturePhoto);
        switchCameraBtn.addEventListener('click', switchCamera);
        
        async function startCamera() {
            try {
                stream = await navigator.mediaDevices.getUserMedia({
                    video: { facingMode: currentFacingMode },
                    audio: false
                });
                
                video.srcObject = stream;
                captureBtn.disabled = false;
                switchCameraBtn.disabled = false;
                startCameraBtn.textContent = 'Camera Running';
                startCameraBtn.disabled = true;
            } catch (err) {
                console.error("Error accessing camera:", err);
                alert('Error accessing camera: ' + err.message);
            }
        }
        
        function capturePhoto() {
            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            
            const ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            
            const dataUrl = canvas.toDataURL('image/png');
            photoPreview.src = dataUrl;
            photoPreview.style.display = 'block';
            
            // Stop camera stream
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
            }
            
            captureBtn.disabled = true;
            switchCameraBtn.disabled = true;
            startCameraBtn.textContent = 'Start Camera';
            startCameraBtn.disabled = false;
        }
        
        function switchCamera() {
            currentFacingMode = currentFacingMode === 'environment' ? 'user' : 'environment';
            
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
            }
            
            startCamera();
        }
        
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            alert('Camera not supported in your browser. Please try a different browser.');
        }
    </script>
</body>
</html>
```

## Full Application Testing

To test the complete implementation in the EcoLearn platform:

1. Deploy the application to a JSP-capable server
2. Navigate to the Challenges page
3. Find the "Plant a Tree" challenge
4. Click "Complete with Camera"
5. Follow the on-screen instructions to:
   - Start the camera
   - Capture a photo of your planted tree
   - Review and submit the photo

## Troubleshooting

### Common Issues:
1. **Camera access denied**: Make sure you're accessing the page via HTTPS in production environments
2. **Black screen**: Check that your camera is not being used by another application
3. **No camera found**: Verify that your device has a working camera
4. **Browser compatibility**: Use a modern browser that supports WebRTC

### Browser Requirements:
- Chrome 53+
- Firefox 36+
- Safari 11+
- Edge 12+

Internet Explorer is not supported.

## Security Notes
- Camera access requires explicit user permission
- No images are stored or transmitted without user action
- All processing happens client-side until submission