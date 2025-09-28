package com.mycompany.sih3.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_achievements")
public class UserAchievement implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    
    @Column(name = "user_id", nullable = false)
    private Integer userId;
    
    @Column(name = "achievement_id", nullable = false)
    private Integer achievementId;
    
    @Column(name = "unlocked_at")
    private LocalDateTime unlockedAt;
    
    @Column(name = "points_earned")
    private Integer pointsEarned;
    
    // Constructors
    public UserAchievement() {
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
    
    public Integer getAchievementId() {
        return achievementId;
    }
    
    public void setAchievementId(Integer achievementId) {
        this.achievementId = achievementId;
    }
    
    public LocalDateTime getUnlockedAt() {
        return unlockedAt;
    }
    
    public void setUnlockedAt(LocalDateTime unlockedAt) {
        this.unlockedAt = unlockedAt;
    }
    
    public Integer getPointsEarned() {
        return pointsEarned;
    }
    
    public void setPointsEarned(Integer pointsEarned) {
        this.pointsEarned = pointsEarned;
    }
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }
    
    @Override
    public boolean equals(Object object) {
        if (!(object instanceof UserAchievement)) {
            return false;
        }
        UserAchievement other = (UserAchievement) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }
    
    @Override
    public String toString() {
        return "com.mycompany.sih3.entity.UserAchievement[ id=" + id + " ]";
    }
}