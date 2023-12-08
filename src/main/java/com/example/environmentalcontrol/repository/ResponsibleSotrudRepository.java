package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.ResponsibleSotrud;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ResponsibleSotrudRepository extends JpaRepository<ResponsibleSotrud, Integer> {

    /**
     * Получение всех ответственных за экологию сотрудников, на
     * предприятиях у которых есть превышения загрязняющих веществ в
     * выбросах в воду или воздух.
     */
    @Query(value = """
            SELECT rs.* FROM "ResponsibleSotrud" rs
            JOIN "Company" c on c."PK_Company" = rs."PK_Company"
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
            OR c."norm_water_emisson" < (
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
    List<ResponsibleSotrud> findEmployeesWithPollutionInWaterOrAir();

    /**
     * Находит сотрудника компании по ее id.
     * @param id id компании, сотрудника которой нужно найти
     * @return сотрудник компании
     */
    ResponsibleSotrud findByCompany_Id(Integer id);
}
