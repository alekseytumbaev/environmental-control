package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.SensorGas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface SensorGasRepository extends JpaRepository<SensorGas, Integer> {

    /**
     * Процедура добавления нового датчика газа с производителем и устройством
     */
    @Procedure(procedureName = "add_gas_sensor")
    Integer addGasSensor(
            @Param("sensor_name") String sensorName,
            @Param("sensor_sensitivity") Integer sensorSensitivity,
            @Param("sensor_mark") String sensorMark,
            @Param("brand_name") String brandName,
            @Param("device_long_life") LocalDate deviceLongLife,
            @Param("device_date_installed") LocalDate deviceDateInstalled,
            @Param("device_date_last_serv") LocalDate deviceDateLastServ,
            @Param("device_serial_number") String deviceSerialNumber,
            @Param("company_id") Integer companyId
    );

    @Query(value = """
            SELECT s.* FROM "SensorGas" s
            JOIN public."Device" D on s."PK_SensorGase" = D."PK_SensorGase"
            WHERE d."PK_Company" = :company_id
            """, nativeQuery = true)
    List<SensorGas> findAllByCompanyId(@Param("company_id") int companyId);
}
