/**
 * Activity Logger - Utility to log user activities
 */

// Function to log activity
function logActivity(activityType, title, description, points) {
    // Create form data
    const formData = new FormData();
    formData.append('type', activityType);
    formData.append('title', title);
    formData.append('description', description || '');
    formData.append('points', points || 0);
    
    // Send request to log activity
    fetch('log-user-activity.jsp', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            console.log('Activity logged successfully:', title);
        } else {
            console.error('Failed to log activity:', data.message);
        }
    })
    .catch(error => {
        console.error('Error logging activity:', error);
    });
}

// Function to log lesson completion
function logLessonCompletion(lessonTitle, points) {
    logActivity('lesson', 'Finished Lesson: ' + lessonTitle, 'Completed the ' + lessonTitle + ' lesson', points);
}

// Function to log challenge completion
function logChallengeCompletion(challengeTitle, points) {
    logActivity('challenge', 'Completed Challenge: ' + challengeTitle, 'Completed the ' + challengeTitle + ' challenge', points);
}

// Function to log game completion
function logGameCompletion(gameTitle, points) {
    logActivity('game', 'Completed Game: ' + gameTitle, 'Completed the ' + gameTitle + ' game', points);
}

// Function to log achievement unlock
function logAchievementUnlock(achievementTitle, points) {
    logActivity('achievement', 'Unlocked Achievement: ' + achievementTitle, 'Unlocked the ' + achievementTitle + ' achievement', points);
}

// Export functions for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        logActivity: logActivity,
        logLessonCompletion: logLessonCompletion,
        logChallengeCompletion: logChallengeCompletion,
        logGameCompletion: logGameCompletion,
        logAchievementUnlock: logAchievementUnlock
    };
}