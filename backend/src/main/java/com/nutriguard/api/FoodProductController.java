package com.nutriguard.api;

import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/foods")
@CrossOrigin
public class FoodProductController {
    private final FoodProductRepository repository;

    public FoodProductController(FoodProductRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<FoodProduct> getAll() { return repository.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<FoodProduct> getOne(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<FoodProduct> create(@RequestBody FoodProduct food) {
        food.setRiskLevel(calculateRisk(food));
        return ResponseEntity.status(201).body(repository.save(food));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FoodProduct> update(@PathVariable Long id, @RequestBody FoodProduct input) {
        return repository.findById(id).map(food -> {
            food.setName(input.getName());
            food.setCategory(input.getCategory());
            food.setSugar(input.getSugar());
            food.setSodium(input.getSodium());
            food.setFat(input.getFat());
            food.setRiskLevel(calculateRisk(food));
            return ResponseEntity.ok(repository.save(food));
        }).orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}")
    public ResponseEntity<FoodProduct> patchRisk(@PathVariable Long id, @RequestBody FoodProduct input) {
        return repository.findById(id).map(food -> {
            food.setRiskLevel(input.getRiskLevel());
            return ResponseEntity.ok(repository.save(food));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repository.existsById(id)) return ResponseEntity.notFound().build();
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private String calculateRisk(FoodProduct food) {
        if (food.getSugar() > 12 || food.getSodium() > 450 || food.getFat() > 20) return "High Risk";
        if (food.getSugar() > 6 || food.getSodium() > 300 || food.getFat() > 12) return "Moderate Risk";
        return "Low Risk";
    }
}
