// Eco Sorting Challenge Game
// A simple game where players sort waste items into the correct recycling bins

class EcoSortingGame {
    constructor() {
        this.score = 0;
        this.timeLeft = 60; // 60 seconds
        this.gameActive = false;
        this.currentItem = null;
        this.wasteItems = [
            { name: "Plastic Bottle", type: "plastic", icon: "https://cdn-icons-png.flaticon.com/512/167/167728.png" },
            { name: "Newspaper", type: "paper", icon: "https://cdn-icons-png.flaticon.com/512/167/167784.png" },
            { name: "Apple Core", type: "organic", icon: "https://cdn-icons-png.flaticon.com/512/167/167762.png" },
            { name: "Glass Jar", type: "glass", icon: "https://cdn-icons-png.flaticon.com/512/167/167755.png" },
            { name: "Aluminum Can", type: "metal", icon: "https://cdn-icons-png.flaticon.com/512/167/167735.png" },
            { name: "Cardboard Box", type: "paper", icon: "https://cdn-icons-png.flaticon.com/512/167/167790.png" },
            { name: "Banana Peel", type: "organic", icon: "https://cdn-icons-png.flaticon.com/512/167/167760.png" },
            { name: "Plastic Bag", type: "plastic", icon: "https://cdn-icons-png.flaticon.com/512/167/167730.png" },
            { name: "Steel Can", type: "metal", icon: "https://cdn-icons-png.flaticon.com/512/167/167740.png" },
            { name: "Wine Bottle", type: "glass", icon: "https://cdn-icons-png.flaticon.com/512/167/167750.png" }
        ];
        this.bins = [
            { type: "plastic", name: "Plastic", color: "#3498db" },
            { type: "paper", name: "Paper", color: "#f1c40f" },
            { type: "organic", name: "Organic", color: "#27ae60" },
            { type: "glass", name: "Glass", color: "#9b59b6" },
            { type: "metal", name: "Metal", color: "#e67e22" }
        ];
        
        this.init();
    }
    
    init() {
        this.createGameElements();
        this.bindEvents();
    }
    
    createGameElements() {
        // Create game container if it doesn't exist
        if (!document.getElementById('eco-game-container')) {
            const gameContainer = document.createElement('div');
            gameContainer.id = 'eco-game-container';
            document.body.appendChild(gameContainer);
        }
        
        this.renderGameInterface();
    }
    
    renderGameInterface() {
        const container = document.getElementById('eco-game-container');
        container.innerHTML = `
            <div class="game-content-wrapper">
                <h2 class="eco-game-title"><img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Recycle" style="width: 30px; height: 30px; vertical-align: middle; margin: 0 10px;"> Eco Sorting Challenge <img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Recycle" style="width: 30px; height: 30px; vertical-align: middle; margin: 0 10px;"></h2>
                <p class="eco-game-description">
                    Sort waste items into the correct recycling bins as quickly as possible!
                </p>
                
                <div class="game-stats-container">
                    <div class="stat-box">
                        <div class="stat-value">${this.score}</div>
                        <div class="stat-label">Score</div>
                    </div>
                    
                    <div class="stat-box">
                        <div class="stat-value">${this.timeLeft}s</div>
                        <div class="stat-label">Time Left</div>
                    </div>
                </div>
                
                <div id="game-item" class="game-item-container">
                    <div class="item-icon">${this.currentItem ? `<img src="${this.currentItem.icon}" alt="${this.currentItem.name}" style="width: 100px; height: 100px; object-fit: contain;">` : '<img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Refresh" style="width: 80px; height: 80px; opacity: 0.7;">'}</div>
                    <div class="item-name">
                        ${this.currentItem ? this.currentItem.name : 'Ready to start?'}
                    </div>
                </div>
                
                <div id="bins-container" class="bins-container">
                    ${this.bins.map(bin => `
                        <div class="bin" data-type="${bin.type}" style="background: ${bin.color};">
                            <div class="bin-icon">${this.getBinIcon(bin.type)}</div>
                            <div class="bin-name">${bin.name}</div>
                        </div>
                    `).join('')}
                </div>
                
                <div id="game-controls" class="game-controls">
                    <button id="start-game" class="start-button">
                        ${this.gameActive ? 'Restart Game' : 'Start Game'}
                    </button>
                </div>
                
                <div id="game-result" class="game-result"></div>
            </div>
        `;
    }
    
    getBinIcon(type) {
        const icons = {
            plastic: "https://cdn-icons-png.flaticon.com/512/167/167728.png",
            paper: "https://cdn-icons-png.flaticon.com/512/167/167784.png",
            organic: "https://cdn-icons-png.flaticon.com/512/167/167762.png",
            glass: "https://cdn-icons-png.flaticon.com/512/167/167755.png",
            metal: "https://cdn-icons-png.flaticon.com/512/167/167735.png"
        };
        return icons[type] ? `<img src="${icons[type]}" alt="${type}" style="width: 40px; height: 40px; object-fit: contain;">` : "♻️";
    }
    
