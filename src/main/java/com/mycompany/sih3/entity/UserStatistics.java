package com.mycompany.sih3.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "user_statistics")
public class UserStatistics implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    
    @Column(name = "user_id", nullable = false)
    private Integer userId;
    
    @Column(name = "total_points")
    private Integer totalPoints;
    
    @Column(name = "lessons_completed")
    private Integer lessonsCompleted;
    
    @Column(name = "challenges_completed")
    private Integer challengesCompleted;
    
    @Column(name = "games_played")
    private Integer gamesPlayed;
    
    @Column(name = "current_streak")
    private Integer currentStreak;
    
    @Column(name = "current_level", length = 50)
    private String currentLevel;
    
    @Column(name = "level_progress")
    private Integer levelProgress;
    
    @Column(name = "level_target")
    private Integer levelTarget;
    
    @Column(name = "school_rank")
    private Integer schoolRank;
    
    @Column(name = "global_rank")
    private Integer globalRank;
    
    @Column(name = "points_from_lessons")
    private Integer pointsFromLessons;
    
    @Column(name = "points_from_challenges")
    private Integer pointsFromChallenges;
    
    @Column(name = "points_from_games")
    private Integer pointsFromGames;
    
    @Column(name = "points_from_bonus")
    private Integer pointsFromBonus;
    
    // Constructors
    public UserStatistics() {
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getTotalPoints() {
        return totalPoints;
    }
    
    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }
    
    public Integer getLessonsCompleted() {
        return lessonsCompleted;
    }
    
    public void setLessonsCompleted(Integer lessonsCompleted) {
        this.lessonsCompleted = lessonsCompleted;
    }
    
    public Integer getChallengesCompleted() {
        return challengesCompleted;
    }
    
    public void setChallengesCompleted(Integer challengesCompleted) {
        this.challengesCompleted = challengesCompleted;
    }
    
    public Integer getGamesPlayed() {
        return gamesPlayed;
    }
    
    public void setGamesPlayed(Integer gamesPlayed) {
        this.gamesPlayed = gamesPlayed;
    }
    
    public Integer getCurrentStreak() {
        return currentStreak;
    }
    
    public void setCurrentStreak(Integer currentStreak) {
        this.currentStreak = currentStreak;
    }
    
    public String getCurrentLevel() {
        return currentLevel;
    }
    
    public void setCurrentLevel(String currentLevel) {
        this.currentLevel = currentLevel;
    }
    
    public Integer getLevelProgress() {
        return levelProgress;
    }
    
    public void setLevelProgress(Integer levelProgress) {
        this.levelProgress = levelProgress;
    }
    
    public Integer getLevelTarget() {
        return levelTarget;
    }
    
    public void setLevelTarget(Integer levelTarget) {
        this.levelTarget = levelTarget;
    }
    
    public Integer getSchoolRank() {
        return schoolRank;
    }
    
    public void setSchoolRank(Integer schoolRank) {
        this.schoolRank = schoolRank;
    }
    
    public Integer getGlobalRank() {
        return globalRank;
    }
    
    public void setGlobalRank(Integer globalRank) {
        this.globalRank = globalRank;
    }
    
    public Integer getPointsFromLessons() {
        return pointsFromLessons;
    }
    
    public void setPointsFromLessons(Integer pointsFromLessons) {
        this.pointsFromLessons = pointsFromLessons;
    }
    
    public Integer getPointsFromChallenges() {
        return pointsFromChallenges;
    }
    
    public void setPointsFromChallenges(Integer pointsFromChallenges) {
        this.pointsFromChallenges = pointsFromChallenges;
    }
    
    public Integer getPointsFromGames() {
        return pointsFromGames;
    }
    
    public void setPointsFromGames(Integer pointsFromGames) {
        this.pointsFromGames = pointsFromGames;
    }
    
    public Integer getPointsFromBonus() {
        return pointsFromBonus;
    }
    
    public void setPointsFromBonus(Integer pointsFromBonus) {
        this.pointsFromBonus = pointsFromBonus;
    }
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }
    
    @Override
    public boolean equals(Object object) {
        if (!(object instanceof UserStatistics)) {
            return false;
        }
        UserStatistics other = (UserStatistics) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }
    
    @Override
    public String toString() {
        return "com.mycompany.sih3.entity.UserStatistics[ id=" + id + " ]";
    }
}