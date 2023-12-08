package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Incident;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IncidentRepository extends JpaRepository<Incident, Integer> {

    /**
     * Получить информацию о всех превышениях норм в компании
     * @param id id компании
     */
    List<Incident> findAllByCompany_Id(Integer id);
}
