package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.Date;
import java.util.List;

public interface CompanyRepository extends JpaRepository<Company, Integer> {

    /**
     * Получение предприятий, у которых содержание загрязняющих
     * веществ в воздухе превышает норму.
     */
    @Query(value = """
            SELECT c.* FROM "Company" c
            WHERE c."norm_gas_emission" < (
                SELECT SUM(lg."Indicator" * pg."consentrate")
                FROM "LogGas" lg
                     JOIN "PollutionGases" pg ON lg."PK_PollutionGases" = pg."PK_PollutionGases"
                     JOIN (SELECT lg."PK_Device", MAX(lg."date_lastUpdate") AS latest_date
                           FROM "LogGas" lg
                                    JOIN "Device" d ON lg."PK_Device" = d."PK_Device"
                           WHERE d."PK_Company" = c."PK_Company"
                           GROUP BY lg."PK_Device") latest_logs
                          ON lg."PK_Device" = latest_logs."PK_Device" AND lg."date_lastUpdate" = latest_logs.latest_date
            )
            """, nativeQuery = true)
    List<Company> findCompaniesWithExcessiveAirPollution();

    /**
     * Получение предприятий, у которых содержание загрязняющих
     * веществ в воде превышает норму
     */
    @Query(value = """
            SELECT c.* FROM "Company" c
            WHERE c."norm_water_emisson" < (
                SELECT SUM(lw."Indecator")
                    FROM "LogWater" lw
                         JOIN (SELECT lw."PK_Device", MAX(lw."date_lastUpdate") AS latest_date
                               FROM "LogWater" lw
                                        JOIN "Device" d ON lw."PK_Device" = d."PK_Device"
                               WHERE d."PK_Company" = c."PK_Company"
                               GROUP BY lw."PK_Device") latest_logs
                              ON lw."PK_Device" = latest_logs."PK_Device" AND lw."date_lastUpdate" = latest_logs.latest_date
                )
            """, nativeQuery = true)
    List<Company> findCompaniesWithExcessiveWaterPollution();


    /**
     * Получение предприятий, которые выбрасывают данные виды газов
     */
    @Query(value = """
            SELECT DISTINCT c.* FROM "Company" c
                    JOIN "Device" d ON c."PK_Company" = d."PK_Company"
                    JOIN "LogGas" lg ON d."PK_Device" = lg."PK_Device"
                    WHERE lg."PK_PollutionGases" IN :emittedGasesId
            """, nativeQuery = true)
    List<Company> findCompaniesByEmittedGasesId(Collection<Integer> emittedGasesId);


    /**
     * Процедура для добавления нового предприятия вместе с типом, учредителем и ответственным.
     */
    @Procedure(procedureName = "add_company")
    Integer addCompany(
            @Param("company_name") String companyName,
            @Param("company_date_foundation") Date companyDateFoundation,
            @Param("purpose_production") String purposeProduction,
            @Param("company_norm_gas_emission") Float companyNormGasEmission,
            @Param("company_norm_water_emission") Float companyNormWaterEmission,
            @Param("type_name") String typeName,
            @Param("founder_fio") String founderFio,
            @Param("founder_number_phone") String founderNumberPhone,
            @Param("founder_seria_passport") String founderSeriaPassport,
            @Param("founder_number_passport") String founderNumberPassport,
            @Param("employee_fio") String employeeFio,
            @Param("employee_number_phone") String employeeNumberPhone,
            @Param("employee_seria_passport") String employeeSeriaPassport,
            @Param("employee_number_passport") String employeeNumberPassport,
            @Param("employee_type_activity") String employeeTypeActivity
    );

    /**
     * Процедура генерирующая показания для компании с переданным id.
     * Если у компании нет устройств, то устройства тоже будут сгенерированы.
     * Генерируется от 30 до 100 устройств, для каждого устройства генерируется от 30 до 100 показателей с периодичностью в один день.
     * То есть, за сегодняшний день, вчерашний, позавчерашний и так до 30.
     * Значения каждого лога - от 1 до 100.
     */
    @Procedure(procedureName = "generate_logs")
    void generateLogsForCompany(@Param("company_id") Integer companyId);
}
