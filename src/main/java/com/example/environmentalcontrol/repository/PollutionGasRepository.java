package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.PollutionGas;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PollutionGasRepository extends JpaRepository<PollutionGas, Integer> {
}
