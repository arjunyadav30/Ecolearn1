<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Location Tracker - EcoLearn Platform</title>
    
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
        
        .location-page {
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
        
        .location-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .map-container {
            height: 400px;
            background: #e9ecef;
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        .map-placeholder {
            text-align: center;
            color: #6c757d;
        }
        
        .map-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #adb5bd;
        }
        
        .location-details {
            background: #e8f5e9;
            border-left: 4px solid var(--primary-green);
            padding: 1rem;
            border-radius: 0 var(--border-radius-lg) var(--border-radius-lg) 0;
            margin-bottom: var(--spacing-lg);
        }
        
        .location-info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .location-info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 500;
            color: #495057;
        }
        
        .info-value {
            font-weight: 600;
            color: var(--primary-green);
        }
        
        .btn-location {
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
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .coordinates-display {
            font-family: 'Courier New', monospace;
            background: #f8f9fa;
            padding: 1rem;
            border-radius: var(--border-radius-lg);
            border: 1px solid #e9ecef;
            margin-bottom: var(--spacing-lg);
            word-break: break-all;
        }
        
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
<body class="location-page">
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
                    <li class="nav-item">
                        <a class="nav-link" href="location.jsp">
                            <i class="fas fa-map-marker-alt me-1"></i>Location
                        </a>
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
                        <i class="fas fa-map-marker-alt me-2"></i>Location Tracker
                    </h1>
                    <p class="page-subtitle">
                        Track your current location and environmental information
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="stats-card">
                        <h5>Location Status</h5>
                        <div class="stat-item">
                            <span class="stat-label">Tracking</span>
                            <span class="stat-value" id="trackingStatus">
                                <span class="status-indicator status-loading"></span> Initializing
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="location-card">
                    <div class="card-body">
                        <h4 class="card-title mb-4">
                            <i class="fas fa-map-marked-alt me-2"></i>Your Current Location
                        </h4>
                        
                        <div class="map-container">
                            <div class="map-placeholder" id="mapPlaceholder">
                                <i class="fas fa-map-marked-alt"></i>
                                <h5>Location Map</h5>
                                <p class="mb-0">Your location will be displayed here</p>
                            </div>
                            <div id="map" style="width: 100%; height: 100%; display: none;"></div>
                        </div>
                        
                        <div class="location-details">
                            <h5><i class="fas fa-info-circle me-2"></i>Location Information</h5>
                            <div class="location-info-item">
                                <span class="info-label">Latitude:</span>
                                <span class="info-value" id="latitude">-</span>
                            </div>
                            <div class="location-info-item">
                                <span class="info-label">Longitude:</span>
                                <span class="info-value" id="longitude">-</span>
                            </div>
                            <div class="location-info-item">
                                <span class="info-label">Accuracy:</span>
                                <span class="info-value" id="accuracy">-</span>
                            </div>
                            <div class="location-info-item">
                                <span class="info-label">Timestamp:</span>
                                <span class="info-value" id="timestamp">-</span>
                            </div>
                        </div>
                        
                        <div class="coordinates-display">
                            <h6><i class="fas fa-code me-2"></i>Coordinates (Copyable)</h6>
                            <div id="coordinatesText">Coordinates will appear here after location is detected</div>
                        </div>
                        
                        <button id="getLocationBtn" class="btn btn-primary btn-location">
                            <i class="fas fa-sync-alt me-2"></i>Refresh Location
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="location-card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-leaf me-2"></i>Environmental Insights
                        </h5>
                        
                        <div class="alert alert-info">
                            <h6><i class="fas fa-info-circle me-2"></i>Did You Know?</h6>
                            <p>Knowing your location helps us provide personalized environmental education content based on your region's ecosystem.</p>
                        </div>
                        
                        <h6 class="mt-4">Location Benefits</h6>
                        <ul>
                            <li>Personalized content for your region</li>
                            <li>Local environmental challenges</li>
                            <li>Community planting events nearby</li>
                            <li>Regional biodiversity information</li>
                        </ul>
                        
                        <h6 class="mt-4">Privacy Notice</h6>
                        <p>Your location data is only used to enhance your learning experience and is not shared with third parties.</p>
                        
                        <div class="d-grid mt-4">
                            <button class="btn btn-outline-primary btn-location" id="plantTreeBtn">
                                <i class="fas fa-tree me-2"></i>Plant a Tree Here
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Location Tracking Script -->
    <script>
        // DOM Elements
        const getLocationBtn = document.getElementById('getLocationBtn');
        const plantTreeBtn = document.getElementById('plantTreeBtn');
        const latitudeElement = document.getElementById('latitude');
        const longitudeElement = document.getElementById('longitude');
        const accuracyElement = document.getElementById('accuracy');
        const timestampElement = document.getElementById('timestamp');
        const coordinatesText = document.getElementById('coordinatesText');
        const trackingStatus = document.getElementById('trackingStatus');
        const mapPlaceholder = document.getElementById('mapPlaceholder');
        const mapElement = document.getElementById('map');
        
        // Initialize location tracking
        document.addEventListener('DOMContentLoaded', function() {
            getLocation();
        });
        
        // Event Listeners
        getLocationBtn.addEventListener('click', getLocation);
        plantTreeBtn.addEventListener('click', function() {
            window.location.href = 'plant-tree-challenge.jsp';
        });
        
        // Get location function
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
                },
                // Error callback
                function(error) {
                    updateLocationError(getLocationErrorMessage(error));
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 60000
                }
            );
        }
        
        // Update UI with successful location data
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
            
            // Show map (placeholder for now)
            mapPlaceholder.style.display = 'none';
            mapElement.style.display = 'block';
            mapElement.innerHTML = `
                <div class="d-flex flex-column align-items-center justify-content-center h-100">
                    <i class="fas fa-map-marker-alt text-success" style="font-size: 3rem;"></i>
                    <h5 class="mt-3">Your Location</h5>
                    <p class="text-center">Lat: ${lat.toFixed(6)}<br>Lng: ${lng.toFixed(6)}</p>
                    <div class="alert alert-success mt-3">
                        <i class="fas fa-check-circle me-2"></i>
                        Location successfully detected!
                    </div>
                </div>
            `;
        }
        
        // Update UI with error message
        function updateLocationError(message) {
            // Update status
            trackingStatus.innerHTML = '<span class="status-indicator status-error"></span> Error';
            
            // Update UI elements with error
            latitudeElement.textContent = "Error";
            longitudeElement.textContent = "Error";
            accuracyElement.textContent = "Error";
            timestampElement.textContent = "Error";
            coordinatesText.textContent = message;
            
            // Show error on map placeholder
            mapPlaceholder.innerHTML = `
                <div class="text-center">
                    <i class="fas fa-exclamation-triangle text-danger" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-danger">Location Error</h5>
                    <p class="mb-0">${message}</p>
                    <button class="btn btn-primary mt-3" id="retryLocationBtn">
                        <i class="fas fa-redo me-2"></i>Try Again
                    </button>
                </div>
            `;
            
            // Add event listener to retry button
            document.getElementById('retryLocationBtn')?.addEventListener('click', getLocation);
        }
        
        // Get human-readable error message
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
    </script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
</body>
</html>