// AR/VR Enhanced Environmental Education Features
// A collection of advanced features to make the platform hackathon-winning

class AREnvironmentalScanner {
    constructor() {
        this.isARSupported = this.checkARSupport();
        this.plantDatabase = this.initializePlantDatabase();
        this.currentScan = null;
    }
    
    checkARSupport() {
        // Check for WebXR support
        return 'xr' in navigator;
    }
    
    initializePlantDatabase() {
        // Database of common plants with environmental information
        return {
            "oak": {
                name: "Oak Tree",
                scientificName: "Quercus",
                co2Absorption: "22 kg/year",
                waterUsage: "Moderate",
                ecosystem: "Forest",
                facts: "Oak trees can live over 200 years and support over 500 species of insects.",
                icon: "https://cdn-icons-png.flaticon.com/512/167/167755.png"
            },
            "rose": {
                name: "Rose",
                scientificName: "Rosa",
                co2Absorption: "1 kg/year",
                waterUsage: "High",
                ecosystem: "Garden",
                facts: "Roses have been cultivated for over 5000 years and are symbols of love.",
                icon: "https://cdn-icons-png.flaticon.com/512/167/167760.png"
            },
            "fern": {
                name: "Fern",
                scientificName: "Pteridophyta",
                co2Absorption: "0.5 kg/year",
                waterUsage: "High",
                ecosystem: "Forest/Wetland",
                facts: "Ferns are ancient plants that existed before flowers and reproduce via spores.",
                icon: "https://cdn-icons-png.flaticon.com/512/167/167762.png"
            },
            "cactus": {
                name: "Cactus",
                scientificName: "Cactaceae",
                co2Absorption: "0.8 kg/year",
                waterUsage: "Very Low",
                ecosystem: "Desert",
                facts: "Cacti can survive in extreme drought conditions and store water in their stems.",
                icon: "https://cdn-icons-png.flaticon.com/512/167/167730.png"
            }
        };
    }
    
    async startPlantScan() {
        if (!this.isARSupported) {
            this.showFallbackScanner();
            return;
        }
        
        try {
            // Request XR session for environmental tracking
            const session = await navigator.xr.requestSession('immersive-ar', {
                requiredFeatures: ['hit-test']
            });
            
            // Set up XR scene
            this.setupXRScene(session);
        } catch (error) {
            console.log("AR not available, falling back to camera-based scanning");
            this.showFallbackScanner();
        }
    }
    
    showFallbackScanner() {
        // Create a camera-based scanner interface
        const scannerContainer = document.createElement('div');
        scannerContainer.id = 'plant-scanner-container';
        scannerContainer.innerHTML = `
            <div class="scanner-overlay">
                <h3><i class="fas fa-camera"></i> Plant Identification Scanner</h3>
                <p>Point your camera at a plant to identify it</p>
                <video id="scanner-video" autoplay playsinline style="width: 100%; max-width: 400px; border-radius: 10px;"></video>
                <canvas id="scanner-canvas" style="display: none;"></canvas>
                <div id="scan-result" class="scan-result"></div>
                <button id="close-scanner" class="btn btn-danger"><i class="fas fa-times"></i> Close Scanner</button>
            </div>
        `;
        
        document.body.appendChild(scannerContainer);
        
        // Access camera
        this.initCamera();
        
        // Bind close event
        document.getElementById('close-scanner').addEventListener('click', () => {
            this.closeScanner();
        });
    }
    
