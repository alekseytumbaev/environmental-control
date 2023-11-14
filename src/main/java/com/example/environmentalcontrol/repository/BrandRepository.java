package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Brand;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BrandRepository extends JpaRepository<Brand, Integer> {
}
