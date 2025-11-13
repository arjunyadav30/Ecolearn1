<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    
    // Redirect to login if user is not logged in
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Fetch user from database
    UserRepository userRepository = new UserRepository();
    User user = userRepository.findById(userId);
    if (user != null) {
        userName = user.getFullName();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Plant a Tree Challenge - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-green: #27ae60;
            --secondary-teal: #1abc9c;
            --accent-orange: #fd7e14;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --border-radius-lg: 0.75rem;
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
        }
        
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
        }
        
        .challenge-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #27ae60, #1abc9c) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #27ae60 0%, #16a085 100%);
            color: white;
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-xl);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .page-subtitle {
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .challenge-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .camera-container {
            position: relative;
            width: 100%;
            height: 400px;
            background: #000;
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            margin-bottom: var(--spacing-lg);
        }
        
        #videoElement {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .camera-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0, 0, 0, 0.5);
            color: white;
            flex-direction: column;
            text-align: center;
        }
        
        .camera-overlay i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .camera-controls {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .btn-camera {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: none;
            background: white;
            color: #333;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-camera:hover {
            transform: scale(1.1);
        }
        
        .btn-camera.capture {
            background: #e74c3c;
            color: white;
        }
        
        .location-info {
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin: 10px;
            font-size: 0.9rem;
        }
        
        .location-info i {
            margin-right: 5px;
        }
        
        .preview-container {
            display: none;
            position: relative;
            width: 100%;
            height: 400px;
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            margin-bottom: var(--spacing-lg);
        }
        
        #photoPreview {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .btn-challenge {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-green);
            color: var(--primary-green);
        }
        
        .instructions {
            background: #e8f5e9;
            border-left: 4px solid var(--primary-green);
            padding: 1rem;
            border-radius: 0 var(--border-radius-lg) var(--border-radius-lg) 0;
            margin-bottom: var(--spacing-lg);
        }
        
        .step {
            display: flex;
            margin-bottom: 0.75rem;
        }
        
        .step-number {
            background: var(--primary-green);
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: bold;
            margin-right: 0.75rem;
            flex-shrink: 0;
        }
        
        .step-content {
            flex: 1;
        }
        
        .step-content h6 {
            margin: 0 0 0.25rem 0;
            font-size: 1rem;
        }
        
        .step-content p {
            margin: 0;
            font-size: 0.9rem;
            color: #666;
        }
        
        .progress-container {
            margin-bottom: 1rem;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        
        .progress {
            height: 10px;
            border-radius: 5px;
            background: #e9ecef;
            margin-bottom: 0.5rem;
        }
        
        .progress-bar {
            border-radius: 5px;
            height: 100%;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
        }
        
        /* Status indicator styles (matching location.html) */
        .status-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 0.5rem;
        }
        
        .status-success {
            background-color: #28a745;
        }
        
        .status-error {
            background-color: #dc3545;
        }
        
        .status-loading {
            background-color: #ffc107;
        }
    </style>
