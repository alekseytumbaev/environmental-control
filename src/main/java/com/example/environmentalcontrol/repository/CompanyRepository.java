package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CompanyRepository extends JpaRepository<Company, Integer> {
}
