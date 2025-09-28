package com.mycompany.sih3.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_games")
public class UserGame implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    
    @Column(name = "user_id", nullable = false)
    private Integer userId;
    
    @Column(name = "game_id", nullable = false)
    private Integer gameId;
    
    @Column(name = "played_at")
    private LocalDateTime playedAt;
    
    @Column(name = "points_earned")
    private Integer pointsEarned;
    
    // Constructors
    public UserGame() {
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
    
    public Integer getGameId() {
        return gameId;
    }
    
    public void setGameId(Integer gameId) {
        this.gameId = gameId;
    }
    
    public LocalDateTime getPlayedAt() {
        return playedAt;
    }
    
    public void setPlayedAt(LocalDateTime playedAt) {
        this.playedAt = playedAt;
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
        if (!(object instanceof UserGame)) {
            return false;
        }
        UserGame other = (UserGame) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }
    
    @Override
    public String toString() {
        return "com.mycompany.sih3.entity.UserGame[ id=" + id + " ]";
    }
}