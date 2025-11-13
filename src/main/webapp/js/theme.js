/**
 * Advanced Theme Manager for EcoLearn Platform
 * Applies user-selected themes across the website with per-page theme support for Mixable option
 */

// Function to apply theme to the page
function applyTheme(themeName) {
    // Update CSS variables based on theme
    const root = document.documentElement;
    
    switch(themeName) {
        case 'Eco Green':
            root.style.setProperty('--primary-teal', '#1abc9c');
            root.style.setProperty('--secondary-cyan', '#17a2b8');
            root.style.setProperty('--accent-green', '#20c997');
            // Update navbar if it exists
            const navbar = document.querySelector('.navbar');
            if (navbar) {
                navbar.style.background = 'linear-gradient(135deg, #1abc9c, #17a2b8)';
                navbar.style.setProperty('background', 'linear-gradient(135deg, #1abc9c, #17a2b8) !important', 'important');
            }
            // Update page header if it exists
            const pageHeader = document.querySelector('.page-header');
            if (pageHeader) {
                pageHeader.style.background = 'linear-gradient(135deg, #1abc9c, #17a2b8)';
            }
            break;
        case 'Ocean Blue':
            root.style.setProperty('--primary-teal', '#3498db');
            root.style.setProperty('--secondary-cyan', '#2c3e50');
            root.style.setProperty('--accent-green', '#3498db');
            // Update navbar if it exists
            const navbar2 = document.querySelector('.navbar');
            if (navbar2) {
                navbar2.style.background = 'linear-gradient(135deg, #3498db, #2c3e50)';
                navbar2.style.setProperty('background', 'linear-gradient(135deg, #3498db, #2c3e50) !important', 'important');
            }
            // Update page header if it exists
            const pageHeader2 = document.querySelector('.page-header');
            if (pageHeader2) {
                pageHeader2.style.background = 'linear-gradient(135deg, #3498db, #2c3e50)';
            }
            break;
        case 'Sunset Red':
            root.style.setProperty('--primary-teal', '#e74c3c');
            root.style.setProperty('--secondary-cyan', '#c0392b');
            root.style.setProperty('--accent-green', '#e74c3c');
            // Update navbar if it exists
            const navbar3 = document.querySelector('.navbar');
            if (navbar3) {
                navbar3.style.background = 'linear-gradient(135deg, #e74c3c, #c0392b)';
                navbar3.style.setProperty('background', 'linear-gradient(135deg, #e74c3c, #c0392b) !important', 'important');
            }
            // Update page header if it exists
            const pageHeader3 = document.querySelector('.page-header');
            if (pageHeader3) {
                pageHeader3.style.background = 'linear-gradient(135deg, #e74c3c, #c0392b)';
            }
            break;
        case 'Purple Haze':
            root.style.setProperty('--primary-teal', '#9b59b6');
            root.style.setProperty('--secondary-cyan', '#8e44ad');
            root.style.setProperty('--accent-green', '#9b59b6');
            // Update navbar if it exists
            const navbar4 = document.querySelector('.navbar');
            if (navbar4) {
                navbar4.style.background = 'linear-gradient(135deg, #9b59b6, #8e44ad)';
                navbar4.style.setProperty('background', 'linear-gradient(135deg, #9b59b6, #8e44ad) !important', 'important');
            }
            // Update page header if it exists
            const pageHeader4 = document.querySelector('.page-header');
            if (pageHeader4) {
                pageHeader4.style.background = 'linear-gradient(135deg, #9b59b6, #8e44ad)';
            }
            break;
        case 'Mixable':
            // For Mixable, get a theme based on the current page
            const pageSpecificTheme = getPageSpecificTheme();
            applyTheme(pageSpecificTheme);
            break;
        default:
            // Default to Eco Green if unknown theme
            root.style.setProperty('--primary-teal', '#1abc9c');
            root.style.setProperty('--secondary-cyan', '#17a2b8');
            root.style.setProperty('--accent-green', '#20c997');
            // Update navbar if it exists
            const navbar5 = document.querySelector('.navbar');
            if (navbar5) {
                navbar5.style.background = 'linear-gradient(135deg, #1abc9c, #17a2b8)';
                navbar5.style.setProperty('background', 'linear-gradient(135deg, #1abc9c, #17a2b8) !important', 'important');
            }
            // Update page header if it exists
            const pageHeader5 = document.querySelector('.page-header');
            if (pageHeader5) {
                pageHeader5.style.background = 'linear-gradient(135deg, #1abc9c, #17a2b8)';
            }
            break;
    }
}

// Function to get a page-specific theme for Mixable option
function getPageSpecificTheme() {
    // Get current page identifier
    const pageId = getCurrentPageId();
    
    // Check if we have a saved theme for this page
    let savedPageTheme = localStorage.getItem('pageTheme_' + pageId);
    if (savedPageTheme) {
        return savedPageTheme;
    }
    
    // If not, generate a theme based on the page ID
    const themes = ['Eco Green', 'Ocean Blue', 'Sunset Red', 'Purple Haze'];
    const pageHash = hashString(pageId);
    const themeIndex = pageHash % themes.length;
    const selectedTheme = themes[themeIndex];
    
    // Save this theme for this page
    localStorage.setItem('pageTheme_' + pageId, selectedTheme);
    
    return selectedTheme;
}

// Simple hash function for string
function hashString(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
        const char = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash = hash & hash; // Convert to 32-bit integer
    }
    return Math.abs(hash);
}

// Function to get current page identifier
function getCurrentPageId() {
    // Use the current page URL as identifier
    return window.location.pathname;
}

// Function to load and apply saved theme
function loadSavedTheme() {
    // Check if we're on the index page
    if (window.location.pathname === '/SIH3/' || window.location.pathname === '/SIH3/index.jsp' || window.location.pathname === '/') {
        // Don't apply theme to index page
        return;
    }
    
    // Try to get global theme from localStorage
    let savedTheme = localStorage.getItem('selectedTheme');
    
    if (savedTheme) {
        applyTheme(savedTheme);
    } else {
        // Default to Eco Green if no theme is saved
        applyTheme('Eco Green');
    }
}

// Function to clear all page-specific themes (useful when changing from Mixable to another theme)
function clearPageThemes() {
    for(let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key && key.startsWith('pageTheme_')) {
            localStorage.removeItem(key);
        }
    }
}

// Apply theme when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    loadSavedTheme();
});

// Export functions for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        applyTheme: applyTheme,
        loadSavedTheme: loadSavedTheme,
        clearPageThemes: clearPageThemes
    };
}