    async initCamera() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ 
                video: { facingMode: 'environment' } 
            });
            document.getElementById('scanner-video').srcObject = stream;
        } catch (err) {
            console.error("Camera access denied:", err);
            document.getElementById('scan-result').innerHTML = 
                '<div class="alert alert-warning">Camera access required for plant scanning</div>';
        }
    }
    
    closeScanner() {
        const scanner = document.getElementById('plant-scanner-container');
        if (scanner) {
            // Stop camera stream
            const video = document.getElementById('scanner-video');
            if (video.srcObject) {
                video.srcObject.getTracks().forEach(track => track.stop());
            }
            scanner.remove();
        }
    }
    
    identifyPlant(imageData) {
        // Simulate plant identification (in a real app, this would use ML)
        const plants = Object.keys(this.plantDatabase);
        const randomPlant = plants[Math.floor(Math.random() * plants.length)];
        return this.plantDatabase[randomPlant];
    }
    
    showPlantInfo(plantData) {
        const resultContainer = document.getElementById('scan-result');
        resultContainer.innerHTML = `
            <div class="plant-info-card">
                <div class="plant-header">
                    <img src="${plantData.icon}" alt="${plantData.name}" style="width: 60px; height: 60px;">
                    <div>
                        <h4>${plantData.name}</h4>
                        <p><em>${plantData.scientificName}</em></p>
                    </div>
                </div>
                <div class="plant-details">
                    <div class="detail-item">
                        <i class="fas fa-wind"></i>
                        <div>
                            <strong>CO2 Absorption</strong>
                            <p>${plantData.co2Absorption}</p>
                        </div>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-tint"></i>
                        <div>
                            <strong>Water Usage</strong>
                            <p>${plantData.waterUsage}</p>
                        </div>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-tree"></i>
                        <div>
                            <strong>Ecosystem</strong>
                            <p>${plantData.ecosystem}</p>
                        </div>
                    </div>
                </div>
                <div class="plant-facts">
                    <h5><i class="fas fa-lightbulb"></i> Did You Know?</h5>
                    <p>${plantData.facts}</p>
                </div>
                <button class="btn btn-success" onclick="arScanner.savePlantToCollection('${plantData.name}')">
                    <i class="fas fa-plus"></i> Add to My Collection
                </button>
            </div>
        `;
    }
    
    savePlantToCollection(plantName) {
        // In a real app, this would save to user's profile
        alert(`"${plantName}" added to your plant collection!`);
    }
}

class VREnvironmentalExperience {
    constructor() {
        this.isVRSupported = this.checkVRSupport();
        this.currentExperience = null;
    }
    
    checkVRSupport() {
        return 'xr' in navigator && navigator.xr.isSessionSupported('immersive-vr');
    }
    
    async startEcosystemTour() {
        if (!this.isVRSupported) {
            this.showVRFallback();
            return;
        }
        
        try {
            const session = await navigator.xr.requestSession('immersive-vr');
            this.setupVREnvironment(session);
        } catch (error) {
            console.log("VR not available, showing fallback experience");
            this.showVRFallback();
        }
    }
    
    showVRFallback() {
        // Create a 360-degree image viewer for ecosystem exploration
        const vrContainer = document.createElement('div');
        vrContainer.id = 'vr-experience-container';
        vrContainer.innerHTML = `
            <div class="vr-overlay">
                <h3><i class="fas fa-vr-cardboard"></i> Virtual Ecosystem Explorer</h3>
                <div class="vr-content">
                    <div class="vr-scene-selector">
                        <button class="vr-scene-btn" data-scene="rainforest">
                            <i class="fas fa-tree"></i>
                            <span>Rainforest</span>
                        </button>
                        <button class="vr-scene-btn" data-scene="coral-reef">
                            <i class="fas fa-water"></i>
                            <span>Coral Reef</span>
                        </button>
                        <button class="vr-scene-btn" data-scene="desert">
                            <i class="fas fa-sun"></i>
                            <span>Desert</span>
                        </button>
                        <button class="vr-scene-btn" data-scene="arctic">
                            <i class="fas fa-snowflake"></i>
                            <span>Arctic</span>
                        </button>
                    </div>
                    <div class="vr-scene-viewer">
                        <div id="scene-display">
                            <p>Select an ecosystem to explore</p>
                        </div>
                        <div class="vr-info-panel">
                            <h4 id="scene-title">Ecosystem Explorer</h4>
                            <p id="scene-description">Choose an ecosystem to learn about its unique features and environmental importance.</p>
                        </div>
                    </div>
                </div>
                <button id="close-vr" class="btn btn-danger"><i class="fas fa-times"></i> Close Experience</button>
            </div>
        `;
        
        document.body.appendChild(vrContainer);
        
        // Bind scene selection events
        document.querySelectorAll('.vr-scene-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const scene = e.target.closest('.vr-scene-btn').dataset.scene;
                this.loadScene(scene);
            });
        });
        
        // Bind close event
        document.getElementById('close-vr').addEventListener('click', () => {
            this.closeVRExperience();
        });
    }
    
    loadScene(sceneType) {
        const scenes = {
            "rainforest": {
                title: "Tropical Rainforest",
                description: "Rainforests are Earth's lungs, producing 20% of our oxygen. They house over 50% of the world's species despite covering only 6% of Earth's surface. Experience the biodiversity hotspot where every tree supports thousands of species.",
                image: "https://images.unsplash.com/photo-1542601906934-44b5d4d5c7d9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
            },
            "coral-reef": {
                title: "Coral Reef",
                description: "Coral reefs are the rainforests of the sea, supporting 25% of all marine life. Despite covering less than 1% of the ocean floor, they are home to over 4,000 fish species. Discover the colorful underwater world that's dying at an alarming rate due to climate change.",
                image: "https://images.unsplash.com/photo-1542601906934-44b5d4d5c7d9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
            },
            "desert": {
                title: "Desert Ecosystem",
                description: "Deserts cover 33% of Earth's land surface and are home to unique adaptations. From cacti storing water to camels surviving without it, these ecosystems showcase life's resilience. Learn how desert plants and animals thrive in extreme conditions.",
                image: "https://images.unsplash.com/photo-1509294215294-610ef6f9f49d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
            },
            "arctic": {
                title: "Arctic Tundra",
                description: "The Arctic is warming twice as fast as the global average. Witness the fragile ecosystem of polar bears, Arctic foxes, and migratory birds. Understand how melting ice affects global sea levels and weather patterns.",
                image: "https://images.unsplash.com/photo-1518839992394-8a3d1d1e0fbc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
            }
        };
        
        const scene = scenes[sceneType];
        if (scene) {
            document.getElementById('scene-title').textContent = scene.title;
            document.getElementById('scene-description').textContent = scene.description;
            document.getElementById('scene-display').innerHTML = 
                `<img src="${scene.image}" alt="${scene.title}" style="width: 100%; border-radius: 10px;">`;
        }
    }
    
    closeVRExperience() {
        const vrContainer = document.getElementById('vr-experience-container');
        if (vrContainer) {
            vrContainer.remove();
        }
    }
}