</head>
<body class="challenge-page">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fas fa-leaf me-2"></i>EcoLearn
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="games.jsp">
                            <i class="fas fa-gamepad me-1"></i>Games
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="challenges.jsp">
                            <i class="fas fa-leaf me-1"></i>Challenges
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="leaderboard.jsp">
                            <i class="fas fa-trophy me-1"></i>Leaderboard
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <div class="avatar-placeholder">
                                    <%= userName.length() > 0 ? userName.substring(0, 1).toUpperCase() : "U" %>
                                </div>
                            </div>
                            <span class="user-name"><%= userName %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="achievements.jsp"><i class="fas fa-medal me-2"></i>Achievements</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-tree me-2"></i>Plant a Tree Challenge
                    </h1>
                    <p class="page-subtitle">
                        Plant a tree in your community and document your contribution to the environment
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="stats-card">
                        <h5>Your Progress</h5>
                        <div class="stat-item">
                            <span class="stat-label">Points</span>
                            <span class="stat-value">100</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Difficulty</span>
                            <span class="stat-value">Easy</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Time</span>
                            <span class="stat-value">2-3 hours</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="challenge-card">
                    <div class="card-body">
                        <h4 class="card-title mb-4">Document Your Tree Planting</h4>
                        
                        <div class="instructions">
                            <h5><i class="fas fa-info-circle me-2"></i>Instructions</h5>
                            <div class="step">
                                <div class="step-number">1</div>
                                <div class="step-content">
                                    <h6>Plant a Tree</h6>
                                    <p>Plant a native tree species in your area or community</p>
                                </div>
                            </div>
                            <div class="step">
                                <div class="step-number">2</div>
                                <div class="step-content">
                                    <h6>Take a Photo</h6>
                                    <p>Use your camera to capture a photo of the planted tree</p>
                                </div>
                            </div>
                            <div class="step">
                                <div class="step-number">3</div>
                                <div class="step-content">
                                    <h6>Submit Your Entry</h6>
                                    <p>Upload your photo to complete the challenge</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Camera Section -->
                        <div id="cameraSection">
                            <h5><i class="fas fa-camera me-2"></i>Take a Photo of Your Planted Tree</h5>
                            <p class="text-muted">Click the camera button to start capturing your tree planting moment</p>
                            
                            <div class="camera-container">
                                <video id="videoElement" autoplay playsinline></video>
                                <div class="camera-overlay" id="cameraOverlay">
                                    <i class="fas fa-camera"></i>
                                    <p>Camera access needed to document your tree planting</p>
                                    <button id="startCameraBtn" class="btn btn-primary">
                                        <i class="fas fa-video me-2"></i>Start Camera
                                    </button>
                                </div>
                                <div class="location-info" id="locationInfo" style="display: none;">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span id="locationText">Getting location...</span>
                                </div>
                            </div>
                            
                            <div class="camera-controls">
                                <button id="getLocationBtn" class="btn-camera">
                                    <i class="fas fa-map-marker-alt"></i>
                                </button>
                                <button id="captureBtn" class="btn-camera capture" disabled>
                                    <i class="fas fa-camera"></i>
                                </button>
                                <button id="switchCameraBtn" class="btn-camera" disabled>
                                    <i class="fas fa-sync-alt"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Photo Preview Section -->
                        <div id="previewSection" class="preview-container" style="display: none;">
                            <img id="photoPreview" alt="Preview of your planted tree">
                            <div class="camera-overlay">
                                <h5>Photo Preview</h5>
                                <p>Make sure your tree is clearly visible</p>
                                <div class="camera-controls">
                                    <button id="retakeBtn" class="btn btn-outline-primary">
                                        <i class="fas fa-redo me-2"></i>Retake Photo
                                    </button>
                                    <button id="submitBtn" class="btn btn-primary">
                                        <i class="fas fa-check-circle me-2"></i>Submit Challenge
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Location Information Section -->
                        <div class="card mt-4">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-map-marker-alt me-2"></i>Location Information</h5>
                                
                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <div class="alert alert-info">
                                            <strong>Status:</strong> 
                                            <span id="trackingStatus">
                                                <span class="status-indicator status-loading"></span> Initializing
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Latitude:</strong></label>
                                            <div class="alert alert-light" id="latitude">-</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Longitude:</strong></label>
                                            <div class="alert alert-light" id="longitude">-</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Accuracy:</strong></label>
                                            <div class="alert alert-warning" id="accuracy">-</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Timestamp:</strong></label>
                                            <div class="alert alert-secondary" id="timestamp">-</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label"><strong>Address Information</strong></label>
                                    <div class="alert alert-success" id="addressText">Address will appear here after location is detected</div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label"><strong>Coordinates (Copyable)</strong></label>
                                    <div class="alert alert-light" id="coordinatesText">Coordinates will appear here after location is detected</div>
                                </div>
                                
                                <button id="refreshLocationBtn" class="btn btn-primary">
                                    <i class="fas fa-sync-alt me-2"></i>Refresh Location
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="challenge-card">
                    <div class="card-body">
                        <h5 class="card-title">Challenge Details</h5>
                        
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>78%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" style="width: 78%;"></div>
                            </div>
                        </div>
                        
                        <h6 class="mt-4">About This Challenge</h6>
                        <p>Planting trees is one of the most effective ways to combat climate change. Trees absorb carbon dioxide from the atmosphere and release oxygen, making them natural air purifiers.</p>
                        
                        <h6>Benefits</h6>
                        <ul>
                            <li>Reduces carbon footprint</li>
                            <li>Improves air quality</li>
                            <li>Supports biodiversity</li>
                            <li>Prevents soil erosion</li>
                        </ul>
                        
                        <h6>Requirements</h6>
                        <ul>
                            <li>Plant a native tree species</li>
                            <li>Choose an appropriate location</li>
                            <li>Provide proper care (watering, mulching)</li>
                            <li>Document with a clear photo</li>
                        </ul>
                        
                        <div class="d-grid mt-4">
                            <button class="btn btn-outline-primary btn-challenge" id="helpBtn">
                                <i class="fas fa-question-circle me-2"></i>Need Help?
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Camera Functionality -->
    <script>
        // Camera variables
        let video = document.getElementById('videoElement');
        let stream = null;
        let currentFacingMode = 'environment'; // Default to rear camera
        let currentPosition = null; // Store current position
        
        // DOM Elements
        const cameraOverlay = document.getElementById('cameraOverlay');
        const startCameraBtn = document.getElementById('startCameraBtn');
        const captureBtn = document.getElementById('captureBtn');
        const switchCameraBtn = document.getElementById('switchCameraBtn');
        const cameraSection = document.getElementById('cameraSection');
        const previewSection = document.getElementById('previewSection');
        const photoPreview = document.getElementById('photoPreview');
        const retakeBtn = document.getElementById('retakeBtn');
        const submitBtn = document.getElementById('submitBtn');
        const getLocationBtn = document.getElementById('getLocationBtn');
        const locationInfo = document.getElementById('locationInfo');
        const locationText = document.getElementById('locationText');
        
        // Location DOM Elements (new ones matching location.html)
        const latitudeElement = document.getElementById('latitude');
        const longitudeElement = document.getElementById('longitude');
        const accuracyElement = document.getElementById('accuracy');
        const timestampElement = document.getElementById('timestamp');
        const coordinatesText = document.getElementById('coordinatesText');
        const addressText = document.getElementById('addressText');
        const trackingStatus = document.getElementById('trackingStatus');
        const refreshLocationBtn = document.getElementById('refreshLocationBtn');
        
        // Event Listeners
        startCameraBtn.addEventListener('click', startCamera);
        captureBtn.addEventListener('click', capturePhoto);
        switchCameraBtn.addEventListener('click', switchCamera);
        retakeBtn.addEventListener('click', retakePhoto);
        submitBtn.addEventListener('click', submitChallenge);
        getLocationBtn.addEventListener('click', getLocation);
        refreshLocationBtn.addEventListener('click', getLocation);
        
        // Initialize location on page load
        document.addEventListener('DOMContentLoaded', function() {
            getLocation();
        });
        
        // Start camera function
        async function startCamera() {
            try {
                // Hide overlay and show camera controls
                cameraOverlay.style.display = 'none';
                captureBtn.disabled = false;
                switchCameraBtn.disabled = false;
                
                // Get camera stream
                stream = await navigator.mediaDevices.getUserMedia({
                    video: { facingMode: currentFacingMode },
                    audio: false
                });
                
                // Attach stream to video element
                video.srcObject = stream;
            } catch (err) {
                console.error("Error accessing camera:", err);
                cameraOverlay.innerHTML = `
                    <i class="fas fa-exclamation-triangle"></i>
                    <p>Camera access denied. Please enable camera permissions to continue.</p>
                    <button id="retryCameraBtn" class="btn btn-primary">
                        <i class="fas fa-redo me-2"></i>Retry
                    </button>
                `;
                
                document.getElementById('retryCameraBtn').addEventListener('click', startCamera);
            }
        }
        
        // Get location function (updated to match location.html)
        function getLocation() {
            // Update status to loading
            trackingStatus.innerHTML = '<span class="status-indicator status-loading"></span> Detecting...';
            
            if (!navigator.geolocation) {
                updateLocationError("Geolocation is not supported by your browser");
                return;
            }
            
            navigator.geolocation.getCurrentPosition(
                // Success callback
                function(position) {
                    updateLocationSuccess(position);
                    // Get address information
                    getAddress(position.coords.latitude, position.coords.longitude);
                },
                // Error callback
                function(error) {
                    updateLocationError(getLocationErrorMessage(error));
                },
                {
                    enableHighAccuracy: true,
                    timeout: 15000,
                    maximumAge: 0
                }
            );
        }
        
        // Update UI with successful location data (matching location.html)
        function updateLocationSuccess(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            const accuracy = position.coords.accuracy;
            const timestamp = new Date(position.timestamp).toLocaleString();
            
            // Update UI elements
            latitudeElement.textContent = lat.toFixed(6);
            longitudeElement.textContent = lng.toFixed(6);
            accuracyElement.textContent = accuracy.toFixed(2) + " meters";
            timestampElement.textContent = timestamp;
            
            // Update coordinates text
            coordinatesText.textContent = `Latitude: ${lat.toFixed(6)}, Longitude: ${lng.toFixed(6)}`;
            
            // Update status
            trackingStatus.innerHTML = '<span class="status-indicator status-success"></span> Detected';
            
            // Update camera overlay info
            locationText.textContent = `Lat: ${lat.toFixed(6)} | Lng: ${lng.toFixed(6)} (±${accuracy.toFixed(2)}m)`;
            locationInfo.style.display = 'block';
        }
        
        // Get address from coordinates using OpenStreetMap Nominatim API (matching location.html)
        function getAddress(lat, lng) {
            addressText.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Getting address...';
            
            // Try OpenStreetMap Nominatim API first
            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&addressdetails=1`)
                .then(response => response.json())
                .then(data => {
                    if (data && data.display_name) {
                        addressText.innerHTML = `<strong>${data.display_name}</strong>`;
                    } else {
                        // If no address found, show coordinates
                        addressText.innerHTML = `Latitude: ${lat.toFixed(6)}, Longitude: ${lng.toFixed(6)}`;
                    }
                })
                .catch(error => {
                    console.error('Error with Nominatim API:', error);
                    // Show coordinates as fallback
                    addressText.innerHTML = `Latitude: ${lat.toFixed(6)}, Longitude: ${lng.toFixed(6)}`;
                });
        }
        
        // Update UI with error message (matching location.html)
        function updateLocationError(message) {
            // Update status
            trackingStatus.innerHTML = '<span class="status-indicator status-error"></span> Error';
            
            // Update UI elements with error
            latitudeElement.textContent = "Error";
            longitudeElement.textContent = "Error";
            accuracyElement.textContent = "Error";
            timestampElement.textContent = "Error";
            coordinatesText.textContent = message;
            addressText.textContent = "Address information unavailable";
            
            // Update camera overlay info
            locationText.textContent = message;
            locationInfo.style.display = 'block';
        }
        
        // Get human-readable error message (matching location.html)
        function getLocationErrorMessage(error) {
            switch(error.code) {
                case error.PERMISSION_DENIED:
                    return "Location access denied. Please enable location permissions in your browser settings.";
                case error.POSITION_UNAVAILABLE:
                    return "Location information is unavailable. Please check your device settings.";
                case error.TIMEOUT:
                    return "Location request timed out. Please try again.";
                default:
                    return "An unknown error occurred while retrieving location.";
            }
        }
        
        // Capture photo function
        function capturePhoto() {
            // If location is already available, capture photo immediately
            if (currentPosition) {
                capturePhotoWithLocation();
                return;
            }
            
            // Otherwise, get location first
            getLocationWithCapture();
        }
        
        // Get location and then capture photo
        function getLocationWithCapture() {
            if (!navigator.geolocation) {
                // If geolocation is not supported, capture photo without location
                capturePhotoWithLocation();
                return;
            }
            
            // Show that we're getting location
            const cameraControls = document.querySelector('.camera-controls');
            const loadingIndicator = document.createElement('div');
            loadingIndicator.id = 'locationLoading';
            loadingIndicator.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Getting location...';
            loadingIndicator.style.color = 'white';
            loadingIndicator.style.textAlign = 'center';
            loadingIndicator.style.marginTop = '10px';
            cameraControls.parentNode.insertBefore(loadingIndicator, cameraControls.nextSibling);
            
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    // Remove loading indicator
                    const loadingIndicator = document.getElementById('locationLoading');
                    if (loadingIndicator) {
                        loadingIndicator.remove();
                    }
                    
                    // Store position
                    currentPosition = position;
                    
                    // Update location display
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    const accuracy = position.coords.accuracy;
                    locationText.textContent = `Lat: ${lat.toFixed(6)}, Lng: ${lng.toFixed(6)} (±${accuracy.toFixed(2)}m)`;
                    locationInfo.style.display = 'block';
                    coordinatesText.textContent = `Latitude: ${lat.toFixed(6)}, Longitude: ${lng.toFixed(6)} (Accuracy: ±${accuracy.toFixed(2)} meters)`;
                    getAddress(lat, lng);
                    
                    // Now capture the photo
                    capturePhotoWithLocation();
                },
                (error) => {
                    console.error("Error getting location:", error);
                    
                    // Remove loading indicator
                    const loadingIndicator = document.getElementById('locationLoading');
                    if (loadingIndicator) {
                        loadingIndicator.remove();
                    }
                    
                    // Show error but still capture photo
                    const errorMsg = document.createElement('div');
                    errorMsg.className = 'location-info';
                    errorMsg.style.position = 'absolute';
                    errorMsg.style.top = '10px';
                    errorMsg.style.left = '10px';
                    errorMsg.style.right = '10px';
                    errorMsg.style.backgroundColor = 'rgba(255, 0, 0, 0.7)';
                    errorMsg.style.color = 'white';
                    errorMsg.style.padding = '10px';
                    errorMsg.style.borderRadius = '5px';
                    errorMsg.style.fontSize = '0.9rem';
                    errorMsg.style.zIndex = '10';
                    errorMsg.style.textAlign = 'center';
                    
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Location access denied';
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Location unavailable';
                            break;
                        case error.TIMEOUT:
                            errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Location request timed out';
                            break;
                        default:
                            errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error getting location';
                            break;
                    }
                    
                    document.querySelector('.camera-container').appendChild(errorMsg);
                    
                    // Remove error message after 3 seconds
                    setTimeout(() => {
                        if (errorMsg.parentNode) {
                            errorMsg.remove();
                        }
                    }, 3000);
                    
                    // Capture photo without location
                    capturePhotoWithLocation();
                },
                {
                    enableHighAccuracy: true,
                    timeout: 15000,
                    maximumAge: 0  // Force fresh location, no caching
                }
            );
        }
        
        // Actual photo capture function with location display
        function capturePhotoWithLocation() {
            // Create canvas to capture photo
            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            
            const ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            
            // Convert to data URL and display in preview
            const dataUrl = canvas.toDataURL('image/png');
            photoPreview.src = dataUrl;
            
            // Show preview section and hide camera
            cameraSection.style.display = 'none';
            previewSection.style.display = 'block';
            
            // Stop camera stream
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
            }
            
            // Show location info in preview if available
            if (currentPosition) {
                const lat = currentPosition.coords.latitude.toFixed(6);
                const lng = currentPosition.coords.longitude.toFixed(6);
                const locationPreview = document.createElement('div');
                locationPreview.className = 'location-info';
                locationPreview.innerHTML = `<i class="fas fa-map-marker-alt"></i> Lat: ${lat} | Lng: ${lng}`;
                locationPreview.style.position = 'absolute';
                locationPreview.style.bottom = '10px';
                locationPreview.style.left = '10px';
                locationPreview.style.right = '10px';
                locationPreview.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
                locationPreview.style.color = 'white';
                locationPreview.style.padding = '10px';
                locationPreview.style.borderRadius = '5px';
                locationPreview.style.fontSize = '0.9rem';
                locationPreview.style.zIndex = '10';
                locationPreview.style.fontFamily = 'monospace';
                locationPreview.style.textAlign = 'center';
                previewSection.appendChild(locationPreview);
            } else {
                // Show message if location is not available
                const locationPreview = document.createElement('div');
                locationPreview.className = 'location-info';
                locationPreview.innerHTML = `<i class="fas fa-exclamation-triangle"></i> Location not available`;
                locationPreview.style.position = 'absolute';
                locationPreview.style.bottom = '10px';
                locationPreview.style.left = '10px';
                locationPreview.style.right = '10px';
                locationPreview.style.backgroundColor = 'rgba(255, 0, 0, 0.7)';
                locationPreview.style.color = 'white';
                locationPreview.style.padding = '10px';
                locationPreview.style.borderRadius = '5px';
                locationPreview.style.fontSize = '0.9rem';
                locationPreview.style.zIndex = '10';
                locationPreview.style.textAlign = 'center';
                previewSection.appendChild(locationPreview);
            }
        }
        
        // Switch camera function
        function switchCamera() {
            // Toggle facing mode
            currentFacingMode = currentFacingMode === 'environment' ? 'user' : 'environment';
            
            // Stop current stream
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
            }
            
            // Restart camera with new facing mode
            startCamera();
        }
        
        // Retake photo function
        function retakePhoto() {
            // Hide preview and show camera
            previewSection.style.display = 'none';
            cameraSection.style.display = 'block';
            
            // Remove location preview if it exists
            const locationPreview = document.querySelector('.preview-container .location-info');
            if (locationPreview) {
                locationPreview.remove();
            }
            
            // Restart camera
            startCamera();
        }
        
        // Submit challenge function
        function submitChallenge() {
            // In a real implementation, you would send the photo and location to the server
            // For now, we'll just show a success message
            let message = 'Challenge submitted successfully! You have earned 100 eco-points.';
            if (currentPosition) {
                const lat = currentPosition.coords.latitude.toFixed(6);
                const lng = currentPosition.coords.longitude.toFixed(6);
                message += `\n\nLocation recorded: Lat: ${lat} | Lng: ${lng}`;
            }
            alert(message);
            
            // Redirect to challenges page
            window.location.href = 'challenges.jsp';
        }
        
        // Check for camera support
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            cameraOverlay.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                <p>Camera not supported in your browser. Please try a different browser.</p>
            `;
        }
    </script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
</body>
</html>