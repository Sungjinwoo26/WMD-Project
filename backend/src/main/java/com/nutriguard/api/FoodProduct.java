package com.nutriguard.api;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class FoodProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String category;
    private double sugar;
    private double sodium;
    private double fat;
    private String riskLevel;

    public FoodProduct() { }

    public FoodProduct(String name, String category, double sugar, double sodium, double fat, String riskLevel) {
        this.name = name;
        this.category = category;
        this.sugar = sugar;
        this.sodium = sodium;
        this.fat = fat;
        this.riskLevel = riskLevel;
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public double getSugar() { return sugar; }
    public void setSugar(double sugar) { this.sugar = sugar; }
    public double getSodium() { return sodium; }
    public void setSodium(double sodium) { this.sodium = sodium; }
    public double getFat() { return fat; }
    public void setFat(double fat) { this.fat = fat; }
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
}