class AIPersonalizedLearning {
    constructor() {
        this.userProfile = this.loadUserProfile();
        this.recommendations = [];
    }
    
    loadUserProfile() {
        // In a real app, this would come from the backend
        return {
            interests: ["biodiversity", "climate change", "renewable energy"],
            completedChallenges: ["plastic-free week", "green commute"],
            preferredLearningStyle: "visual",
            progress: {
                lessonsCompleted: 8,
                totalPoints: 1250,
                currentLevel: "Sprout"
            }
        };
    }
    
    generateRecommendations() {
        // Generate personalized recommendations based on user profile
        const allContent = [
            {
                id: "renewable-energy",
                title: "Renewable Energy Sources",
                type: "lesson",
                points: 100,
                difficulty: "beginner",
                tags: ["energy", "renewable", "sustainability"]
            },
            {
                id: "biodiversity-hotspots",
                title: "Biodiversity Hotspots",
                type: "lesson",
                points: 150,
                difficulty: "intermediate",
                tags: ["biodiversity", "conservation", "ecosystem"]
            },
            {
                id: "carbon-footprint",
                title: "Calculate Your Carbon Footprint",
                type: "challenge",
                points: 75,
                difficulty: "beginner",
                tags: ["carbon", "footprint", "measurement"]
            },
            {
                id: "sustainable-gardening",
                title: "Sustainable Gardening Practices",
                type: "challenge",
                points: 120,
                difficulty: "intermediate",
                tags: ["gardening", "sustainability", "local"]
            },
            {
                id: "ocean-conservation",
                title: "Ocean Conservation",
                type: "game",
                points: 200,
                difficulty: "advanced",
                tags: ["ocean", "marine", "pollution"]
            }
        ];
        
        // Filter and score content based on user interests
        this.recommendations = allContent
            .map(content => {
                // Calculate relevance score
                let score = 0;
                
                // Score based on user interests
                this.userProfile.interests.forEach(interest => {
                    if (content.tags.includes(interest)) {
                        score += 3;
                    }
                });
                
                // Score based on completed challenges
                this.userProfile.completedChallenges.forEach(challenge => {
                    if (content.tags.some(tag => challenge.includes(tag))) {
                        score += 2;
                    }
                });
                
                // Adjust for difficulty based on progress
                if (content.difficulty === "beginner" && this.userProfile.progress.lessonsCompleted < 5) {
                    score += 2;
                } else if (content.difficulty === "intermediate" && this.userProfile.progress.lessonsCompleted >= 5) {
                    score += 2;
                } else if (content.difficulty === "advanced" && this.userProfile.progress.lessonsCompleted >= 10) {
                    score += 2;
                }
                
                return { ...content, relevanceScore: score };
            })
            .sort((a, b) => b.relevanceScore - a.relevanceScore)
            .slice(0, 3); // Top 3 recommendations
        
        return this.recommendations;
    }
    
