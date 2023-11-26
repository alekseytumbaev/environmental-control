package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.ResponsibleSotrud;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import java.util.List;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class ResponsibleSotrudRepositoryTest {

    @Autowired
    TestEntityManager tem;

    @Autowired
    ResponsibleSotrudRepository responsibleSotrudRepo;

    @Test
    void testFindEmployeesWithPollutionInWaterOrAir() {
        List<ResponsibleSotrud> employees = responsibleSotrudRepo.findEmployeesWithPollutionInWaterOrAir();
        employees.forEach(System.out::println);
    }

}