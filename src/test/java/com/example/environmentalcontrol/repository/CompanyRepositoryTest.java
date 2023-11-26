package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Company;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.Date;
import java.util.List;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class CompanyRepositoryTest {

    @Autowired
    CompanyRepository companyRepo;

    @Test
    void testFindCompaniesWithExcessiveAirPollution() {
        List<Company> companies = companyRepo.findCompaniesWithExcessiveAirPollution();
        companies.forEach(System.out::println);
    }

    @Test
    void testFindCompaniesWithExcessiveWaterPollution() {
        List<Company> companies = companyRepo.findCompaniesWithExcessiveWaterPollution();
        companies.forEach(System.out::println);
    }

    @Test
    void testFindCompaniesByEmittedGasesId() {
        List<Company> companies = companyRepo.findCompaniesByEmittedGasesId(List.of(1));
        companies.forEach(System.out::println);
    }

    @Test
    void testAddCompany() {
        int id = companyRepo.addCompany(
                "test",
                new Date(),
                "test",
                1.0f,
                1.0f,
                "test",
                "test",
                "test",
                "test",
                "test",
                "test",
                "test",
                "test",
                "test",
                "test"
        );
        System.out.println("Added company id: " + id);
    }
}