package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Founder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FounderRepository extends JpaRepository<Founder, Integer> {

    /**
     * Находит руководителя компании по ее id.
     * @param companyId id компании, руководителя которой нужно найти
     * @return руководитель компании
     */
    Founder findByCompany_Id(Integer companyId);
}