    bindEvents() {
        document.addEventListener('click', (e) => {
            if (e.target.id === 'start-game') {
                this.startGame();
            }
            
            if (e.target.classList.contains('bin')) {
                if (this.gameActive && this.currentItem) {
                    this.checkAnswer(e.target.dataset.type);
                }
            }
        });
    }
    
    startGame() {
        this.score = 0;
        this.timeLeft = 60;
        this.gameActive = true;
        this.renderGameInterface();
        
        this.nextItem();
        this.startTimer();
    }
    
    startTimer() {
        const timer = setInterval(() => {
            if (this.gameActive) {
                this.timeLeft--;
                this.renderGameInterface();
                
                if (this.timeLeft <= 0) {
                    this.endGame();
                    clearInterval(timer);
                }
            } else {
                clearInterval(timer);
            }
        }, 1000);
    }
    
    nextItem() {
        if (!this.gameActive) return;
        
        const randomIndex = Math.floor(Math.random() * this.wasteItems.length);
        this.currentItem = this.wasteItems[randomIndex];
        this.renderGameInterface();
    }
    
    checkAnswer(selectedBin) {
        if (!this.currentItem) return;
        
        const isCorrect = selectedBin === this.currentItem.type;
        
        if (isCorrect) {
            this.score += 10;
            this.showResult(`<img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Correct" style="width: 20px; height: 20px; vertical-align: middle;"> Correct! +10 points`, '#27ae60');
        } else {
            this.score = Math.max(0, this.score - 5);
            this.showResult(`<img src="https://cdn-icons-png.flaticon.com/512/167/167730.png" alt="Wrong" style="width: 20px; height: 20px; vertical-align: middle;"> Wrong! It was ${this.currentItem.type}. -5 points`, '#e74c3c');
        }
        
        // Move to next item after a delay
        setTimeout(() => {
            this.nextItem();
        }, 1000);
    }
    
    showResult(message, color) {
        const resultElement = document.getElementById('game-result');
        if (resultElement) {
            const className = color === '#27ae60' ? 'correct' : 'incorrect';
            resultElement.innerHTML = `<div class="result-message ${className}">${message}</div>`;
        }
    }
    
    endGame() {
        this.gameActive = false;
        this.currentItem = null;
        this.renderGameInterface();
        
        const resultElement = document.getElementById('game-result');
        if (resultElement) {
            resultElement.innerHTML = `
                <div class="game-over">
                    <h3><img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Game" style="width: 30px; height: 30px; vertical-align: middle; margin: 0 10px;"> Game Over! <img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Game" style="width: 30px; height: 30px; vertical-align: middle; margin: 0 10px;"></h3>
                    <p class="final-score">Final Score: <strong>${this.score}</strong></p>
                    <p class="score-message">${this.getScoreMessage()}</p>
                </div>
            `;
        }
    }
    
    getScoreMessage() {
        if (this.score >= 100) return `<img src="https://cdn-icons-png.flaticon.com/512/167/167755.png" alt="Earth" style="width: 20px; height: 20px; vertical-align: middle;"> Eco Hero! You're saving the planet!`;
        if (this.score >= 70) return `<img src="https://cdn-icons-png.flaticon.com/512/167/167762.png" alt="Sprout" style="width: 20px; height: 20px; vertical-align: middle;"> Great job! You're making a difference!`;
        if (this.score >= 40) return `<img src="https://cdn-icons-png.flaticon.com/512/167/167728.png" alt="Recycle" style="width: 20px; height: 20px; vertical-align: middle;"> Good effort! Keep learning!`;
        return `<img src="https://cdn-icons-png.flaticon.com/512/167/167790.png" alt="Book" style="width: 20px; height: 20px; vertical-align: middle;"> Keep practicing to become an eco expert!`;
    }
    
    show() {
        const container = document.getElementById('eco-game-container');
        if (container) {
            container.style.display = 'block';
        }
    }
    
    hide() {
        const container = document.getElementById('eco-game-container');
        if (container) {
            container.style.display = 'none';
        }
    }
}

// Initialize the game when the page loads
document.addEventListener('DOMContentLoaded', function() {
    // Create game instance
    window.ecoGame = new EcoSortingGame();
    
    // Add CSS for the game
    const gameStyle = document.createElement('style');
    gameStyle.textContent = `
        .bin:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2) !important;
        }
        
        #start-game:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    `;
    document.head.appendChild(gameStyle);
});

// Function to launch the game from the games page
function launchEcoSortingGame() {
    // Hide the games grid and show the game
    const gamesGrid = document.querySelector('.row');
    if (gamesGrid) {
        gamesGrid.style.display = 'none';
    }
    
    // Show the game
    if (window.ecoGame) {
        window.ecoGame.show();
    }
    
    // Scroll to game
    document.getElementById('eco-game-container').scrollIntoView({ behavior: 'smooth' });
}