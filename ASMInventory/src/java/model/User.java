package com.inventory.model;

import java.time.LocalDateTime;

public class User {

    private int id;
    private String username;
    private String password;
    private String role;          // "ADMIN" | "STAFF"
    private LocalDateTime createdAt;

    public User() {
    }

    public User(int id, String username, String password, String role, LocalDateTime createdAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.createdAt = createdAt;
    }

    // ---------- Getters ----------
    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    // ---------- Setters ----------
    public void setId(int id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }

    public boolean isStaff() {
        return "STAFF".equalsIgnoreCase(role);
    }
}
