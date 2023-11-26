package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.SensorGas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Date;

public interface SensorGasRepository extends JpaRepository<SensorGas, Integer> {

    /**
     *  Процедура добавления нового датчика газа с производителем и устройством
     */
    @Procedure(procedureName = "add_gas_sensor")
    Integer addGasSensor(
            @Param("sensor_name") String sensorName,
            @Param("sensor_sensitivity") Integer sensorSensitivity,
            @Param("sensor_mark") String sensorMark,
            @Param("brand_name") String brandName,
            @Param("device_long_life") Date deviceLongLife,
            @Param("device_date_installed") Date deviceDateInstalled,
            @Param("device_date_last_serv") Date deviceDateLastServ,
            @Param("device_serial_number") String deviceSerialNumber,
            @Param("company_id") Integer companyId
    );
}
