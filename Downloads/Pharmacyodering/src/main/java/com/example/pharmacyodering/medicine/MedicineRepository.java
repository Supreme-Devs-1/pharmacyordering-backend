package com.example.pharmacyodering.medicine;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    List<Medicine> findByCategory(String category);
    List<Medicine> findByNameContainingIgnoreCase(String name);
}