    displayRecommendations() {
        const recommendations = this.generateRecommendations();
        const container = document.getElementById('ai-recommendations-container');
        
        if (container) {
            container.innerHTML = `
                <div class="recommendations-header">
                    <h3><i class="fas fa-robot"></i> Personalized Recommendations</h3>
                    <p>Based on your interests and progress</p>
                </div>
                <div class="recommendations-grid">
                    ${recommendations.map(rec => `
                        <div class="recommendation-card">
                            <div class="rec-icon">
                                ${rec.type === 'lesson' ? '<i class="fas fa-graduation-cap"></i>' : 
                                  rec.type === 'challenge' ? '<i class="fas fa-leaf"></i>' : 
                                  '<i class="fas fa-gamepad"></i>'}
                            </div>
                            <div class="rec-content">
                                <h5>${rec.title}</h5>
                                <div class="rec-meta">
                                    <span class="points"><i class="fas fa-coins"></i> ${rec.points} pts</span>
                                    <span class="difficulty">${rec.difficulty}</span>
                                </div>
                                <button class="btn btn-primary btn-sm" onclick="aiLearning.startContent('${rec.id}')">
                                    Start ${rec.type === 'lesson' ? 'Lesson' : rec.type === 'challenge' ? 'Challenge' : 'Game'}
                                </button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            `;
        }
    }
    
    startContent(contentId) {
        // In a real app, this would navigate to the content
        alert(`Starting content: ${contentId}`);
    }
}

// Initialize features when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Make instances globally accessible
    window.arScanner = new AREnvironmentalScanner();
    window.vrExperience = new VREnvironmentalExperience();
    window.aiLearning = new AIPersonalizedLearning();
    
    // Add CSS for the new features
    const featureStyles = document.createElement('style');
    featureStyles.textContent = `
        /* AR/VR Feature Styles */
        #plant-scanner-container, #vr-experience-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            z-index: 10000;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .scanner-overlay, .vr-overlay {
            background: white;
            border-radius: 15px;
            padding: 20px;
            max-width: 90%;
            max-height: 90%;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .scanner-overlay h3, .vr-overlay h3 {
            margin-top: 0;
            color: #27ae60;
            text-align: center;
        }
        
        .scan-result {
            margin: 15px 0;
        }
        
        .plant-info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .plant-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .plant-details {
            display: grid;
            grid-template-columns: 1fr;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .detail-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .detail-item i {
            color: #27ae60;
            font-size: 1.2em;
            margin-top: 3px;
        }
        
        .plant-facts {
            background: #e8f5e9;
            border-radius: 8px;
            padding: 10px;
            margin: 15px 0;
        }
        
        .vr-content {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .vr-scene-selector {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        
        .vr-scene-btn {
            background: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .vr-scene-btn:hover {
            background: #2980b9;
            transform: translateY(-3px);
        }
        
        .vr-scene-viewer {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            min-height: 300px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .vr-info-panel h4 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        /* AI Recommendations Styles */
        #ai-recommendations-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .recommendations-header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .recommendations-header h3 {
            color: #27ae60;
            margin-bottom: 5px;
        }
        
        .recommendations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .recommendation-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            gap: 15px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        
        .recommendation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .rec-icon {
            font-size: 2em;
            color: #3498db;
            display: flex;
            align-items: center;
        }
        
        .rec-content h5 {
            margin: 0 0 10px 0;
            color: #2c3e50;
        }
        
        .rec-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 0.9em;
        }
        
        .points {
            color: #f39c12;
        }
        
        .difficulty {
            background: #e9ecef;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 0.8em;
        }
        
        @media (max-width: 768px) {
            .recommendations-grid {
                grid-template-columns: 1fr;
            }
            
            .recommendation-card {
                flex-direction: column;
                text-align: center;
            }
            
            .vr-scene-selector {
                flex-direction: column;
            }
        }
    `;
    document.head.appendChild(featureStyles);
});

// Global functions for HTML integration
function launchARPlantScanner() {
    if (window.arScanner) {
        window.arScanner.startPlantScan();
    }
}

function launchVREcosystemTour() {
    if (window.vrExperience) {
        window.vrExperience.startEcosystemTour();
    }
}

function loadAIRecommendations() {
    if (window.aiLearning) {
        window.aiLearning.displayRecommendations();
    }
}